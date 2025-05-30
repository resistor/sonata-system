// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// tl_ifetch package generated by `tlgen.py` tool

package tl_ifetch_pkg;

  localparam logic [31:0] ADDR_SPACE_SRAM     = 32'h 00100000;
  localparam logic [31:0] ADDR_SPACE_HYPERRAM = 32'h 40000000;
  localparam logic [31:0] ADDR_SPACE_DBG_DEV  = 32'h b0000000;

  localparam logic [31:0] ADDR_MASK_SRAM     = 32'h 0003ffff;
  localparam logic [31:0] ADDR_MASK_HYPERRAM = 32'h 000fffff;
  localparam logic [31:0] ADDR_MASK_DBG_DEV  = 32'h 00000fff;

  localparam int N_HOST   = 1;
  localparam int N_DEVICE = 3;

  typedef enum int {
    TlSram = 0,
    TlHyperram = 1,
    TlDbgDev = 2
  } tl_device_e;

  typedef enum int {
    TlIbexIfetch = 0
  } tl_host_e;

endpackage
