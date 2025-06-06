// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "uartdpi.h"

#ifdef __linux__
#include <pty.h>
#elif __APPLE__
#include <util.h>
#endif

#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define EXIT_MESSAGE_LENGTH (32)

// This keeps the necessary uart state.
struct uartdpi_ctx {
  char ptyname[64];
  char exitstring[EXIT_MESSAGE_LENGTH];
  int exittracker;
  int host;
  int device;
  char tmp_read;
  FILE *log_file;
};

void *uartdpi_create(const char *name, const char *log_file_path) {
  struct uartdpi_ctx *ctx =
      (struct uartdpi_ctx *)malloc(sizeof(struct uartdpi_ctx));
  assert(ctx);

  int rv;

  // Initialize UART pseudo-terminal
  struct termios tty;
  cfmakeraw(&tty);

  rv = openpty(&ctx->host, &ctx->device, 0, &tty, 0);
  assert(rv != -1);

  rv = ttyname_r(ctx->device, ctx->ptyname, 64);
  assert(rv == 0 && "ttyname_r failed");

  int cur_flags = fcntl(ctx->host, F_GETFL, 0);
  assert(cur_flags != -1 && "Unable to read current flags.");
  int new_flags = fcntl(ctx->host, F_SETFL, cur_flags | O_NONBLOCK);
  assert(new_flags != -1 && "Unable to set FD flags");

  printf(
      "\n"
      "UART: Created %s for %s. Connect to it with any terminal program, e.g.\n"
      "$ screen %s\n",
      ctx->ptyname, name, ctx->ptyname);

  // Open log file (if requested)
  ctx->log_file = NULL;
  bool write_log_file = strlen(log_file_path) != 0;
  if (write_log_file) {
    if (strcmp(log_file_path, "-") == 0) {
      ctx->log_file = stdout;
      printf("UART: Additionally writing all UART output to STDOUT.\n");

    } else {
      FILE *log_file;
      log_file = fopen(log_file_path, "w");
      if (!log_file) {
        fprintf(stderr, "UART: Unable to open log file at %s: %s\n",
                log_file_path, strerror(errno));
      } else {
        // Switch log file output to line buffering to ensure lines written to
        // the UART device show up in the log file as soon as a newline
        // character is written.
        rv = setvbuf(log_file, NULL, _IOLBF, 0);
        assert(rv == 0);

        ctx->log_file = log_file;
        printf("UART: Additionally writing all UART output to '%s'.\n",
               log_file_path);
      }
    }
  }

  ctx->exittracker = 0;
  strncpy(ctx->exitstring, "Safe to exit simulator.\xd8\xaf\xfb\xa0\xc7\xe1\xa9\xd7", EXIT_MESSAGE_LENGTH);

  return (void *)ctx;
}

void uartdpi_close(void *ctx_void) {
  struct uartdpi_ctx *ctx = (struct uartdpi_ctx *)ctx_void;
  if (!ctx) {
    return;
  }

  close(ctx->host);
  close(ctx->device);

  if (ctx->log_file) {
    // Always ensure the log file is flushed (most important when writing
    // to STDOUT)
    fflush(ctx->log_file);
    if (ctx->log_file != stdout) {
      fclose(ctx->log_file);
    }
  }

  free(ctx);
}

int uartdpi_can_read(void *ctx_void) {
  struct uartdpi_ctx *ctx = (struct uartdpi_ctx *)ctx_void;
  if (ctx == NULL) {
    return 0;
  }
  int rv = read(ctx->host, &ctx->tmp_read, 1);
  return (rv == 1);
}

char uartdpi_read(void *ctx_void) {
  struct uartdpi_ctx *ctx = (struct uartdpi_ctx *)ctx_void;

  return ctx->tmp_read;
}

// Returns true when simulator should exit.
int uartdpi_write(void *ctx_void, char c) {
  int rv;
  struct uartdpi_ctx *ctx = (struct uartdpi_ctx *)ctx_void;
  if (ctx == NULL) {
    return 0;
  }

  rv = write(ctx->host, &c, 1);

  if (rv != 1) {
    fprintf(stderr, "UART: Write to pseudo-terminal failed: %s\n", strerror(errno));
  }

  if (ctx->log_file) {
    rv = fwrite(&c, sizeof(char), 1, ctx->log_file);

    if (rv != 1) {
      fprintf(stderr, "UART: Write to log file failed: %s\n", strerror(errno));
    }
  }

  if (c == ctx->exitstring[ctx->exittracker]) {
    ctx->exittracker++;
  } else {
    ctx->exittracker = 0;
  }

  // Don't require 0 to be sent at the end.
  return ctx->exittracker == (EXIT_MESSAGE_LENGTH - 1);
}
