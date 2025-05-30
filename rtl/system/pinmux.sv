// Copyright lowRISC contributors
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// rtl/system/pinmux.sv is automatically generated using util/top_gen.py from rtl/templates/pinmux.sv.tpl
// Please make any edits to the template file.

module pinmux
  import sonata_pkg::*;
(
  // Clock and reset.
  input logic clk_i,
  input logic rst_ni,

  // GPIO IOs
  output [31:0] gpio_ios_o   [GPIO_NUM],
  input  [31:0] gpio_ios_i   [GPIO_NUM],
  input  [31:0] gpio_ios_en_i[GPIO_NUM],

  // PWM IOs
  input  [6:0] pwm_out_i   [PWM_NUM],
  input  [6:0] pwm_out_en_i[PWM_NUM],

  // UART IOs
  output uart_rx_o[UART_NUM],
  input  uart_tx_i   [UART_NUM],
  input  uart_tx_en_i[UART_NUM],

  // I2C IOs
  output i2c_scl_o   [I2C_NUM],
  input  i2c_scl_i   [I2C_NUM],
  input  i2c_scl_en_i[I2C_NUM],
  output i2c_sda_o   [I2C_NUM],
  input  i2c_sda_i   [I2C_NUM],
  input  i2c_sda_en_i[I2C_NUM],

  // SPI IOs
  output spi_cipo_o[SPI_NUM],
  input  spi_copi_i   [SPI_NUM],
  input  spi_copi_en_i[SPI_NUM],
  input  spi_sclk_i   [SPI_NUM],
  input  spi_sclk_en_i[SPI_NUM],
  input  [3:0] spi_cs_i   [SPI_NUM],
  input  [3:0] spi_cs_en_i[SPI_NUM],

  // Pin Signals
  input  sonata_in_pins_t  in_from_pins_i,
  output sonata_out_pins_t out_to_pins_o,
  output sonata_out_pins_t out_to_pins_en_o,

  input  sonata_inout_pins_t inout_from_pins_i,
  output sonata_inout_pins_t inout_to_pins_o,
  output sonata_inout_pins_t inout_to_pins_en_o,

  // TileLink interfaces.
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o
);
  // Local parameters.
  localparam int unsigned RegAddrWidth = 12;
  localparam int unsigned BusDataWidth = 32;

  // Register control signals.
  logic reg_we;
  logic [RegAddrWidth-1:0] reg_addr;
  /* verilator lint_off UNUSEDSIGNAL */
  logic [BusDataWidth-1:0] reg_wdata;
  /* verilator lint_on UNUSEDSIGNAL */
  logic [(BusDataWidth/8)-1:0] reg_be;
  logic [BusDataWidth-1:0] reg_rdata;

  logic unused_reg_signals;

  //TODO allow reading selector values.
  assign reg_rdata = BusDataWidth'('0);

  tlul_adapter_reg #(
    .RegAw            ( RegAddrWidth ),
    .RegDw            ( BusDataWidth ),
    .AccessLatency    ( 1            )
  ) u_tlul_adapter_reg (
    .clk_i        (clk_i),
    .rst_ni       (rst_ni),

    // TL-UL interface.
    .tl_i         (tl_i),
    .tl_o         (tl_o),

    // Control interface.
    .en_ifetch_i  (prim_mubi_pkg::MuBi4False),
    .intg_error_o (),

    // Register interface.
    .re_o         (),
    .we_o         (reg_we),
    .addr_o       (reg_addr),
    .wdata_o      (reg_wdata),
    .be_o         (reg_be),
    .busy_i       (1'b0),
    .rdata_i      (reg_rdata),
    .error_i      (1'b0)
  );

  // Outputs - Blocks IO is muxed to choose which drives the output and output
  // enable of a physical pin

  logic [1:0] ser0_tx_sel;
  logic ser0_tx_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ser0_tx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 0 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ser0_tx_sel <= 2'b10;
    end else begin
      if (reg_we & ser0_tx_sel_addressed) begin
        ser0_tx_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ser0_tx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      uart_tx_i[0]
    }),
    .sel_i(ser0_tx_sel),
    .out_o(out_to_pins_o[OUT_PIN_SER0_TX])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ser0_tx_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      uart_tx_en_i[0]
    }),
    .sel_i(ser0_tx_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_SER0_TX])
  );

  logic [2:0] ser1_tx_sel;
  logic ser1_tx_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ser1_tx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 0 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ser1_tx_sel <= 3'b10;
    end else begin
      if (reg_we & ser1_tx_sel_addressed) begin
        ser1_tx_sel <= reg_wdata[8+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ser1_tx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      uart_tx_i[1],
      uart_tx_i[2]
    }),
    .sel_i(ser1_tx_sel),
    .out_o(out_to_pins_o[OUT_PIN_SER1_TX])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ser1_tx_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      uart_tx_en_i[1],
      uart_tx_en_i[2]
    }),
    .sel_i(ser1_tx_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_SER1_TX])
  );

  logic [1:0] rs232_tx_sel;
  logic rs232_tx_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rs232_tx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 0 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rs232_tx_sel <= 2'b10;
    end else begin
      if (reg_we & rs232_tx_sel_addressed) begin
        rs232_tx_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rs232_tx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      uart_tx_i[2]
    }),
    .sel_i(rs232_tx_sel),
    .out_o(out_to_pins_o[OUT_PIN_RS232_TX])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rs232_tx_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      uart_tx_en_i[2]
    }),
    .sel_i(rs232_tx_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_RS232_TX])
  );

  logic [1:0] rs485_tx_sel;
  logic rs485_tx_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rs485_tx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 0 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select first mux input (constant) by default so pin is connected to no block initially
      rs485_tx_sel <= 2'b1;
    end else begin
      if (reg_we & rs485_tx_sel_addressed) begin
        rs485_tx_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rs485_tx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      uart_tx_i[2]
    }),
    .sel_i(rs485_tx_sel),
    .out_o(out_to_pins_o[OUT_PIN_RS485_TX])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rs485_tx_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      uart_tx_en_i[2]
    }),
    .sel_i(rs485_tx_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_RS485_TX])
  );

  logic [1:0] scl0_sel;
  logic scl0_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign scl0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 4 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      scl0_sel <= 2'b10;
    end else begin
      if (reg_we & scl0_sel_addressed) begin
        scl0_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) scl0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      i2c_scl_i[0]
    }),
    .sel_i(scl0_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_SCL0])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) scl0_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      i2c_scl_en_i[0]
    }),
    .sel_i(scl0_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_SCL0])
  );

  logic [1:0] sda0_sel;
  logic sda0_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign sda0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 4 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      sda0_sel <= 2'b10;
    end else begin
      if (reg_we & sda0_sel_addressed) begin
        sda0_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) sda0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      i2c_sda_i[0]
    }),
    .sel_i(sda0_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_SDA0])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) sda0_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      i2c_sda_en_i[0]
    }),
    .sel_i(sda0_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_SDA0])
  );

  logic [1:0] scl1_sel;
  logic scl1_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign scl1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 4 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      scl1_sel <= 2'b10;
    end else begin
      if (reg_we & scl1_sel_addressed) begin
        scl1_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) scl1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      i2c_scl_i[1]
    }),
    .sel_i(scl1_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_SCL1])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) scl1_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      i2c_scl_en_i[1]
    }),
    .sel_i(scl1_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_SCL1])
  );

  logic [1:0] sda1_sel;
  logic sda1_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign sda1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 4 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      sda1_sel <= 2'b10;
    end else begin
      if (reg_we & sda1_sel_addressed) begin
        sda1_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) sda1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      i2c_sda_i[1]
    }),
    .sel_i(sda1_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_SDA1])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) sda1_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      i2c_sda_en_i[1]
    }),
    .sel_i(sda1_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_SDA1])
  );

  logic [2:0] rph_g0_sel;
  logic rph_g0_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 8 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g0_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g0_sel_addressed) begin
        rph_g0_sel <= reg_wdata[0+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      i2c_sda_i[0],
      gpio_ios_i[0][0]
    }),
    .sel_i(rph_g0_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G0])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g0_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      i2c_sda_en_i[0],
      gpio_ios_en_i[0][0]
    }),
    .sel_i(rph_g0_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G0])
  );

  logic [2:0] rph_g1_sel;
  logic rph_g1_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 8 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g1_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g1_sel_addressed) begin
        rph_g1_sel <= reg_wdata[8+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      i2c_scl_i[0],
      gpio_ios_i[0][1]
    }),
    .sel_i(rph_g1_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G1])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g1_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      i2c_scl_en_i[0],
      gpio_ios_en_i[0][1]
    }),
    .sel_i(rph_g1_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G1])
  );

  logic [2:0] rph_g2_sda_sel;
  logic rph_g2_sda_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g2_sda_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 8 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g2_sda_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g2_sda_sel_addressed) begin
        rph_g2_sda_sel <= reg_wdata[16+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g2_sda_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      i2c_sda_i[1],
      gpio_ios_i[0][2]
    }),
    .sel_i(rph_g2_sda_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G2_SDA])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g2_sda_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      i2c_sda_en_i[1],
      gpio_ios_en_i[0][2]
    }),
    .sel_i(rph_g2_sda_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G2_SDA])
  );

  logic [2:0] rph_g3_scl_sel;
  logic rph_g3_scl_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g3_scl_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 8 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g3_scl_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g3_scl_sel_addressed) begin
        rph_g3_scl_sel <= reg_wdata[24+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g3_scl_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      i2c_scl_i[1],
      gpio_ios_i[0][3]
    }),
    .sel_i(rph_g3_scl_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G3_SCL])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g3_scl_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      i2c_scl_en_i[1],
      gpio_ios_en_i[0][3]
    }),
    .sel_i(rph_g3_scl_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G3_SCL])
  );

  logic [1:0] rph_g4_sel;
  logic rph_g4_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 12 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g4_sel <= 2'b10;
    end else begin
      if (reg_we & rph_g4_sel_addressed) begin
        rph_g4_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][4]
    }),
    .sel_i(rph_g4_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G4])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g4_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][4]
    }),
    .sel_i(rph_g4_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G4])
  );

  logic [1:0] rph_g5_sel;
  logic rph_g5_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g5_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 12 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g5_sel <= 2'b10;
    end else begin
      if (reg_we & rph_g5_sel_addressed) begin
        rph_g5_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g5_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][5]
    }),
    .sel_i(rph_g5_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G5])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g5_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][5]
    }),
    .sel_i(rph_g5_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G5])
  );

  logic [1:0] rph_g6_sel;
  logic rph_g6_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g6_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 12 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g6_sel <= 2'b10;
    end else begin
      if (reg_we & rph_g6_sel_addressed) begin
        rph_g6_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g6_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][6]
    }),
    .sel_i(rph_g6_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G6])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g6_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][6]
    }),
    .sel_i(rph_g6_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G6])
  );

  logic [2:0] rph_g7_sel;
  logic rph_g7_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g7_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 12 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g7_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g7_sel_addressed) begin
        rph_g7_sel <= reg_wdata[24+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g7_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_cs_i[1][1],
      gpio_ios_i[0][7]
    }),
    .sel_i(rph_g7_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G7])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g7_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_cs_en_i[1][1],
      gpio_ios_en_i[0][7]
    }),
    .sel_i(rph_g7_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G7])
  );

  logic [2:0] rph_g8_sel;
  logic rph_g8_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g8_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 16 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g8_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g8_sel_addressed) begin
        rph_g8_sel <= reg_wdata[0+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g8_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_cs_i[1][0],
      gpio_ios_i[0][8]
    }),
    .sel_i(rph_g8_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G8])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g8_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_cs_en_i[1][0],
      gpio_ios_en_i[0][8]
    }),
    .sel_i(rph_g8_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G8])
  );

  logic [1:0] rph_g9_sel;
  logic rph_g9_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g9_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 16 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g9_sel <= 2'b10;
    end else begin
      if (reg_we & rph_g9_sel_addressed) begin
        rph_g9_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g9_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][9]
    }),
    .sel_i(rph_g9_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G9])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g9_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][9]
    }),
    .sel_i(rph_g9_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G9])
  );

  logic [2:0] rph_g10_sel;
  logic rph_g10_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g10_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 16 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g10_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g10_sel_addressed) begin
        rph_g10_sel <= reg_wdata[16+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g10_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_copi_i[1],
      gpio_ios_i[0][10]
    }),
    .sel_i(rph_g10_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G10])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g10_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_copi_en_i[1],
      gpio_ios_en_i[0][10]
    }),
    .sel_i(rph_g10_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G10])
  );

  logic [2:0] rph_g11_sel;
  logic rph_g11_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g11_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 16 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g11_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g11_sel_addressed) begin
        rph_g11_sel <= reg_wdata[24+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g11_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_sclk_i[1],
      gpio_ios_i[0][11]
    }),
    .sel_i(rph_g11_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G11])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g11_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_sclk_en_i[1],
      gpio_ios_en_i[0][11]
    }),
    .sel_i(rph_g11_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G11])
  );

  logic [2:0] rph_g12_sel;
  logic rph_g12_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g12_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 20 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g12_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g12_sel_addressed) begin
        rph_g12_sel <= reg_wdata[0+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g12_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][12],
      pwm_out_i[0][0]
    }),
    .sel_i(rph_g12_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G12])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g12_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][12],
      pwm_out_en_i[0][0]
    }),
    .sel_i(rph_g12_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G12])
  );

  logic [2:0] rph_g13_sel;
  logic rph_g13_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g13_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 20 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g13_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g13_sel_addressed) begin
        rph_g13_sel <= reg_wdata[8+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g13_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][13],
      pwm_out_i[0][1]
    }),
    .sel_i(rph_g13_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G13])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g13_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][13],
      pwm_out_en_i[0][1]
    }),
    .sel_i(rph_g13_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G13])
  );

  logic [2:0] rph_txd0_sel;
  logic rph_txd0_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_txd0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 20 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_txd0_sel <= 3'b10;
    end else begin
      if (reg_we & rph_txd0_sel_addressed) begin
        rph_txd0_sel <= reg_wdata[16+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_txd0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      uart_tx_i[1],
      gpio_ios_i[0][14]
    }),
    .sel_i(rph_txd0_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_TXD0])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_txd0_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      uart_tx_en_i[1],
      gpio_ios_en_i[0][14]
    }),
    .sel_i(rph_txd0_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_TXD0])
  );

  logic [1:0] rph_rxd0_sel;
  logic rph_rxd0_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_rxd0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 20 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_rxd0_sel <= 2'b10;
    end else begin
      if (reg_we & rph_rxd0_sel_addressed) begin
        rph_rxd0_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_rxd0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][15]
    }),
    .sel_i(rph_rxd0_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_RXD0])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_rxd0_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][15]
    }),
    .sel_i(rph_rxd0_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_RXD0])
  );

  logic [2:0] rph_g16_sel;
  logic rph_g16_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g16_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 24 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g16_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g16_sel_addressed) begin
        rph_g16_sel <= reg_wdata[0+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g16_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_cs_i[2][2],
      gpio_ios_i[0][16]
    }),
    .sel_i(rph_g16_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G16])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g16_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_cs_en_i[2][2],
      gpio_ios_en_i[0][16]
    }),
    .sel_i(rph_g16_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G16])
  );

  logic [2:0] rph_g17_sel;
  logic rph_g17_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g17_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 24 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g17_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g17_sel_addressed) begin
        rph_g17_sel <= reg_wdata[8+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g17_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_cs_i[2][1],
      gpio_ios_i[0][17]
    }),
    .sel_i(rph_g17_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G17])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g17_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_cs_en_i[2][1],
      gpio_ios_en_i[0][17]
    }),
    .sel_i(rph_g17_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G17])
  );

  logic [3:0] rph_g18_sel;
  logic rph_g18_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g18_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 24 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g18_sel <= 4'b10;
    end else begin
      if (reg_we & rph_g18_sel_addressed) begin
        rph_g18_sel <= reg_wdata[16+:4];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) rph_g18_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_cs_i[2][0],
      gpio_ios_i[0][18],
      pwm_out_i[0][2]
    }),
    .sel_i(rph_g18_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G18])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) rph_g18_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_cs_en_i[2][0],
      gpio_ios_en_i[0][18],
      pwm_out_en_i[0][2]
    }),
    .sel_i(rph_g18_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G18])
  );

  logic [2:0] rph_g19_sel;
  logic rph_g19_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g19_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 24 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g19_sel <= 3'b10;
    end else begin
      if (reg_we & rph_g19_sel_addressed) begin
        rph_g19_sel <= reg_wdata[24+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g19_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][19],
      pwm_out_i[0][3]
    }),
    .sel_i(rph_g19_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G19])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) rph_g19_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][19],
      pwm_out_en_i[0][3]
    }),
    .sel_i(rph_g19_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G19])
  );

  logic [3:0] rph_g20_sel;
  logic rph_g20_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g20_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 28 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g20_sel <= 4'b10;
    end else begin
      if (reg_we & rph_g20_sel_addressed) begin
        rph_g20_sel <= reg_wdata[0+:4];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) rph_g20_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_copi_i[2],
      gpio_ios_i[0][20],
      pwm_out_i[0][4]
    }),
    .sel_i(rph_g20_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G20])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) rph_g20_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_copi_en_i[2],
      gpio_ios_en_i[0][20],
      pwm_out_en_i[0][4]
    }),
    .sel_i(rph_g20_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G20])
  );

  logic [3:0] rph_g21_sel;
  logic rph_g21_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g21_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 28 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g21_sel <= 4'b10;
    end else begin
      if (reg_we & rph_g21_sel_addressed) begin
        rph_g21_sel <= reg_wdata[8+:4];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) rph_g21_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_sclk_i[2],
      gpio_ios_i[0][21],
      pwm_out_i[0][5]
    }),
    .sel_i(rph_g21_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G21])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) rph_g21_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_sclk_en_i[2],
      gpio_ios_en_i[0][21],
      pwm_out_en_i[0][5]
    }),
    .sel_i(rph_g21_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G21])
  );

  logic [1:0] rph_g22_sel;
  logic rph_g22_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g22_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 28 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g22_sel <= 2'b10;
    end else begin
      if (reg_we & rph_g22_sel_addressed) begin
        rph_g22_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g22_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][22]
    }),
    .sel_i(rph_g22_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G22])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g22_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][22]
    }),
    .sel_i(rph_g22_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G22])
  );

  logic [1:0] rph_g23_sel;
  logic rph_g23_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g23_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 28 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g23_sel <= 2'b10;
    end else begin
      if (reg_we & rph_g23_sel_addressed) begin
        rph_g23_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g23_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][23]
    }),
    .sel_i(rph_g23_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G23])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g23_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][23]
    }),
    .sel_i(rph_g23_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G23])
  );

  logic [1:0] rph_g24_sel;
  logic rph_g24_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g24_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 32 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g24_sel <= 2'b10;
    end else begin
      if (reg_we & rph_g24_sel_addressed) begin
        rph_g24_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g24_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][24]
    }),
    .sel_i(rph_g24_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G24])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g24_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][24]
    }),
    .sel_i(rph_g24_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G24])
  );

  logic [1:0] rph_g25_sel;
  logic rph_g25_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g25_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 32 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g25_sel <= 2'b10;
    end else begin
      if (reg_we & rph_g25_sel_addressed) begin
        rph_g25_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g25_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][25]
    }),
    .sel_i(rph_g25_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G25])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g25_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][25]
    }),
    .sel_i(rph_g25_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G25])
  );

  logic [1:0] rph_g26_sel;
  logic rph_g26_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g26_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 32 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g26_sel <= 2'b10;
    end else begin
      if (reg_we & rph_g26_sel_addressed) begin
        rph_g26_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g26_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][26]
    }),
    .sel_i(rph_g26_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G26])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g26_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][26]
    }),
    .sel_i(rph_g26_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G26])
  );

  logic [1:0] rph_g27_sel;
  logic rph_g27_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign rph_g27_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 32 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      rph_g27_sel <= 2'b10;
    end else begin
      if (reg_we & rph_g27_sel_addressed) begin
        rph_g27_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g27_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[0][27]
    }),
    .sel_i(rph_g27_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_RPH_G27])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) rph_g27_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[0][27]
    }),
    .sel_i(rph_g27_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_RPH_G27])
  );

  logic [1:0] ah_tmpio0_sel;
  logic ah_tmpio0_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 36 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio0_sel <= 2'b10;
    end else begin
      if (reg_we & ah_tmpio0_sel_addressed) begin
        ah_tmpio0_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ah_tmpio0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[1][0]
    }),
    .sel_i(ah_tmpio0_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO0])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ah_tmpio0_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[1][0]
    }),
    .sel_i(ah_tmpio0_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO0])
  );

  logic [2:0] ah_tmpio1_sel;
  logic ah_tmpio1_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 36 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio1_sel <= 3'b10;
    end else begin
      if (reg_we & ah_tmpio1_sel_addressed) begin
        ah_tmpio1_sel <= reg_wdata[8+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ah_tmpio1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      uart_tx_i[1],
      gpio_ios_i[1][1]
    }),
    .sel_i(ah_tmpio1_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO1])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ah_tmpio1_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      uart_tx_en_i[1],
      gpio_ios_en_i[1][1]
    }),
    .sel_i(ah_tmpio1_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO1])
  );

  logic [1:0] ah_tmpio2_sel;
  logic ah_tmpio2_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 36 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio2_sel <= 2'b10;
    end else begin
      if (reg_we & ah_tmpio2_sel_addressed) begin
        ah_tmpio2_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ah_tmpio2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[1][2]
    }),
    .sel_i(ah_tmpio2_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO2])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ah_tmpio2_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[1][2]
    }),
    .sel_i(ah_tmpio2_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO2])
  );

  logic [2:0] ah_tmpio3_sel;
  logic ah_tmpio3_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 36 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio3_sel <= 3'b10;
    end else begin
      if (reg_we & ah_tmpio3_sel_addressed) begin
        ah_tmpio3_sel <= reg_wdata[24+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ah_tmpio3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[1][3],
      pwm_out_i[0][0]
    }),
    .sel_i(ah_tmpio3_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO3])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ah_tmpio3_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[1][3],
      pwm_out_en_i[0][0]
    }),
    .sel_i(ah_tmpio3_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO3])
  );

  logic [1:0] ah_tmpio4_sel;
  logic ah_tmpio4_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 40 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio4_sel <= 2'b10;
    end else begin
      if (reg_we & ah_tmpio4_sel_addressed) begin
        ah_tmpio4_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ah_tmpio4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[1][4]
    }),
    .sel_i(ah_tmpio4_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO4])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ah_tmpio4_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[1][4]
    }),
    .sel_i(ah_tmpio4_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO4])
  );

  logic [2:0] ah_tmpio5_sel;
  logic ah_tmpio5_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio5_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 40 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio5_sel <= 3'b10;
    end else begin
      if (reg_we & ah_tmpio5_sel_addressed) begin
        ah_tmpio5_sel <= reg_wdata[8+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ah_tmpio5_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[1][5],
      pwm_out_i[0][1]
    }),
    .sel_i(ah_tmpio5_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO5])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ah_tmpio5_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[1][5],
      pwm_out_en_i[0][1]
    }),
    .sel_i(ah_tmpio5_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO5])
  );

  logic [2:0] ah_tmpio6_sel;
  logic ah_tmpio6_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio6_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 40 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio6_sel <= 3'b10;
    end else begin
      if (reg_we & ah_tmpio6_sel_addressed) begin
        ah_tmpio6_sel <= reg_wdata[16+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ah_tmpio6_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[1][6],
      pwm_out_i[0][2]
    }),
    .sel_i(ah_tmpio6_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO6])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ah_tmpio6_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[1][6],
      pwm_out_en_i[0][2]
    }),
    .sel_i(ah_tmpio6_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO6])
  );

  logic [1:0] ah_tmpio7_sel;
  logic ah_tmpio7_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio7_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 40 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio7_sel <= 2'b10;
    end else begin
      if (reg_we & ah_tmpio7_sel_addressed) begin
        ah_tmpio7_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ah_tmpio7_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[1][7]
    }),
    .sel_i(ah_tmpio7_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO7])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ah_tmpio7_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[1][7]
    }),
    .sel_i(ah_tmpio7_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO7])
  );

  logic [1:0] ah_tmpio8_sel;
  logic ah_tmpio8_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio8_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 44 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio8_sel <= 2'b10;
    end else begin
      if (reg_we & ah_tmpio8_sel_addressed) begin
        ah_tmpio8_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ah_tmpio8_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[1][8]
    }),
    .sel_i(ah_tmpio8_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO8])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ah_tmpio8_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[1][8]
    }),
    .sel_i(ah_tmpio8_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO8])
  );

  logic [2:0] ah_tmpio9_sel;
  logic ah_tmpio9_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio9_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 44 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio9_sel <= 3'b10;
    end else begin
      if (reg_we & ah_tmpio9_sel_addressed) begin
        ah_tmpio9_sel <= reg_wdata[8+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ah_tmpio9_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[1][9],
      pwm_out_i[0][3]
    }),
    .sel_i(ah_tmpio9_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO9])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ah_tmpio9_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[1][9],
      pwm_out_en_i[0][3]
    }),
    .sel_i(ah_tmpio9_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO9])
  );

  logic [3:0] ah_tmpio10_sel;
  logic ah_tmpio10_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio10_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 44 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio10_sel <= 4'b10;
    end else begin
      if (reg_we & ah_tmpio10_sel_addressed) begin
        ah_tmpio10_sel <= reg_wdata[16+:4];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) ah_tmpio10_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_cs_i[1][3],
      gpio_ios_i[1][10],
      pwm_out_i[0][4]
    }),
    .sel_i(ah_tmpio10_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO10])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) ah_tmpio10_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_cs_en_i[1][3],
      gpio_ios_en_i[1][10],
      pwm_out_en_i[0][4]
    }),
    .sel_i(ah_tmpio10_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO10])
  );

  logic [3:0] ah_tmpio11_sel;
  logic ah_tmpio11_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio11_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 44 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio11_sel <= 4'b10;
    end else begin
      if (reg_we & ah_tmpio11_sel_addressed) begin
        ah_tmpio11_sel <= reg_wdata[24+:4];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) ah_tmpio11_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_copi_i[1],
      gpio_ios_i[1][11],
      pwm_out_i[0][5]
    }),
    .sel_i(ah_tmpio11_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO11])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) ah_tmpio11_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_copi_en_i[1],
      gpio_ios_en_i[1][11],
      pwm_out_en_i[0][5]
    }),
    .sel_i(ah_tmpio11_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO11])
  );

  logic [1:0] ah_tmpio12_sel;
  logic ah_tmpio12_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio12_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 48 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio12_sel <= 2'b10;
    end else begin
      if (reg_we & ah_tmpio12_sel_addressed) begin
        ah_tmpio12_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ah_tmpio12_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[1][12]
    }),
    .sel_i(ah_tmpio12_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO12])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) ah_tmpio12_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[1][12]
    }),
    .sel_i(ah_tmpio12_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO12])
  );

  logic [2:0] ah_tmpio13_sel;
  logic ah_tmpio13_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign ah_tmpio13_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 48 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      ah_tmpio13_sel <= 3'b10;
    end else begin
      if (reg_we & ah_tmpio13_sel_addressed) begin
        ah_tmpio13_sel <= reg_wdata[8+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ah_tmpio13_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_sclk_i[1],
      gpio_ios_i[1][13]
    }),
    .sel_i(ah_tmpio13_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_AH_TMPIO13])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) ah_tmpio13_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_sclk_en_i[1],
      gpio_ios_en_i[1][13]
    }),
    .sel_i(ah_tmpio13_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_AH_TMPIO13])
  );

  logic [1:0] mb1_sel;
  logic mb1_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign mb1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 48 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      mb1_sel <= 2'b10;
    end else begin
      if (reg_we & mb1_sel_addressed) begin
        mb1_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_cs_i[2][3]
    }),
    .sel_i(mb1_sel),
    .out_o(out_to_pins_o[OUT_PIN_MB1])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb1_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_cs_en_i[2][3]
    }),
    .sel_i(mb1_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_MB1])
  );

  logic [1:0] mb2_sel;
  logic mb2_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign mb2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 48 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      mb2_sel <= 2'b10;
    end else begin
      if (reg_we & mb2_sel_addressed) begin
        mb2_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_sclk_i[2]
    }),
    .sel_i(mb2_sel),
    .out_o(out_to_pins_o[OUT_PIN_MB2])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb2_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_sclk_en_i[2]
    }),
    .sel_i(mb2_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_MB2])
  );

  logic [1:0] mb4_sel;
  logic mb4_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign mb4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 52 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      mb4_sel <= 2'b10;
    end else begin
      if (reg_we & mb4_sel_addressed) begin
        mb4_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_copi_i[2]
    }),
    .sel_i(mb4_sel),
    .out_o(out_to_pins_o[OUT_PIN_MB4])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb4_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_copi_en_i[2]
    }),
    .sel_i(mb4_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_MB4])
  );

  logic [1:0] mb5_sel;
  logic mb5_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign mb5_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 52 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      mb5_sel <= 2'b10;
    end else begin
      if (reg_we & mb5_sel_addressed) begin
        mb5_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb5_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      i2c_sda_i[1]
    }),
    .sel_i(mb5_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_MB5])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb5_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      i2c_sda_en_i[1]
    }),
    .sel_i(mb5_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_MB5])
  );

  logic [1:0] mb6_sel;
  logic mb6_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign mb6_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 52 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      mb6_sel <= 2'b10;
    end else begin
      if (reg_we & mb6_sel_addressed) begin
        mb6_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb6_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      i2c_scl_i[1]
    }),
    .sel_i(mb6_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_MB6])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb6_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      i2c_scl_en_i[1]
    }),
    .sel_i(mb6_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_MB6])
  );

  logic [1:0] mb7_sel;
  logic mb7_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign mb7_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 52 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      mb7_sel <= 2'b10;
    end else begin
      if (reg_we & mb7_sel_addressed) begin
        mb7_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb7_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      uart_tx_i[1]
    }),
    .sel_i(mb7_sel),
    .out_o(out_to_pins_o[OUT_PIN_MB7])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb7_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      uart_tx_en_i[1]
    }),
    .sel_i(mb7_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_MB7])
  );

  logic [1:0] mb10_sel;
  logic mb10_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign mb10_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 56 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      mb10_sel <= 2'b10;
    end else begin
      if (reg_we & mb10_sel_addressed) begin
        mb10_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb10_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      pwm_out_i[0][0]
    }),
    .sel_i(mb10_sel),
    .out_o(out_to_pins_o[OUT_PIN_MB10])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) mb10_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      pwm_out_en_i[0][0]
    }),
    .sel_i(mb10_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_MB10])
  );

  logic [2:0] pmod0_1_sel;
  logic pmod0_1_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod0_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 56 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod0_1_sel <= 3'b10;
    end else begin
      if (reg_we & pmod0_1_sel_addressed) begin
        pmod0_1_sel <= reg_wdata[8+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod0_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[2][0],
      spi_cs_i[1][0]
    }),
    .sel_i(pmod0_1_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD0_1])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod0_1_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[2][0],
      spi_cs_en_i[1][0]
    }),
    .sel_i(pmod0_1_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD0_1])
  );

  logic [4:0] pmod0_2_sel;
  logic pmod0_2_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod0_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 56 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod0_2_sel <= 5'b10;
    end else begin
      if (reg_we & pmod0_2_sel_addressed) begin
        pmod0_2_sel <= reg_wdata[16+:5];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(5)
  ) pmod0_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[2][1],
      spi_copi_i[1],
      pwm_out_i[0][1],
      uart_tx_i[1]
    }),
    .sel_i(pmod0_2_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD0_2])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(5)
  ) pmod0_2_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[2][1],
      spi_copi_en_i[1],
      pwm_out_en_i[0][1],
      uart_tx_en_i[1]
    }),
    .sel_i(pmod0_2_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD0_2])
  );

  logic [2:0] pmod0_3_sel;
  logic pmod0_3_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod0_3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 56 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod0_3_sel <= 3'b10;
    end else begin
      if (reg_we & pmod0_3_sel_addressed) begin
        pmod0_3_sel <= reg_wdata[24+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod0_3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[2][2],
      i2c_scl_i[0]
    }),
    .sel_i(pmod0_3_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD0_3])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod0_3_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[2][2],
      i2c_scl_en_i[0]
    }),
    .sel_i(pmod0_3_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD0_3])
  );

  logic [3:0] pmod0_4_sel;
  logic pmod0_4_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod0_4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 60 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod0_4_sel <= 4'b10;
    end else begin
      if (reg_we & pmod0_4_sel_addressed) begin
        pmod0_4_sel <= reg_wdata[0+:4];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) pmod0_4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[2][3],
      spi_sclk_i[1],
      i2c_sda_i[0]
    }),
    .sel_i(pmod0_4_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD0_4])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) pmod0_4_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[2][3],
      spi_sclk_en_i[1],
      i2c_sda_en_i[0]
    }),
    .sel_i(pmod0_4_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD0_4])
  );

  logic [1:0] pmod0_7_sel;
  logic pmod0_7_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod0_7_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 60 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod0_7_sel <= 2'b10;
    end else begin
      if (reg_we & pmod0_7_sel_addressed) begin
        pmod0_7_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmod0_7_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[2][4]
    }),
    .sel_i(pmod0_7_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD0_7])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmod0_7_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[2][4]
    }),
    .sel_i(pmod0_7_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD0_7])
  );

  logic [2:0] pmod0_8_sel;
  logic pmod0_8_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod0_8_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 60 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod0_8_sel <= 3'b10;
    end else begin
      if (reg_we & pmod0_8_sel_addressed) begin
        pmod0_8_sel <= reg_wdata[16+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod0_8_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[2][5],
      pwm_out_i[0][2]
    }),
    .sel_i(pmod0_8_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD0_8])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod0_8_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[2][5],
      pwm_out_en_i[0][2]
    }),
    .sel_i(pmod0_8_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD0_8])
  );

  logic [2:0] pmod0_9_sel;
  logic pmod0_9_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod0_9_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 60 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod0_9_sel <= 3'b10;
    end else begin
      if (reg_we & pmod0_9_sel_addressed) begin
        pmod0_9_sel <= reg_wdata[24+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod0_9_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[2][6],
      spi_cs_i[1][1]
    }),
    .sel_i(pmod0_9_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD0_9])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod0_9_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[2][6],
      spi_cs_en_i[1][1]
    }),
    .sel_i(pmod0_9_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD0_9])
  );

  logic [2:0] pmod0_10_sel;
  logic pmod0_10_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod0_10_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 64 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod0_10_sel <= 3'b10;
    end else begin
      if (reg_we & pmod0_10_sel_addressed) begin
        pmod0_10_sel <= reg_wdata[0+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod0_10_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[2][7],
      spi_cs_i[1][2]
    }),
    .sel_i(pmod0_10_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD0_10])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod0_10_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[2][7],
      spi_cs_en_i[1][2]
    }),
    .sel_i(pmod0_10_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD0_10])
  );

  logic [2:0] pmod1_1_sel;
  logic pmod1_1_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod1_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 64 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod1_1_sel <= 3'b10;
    end else begin
      if (reg_we & pmod1_1_sel_addressed) begin
        pmod1_1_sel <= reg_wdata[8+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod1_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[3][0],
      spi_cs_i[2][0]
    }),
    .sel_i(pmod1_1_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD1_1])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod1_1_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[3][0],
      spi_cs_en_i[2][0]
    }),
    .sel_i(pmod1_1_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD1_1])
  );

  logic [4:0] pmod1_2_sel;
  logic pmod1_2_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod1_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 64 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod1_2_sel <= 5'b10;
    end else begin
      if (reg_we & pmod1_2_sel_addressed) begin
        pmod1_2_sel <= reg_wdata[16+:5];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(5)
  ) pmod1_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[3][1],
      spi_copi_i[2],
      pwm_out_i[0][3],
      uart_tx_i[2]
    }),
    .sel_i(pmod1_2_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD1_2])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(5)
  ) pmod1_2_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[3][1],
      spi_copi_en_i[2],
      pwm_out_en_i[0][3],
      uart_tx_en_i[2]
    }),
    .sel_i(pmod1_2_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD1_2])
  );

  logic [2:0] pmod1_3_sel;
  logic pmod1_3_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod1_3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 64 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod1_3_sel <= 3'b10;
    end else begin
      if (reg_we & pmod1_3_sel_addressed) begin
        pmod1_3_sel <= reg_wdata[24+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod1_3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[3][2],
      i2c_scl_i[1]
    }),
    .sel_i(pmod1_3_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD1_3])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod1_3_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[3][2],
      i2c_scl_en_i[1]
    }),
    .sel_i(pmod1_3_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD1_3])
  );

  logic [3:0] pmod1_4_sel;
  logic pmod1_4_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod1_4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 68 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod1_4_sel <= 4'b10;
    end else begin
      if (reg_we & pmod1_4_sel_addressed) begin
        pmod1_4_sel <= reg_wdata[0+:4];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) pmod1_4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[3][3],
      spi_sclk_i[2],
      i2c_sda_i[1]
    }),
    .sel_i(pmod1_4_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD1_4])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) pmod1_4_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[3][3],
      spi_sclk_en_i[2],
      i2c_sda_en_i[1]
    }),
    .sel_i(pmod1_4_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD1_4])
  );

  logic [1:0] pmod1_7_sel;
  logic pmod1_7_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod1_7_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 68 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod1_7_sel <= 2'b10;
    end else begin
      if (reg_we & pmod1_7_sel_addressed) begin
        pmod1_7_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmod1_7_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[3][4]
    }),
    .sel_i(pmod1_7_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD1_7])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmod1_7_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[3][4]
    }),
    .sel_i(pmod1_7_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD1_7])
  );

  logic [2:0] pmod1_8_sel;
  logic pmod1_8_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod1_8_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 68 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod1_8_sel <= 3'b10;
    end else begin
      if (reg_we & pmod1_8_sel_addressed) begin
        pmod1_8_sel <= reg_wdata[16+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod1_8_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[3][5],
      pwm_out_i[0][4]
    }),
    .sel_i(pmod1_8_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD1_8])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod1_8_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[3][5],
      pwm_out_en_i[0][4]
    }),
    .sel_i(pmod1_8_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD1_8])
  );

  logic [2:0] pmod1_9_sel;
  logic pmod1_9_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod1_9_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 68 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod1_9_sel <= 3'b10;
    end else begin
      if (reg_we & pmod1_9_sel_addressed) begin
        pmod1_9_sel <= reg_wdata[24+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod1_9_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[3][6],
      spi_cs_i[2][1]
    }),
    .sel_i(pmod1_9_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD1_9])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod1_9_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[3][6],
      spi_cs_en_i[2][1]
    }),
    .sel_i(pmod1_9_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD1_9])
  );

  logic [2:0] pmod1_10_sel;
  logic pmod1_10_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmod1_10_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 72 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmod1_10_sel <= 3'b10;
    end else begin
      if (reg_we & pmod1_10_sel_addressed) begin
        pmod1_10_sel <= reg_wdata[0+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod1_10_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[3][7],
      spi_cs_i[2][2]
    }),
    .sel_i(pmod1_10_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMOD1_10])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) pmod1_10_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[3][7],
      spi_cs_en_i[2][2]
    }),
    .sel_i(pmod1_10_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMOD1_10])
  );

  logic [1:0] pmodc_1_sel;
  logic pmodc_1_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmodc_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 72 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmodc_1_sel <= 2'b10;
    end else begin
      if (reg_we & pmodc_1_sel_addressed) begin
        pmodc_1_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmodc_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[4][0]
    }),
    .sel_i(pmodc_1_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMODC_1])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmodc_1_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[4][0]
    }),
    .sel_i(pmodc_1_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMODC_1])
  );

  logic [1:0] pmodc_2_sel;
  logic pmodc_2_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmodc_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 72 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmodc_2_sel <= 2'b10;
    end else begin
      if (reg_we & pmodc_2_sel_addressed) begin
        pmodc_2_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmodc_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[4][1]
    }),
    .sel_i(pmodc_2_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMODC_2])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmodc_2_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[4][1]
    }),
    .sel_i(pmodc_2_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMODC_2])
  );

  logic [1:0] pmodc_3_sel;
  logic pmodc_3_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmodc_3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 72 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmodc_3_sel <= 2'b10;
    end else begin
      if (reg_we & pmodc_3_sel_addressed) begin
        pmodc_3_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmodc_3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[4][2]
    }),
    .sel_i(pmodc_3_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMODC_3])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmodc_3_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[4][2]
    }),
    .sel_i(pmodc_3_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMODC_3])
  );

  logic [1:0] pmodc_4_sel;
  logic pmodc_4_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmodc_4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 76 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmodc_4_sel <= 2'b10;
    end else begin
      if (reg_we & pmodc_4_sel_addressed) begin
        pmodc_4_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmodc_4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[4][3]
    }),
    .sel_i(pmodc_4_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMODC_4])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmodc_4_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[4][3]
    }),
    .sel_i(pmodc_4_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMODC_4])
  );

  logic [1:0] pmodc_5_sel;
  logic pmodc_5_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmodc_5_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 76 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmodc_5_sel <= 2'b10;
    end else begin
      if (reg_we & pmodc_5_sel_addressed) begin
        pmodc_5_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmodc_5_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[4][4]
    }),
    .sel_i(pmodc_5_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMODC_5])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmodc_5_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[4][4]
    }),
    .sel_i(pmodc_5_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMODC_5])
  );

  logic [1:0] pmodc_6_sel;
  logic pmodc_6_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign pmodc_6_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 76 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      pmodc_6_sel <= 2'b10;
    end else begin
      if (reg_we & pmodc_6_sel_addressed) begin
        pmodc_6_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmodc_6_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      gpio_ios_i[4][5]
    }),
    .sel_i(pmodc_6_sel),
    .out_o(inout_to_pins_o[INOUT_PIN_PMODC_6])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) pmodc_6_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      gpio_ios_en_i[4][5]
    }),
    .sel_i(pmodc_6_sel),
    .out_o(inout_to_pins_en_o[INOUT_PIN_PMODC_6])
  );

  logic [1:0] appspi_d0_sel;
  logic appspi_d0_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign appspi_d0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 76 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      appspi_d0_sel <= 2'b10;
    end else begin
      if (reg_we & appspi_d0_sel_addressed) begin
        appspi_d0_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) appspi_d0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_copi_i[0]
    }),
    .sel_i(appspi_d0_sel),
    .out_o(out_to_pins_o[OUT_PIN_APPSPI_D0])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) appspi_d0_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_copi_en_i[0]
    }),
    .sel_i(appspi_d0_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_APPSPI_D0])
  );

  logic [1:0] appspi_clk_sel;
  logic appspi_clk_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign appspi_clk_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 80 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      appspi_clk_sel <= 2'b10;
    end else begin
      if (reg_we & appspi_clk_sel_addressed) begin
        appspi_clk_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) appspi_clk_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_sclk_i[0]
    }),
    .sel_i(appspi_clk_sel),
    .out_o(out_to_pins_o[OUT_PIN_APPSPI_CLK])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) appspi_clk_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_sclk_en_i[0]
    }),
    .sel_i(appspi_clk_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_APPSPI_CLK])
  );

  logic [1:0] appspi_cs_sel;
  logic appspi_cs_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign appspi_cs_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 80 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      appspi_cs_sel <= 2'b10;
    end else begin
      if (reg_we & appspi_cs_sel_addressed) begin
        appspi_cs_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) appspi_cs_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_cs_i[0][0]
    }),
    .sel_i(appspi_cs_sel),
    .out_o(out_to_pins_o[OUT_PIN_APPSPI_CS])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) appspi_cs_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_cs_en_i[0][0]
    }),
    .sel_i(appspi_cs_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_APPSPI_CS])
  );

  logic [1:0] microsd_cmd_sel;
  logic microsd_cmd_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign microsd_cmd_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 80 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      microsd_cmd_sel <= 2'b10;
    end else begin
      if (reg_we & microsd_cmd_sel_addressed) begin
        microsd_cmd_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) microsd_cmd_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_copi_i[0]
    }),
    .sel_i(microsd_cmd_sel),
    .out_o(out_to_pins_o[OUT_PIN_MICROSD_CMD])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) microsd_cmd_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_copi_en_i[0]
    }),
    .sel_i(microsd_cmd_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_MICROSD_CMD])
  );

  logic [1:0] microsd_clk_sel;
  logic microsd_clk_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign microsd_clk_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 80 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      microsd_clk_sel <= 2'b10;
    end else begin
      if (reg_we & microsd_clk_sel_addressed) begin
        microsd_clk_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) microsd_clk_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_sclk_i[0]
    }),
    .sel_i(microsd_clk_sel),
    .out_o(out_to_pins_o[OUT_PIN_MICROSD_CLK])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) microsd_clk_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_sclk_en_i[0]
    }),
    .sel_i(microsd_clk_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_MICROSD_CLK])
  );

  logic [1:0] microsd_dat3_sel;
  logic microsd_dat3_sel_addressed;

  // Register addresses of 0x000 to 0x7ff are pin selectors, which are packed with 4 per 32-bit word.
  assign microsd_dat3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b0 &
    reg_addr[RegAddrWidth-2:0] == 84 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so that pin is connected to the first block that is specified in the configuration.
      microsd_dat3_sel <= 2'b10;
    end else begin
      if (reg_we & microsd_dat3_sel_addressed) begin
        microsd_dat3_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) microsd_dat3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0, // This is set to Z later when output enable is low.
      spi_cs_i[0][1]
    }),
    .sel_i(microsd_dat3_sel),
    .out_o(out_to_pins_o[OUT_PIN_MICROSD_DAT3])
  );

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) microsd_dat3_enable_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      spi_cs_en_i[0][1]
    }),
    .sel_i(microsd_dat3_sel),
    .out_o(out_to_pins_en_o[OUT_PIN_MICROSD_DAT3])
  );

  // Inputs - Physical pin inputs are muxed to particular block IO

  logic [1:0] gpio_ios_0_0_sel;
  logic gpio_ios_0_0_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 0 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_0_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_0_sel_addressed) begin
        gpio_ios_0_0_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G0]
    }),
    .sel_i(gpio_ios_0_0_sel),
    .out_o(gpio_ios_o[0][0])
  );

  logic [1:0] gpio_ios_0_1_sel;
  logic gpio_ios_0_1_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 0 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_1_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_1_sel_addressed) begin
        gpio_ios_0_1_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G1]
    }),
    .sel_i(gpio_ios_0_1_sel),
    .out_o(gpio_ios_o[0][1])
  );

  logic [1:0] gpio_ios_0_2_sel;
  logic gpio_ios_0_2_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 0 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_2_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_2_sel_addressed) begin
        gpio_ios_0_2_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G2_SDA]
    }),
    .sel_i(gpio_ios_0_2_sel),
    .out_o(gpio_ios_o[0][2])
  );

  logic [1:0] gpio_ios_0_3_sel;
  logic gpio_ios_0_3_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 0 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_3_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_3_sel_addressed) begin
        gpio_ios_0_3_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G3_SCL]
    }),
    .sel_i(gpio_ios_0_3_sel),
    .out_o(gpio_ios_o[0][3])
  );

  logic [1:0] gpio_ios_0_4_sel;
  logic gpio_ios_0_4_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 4 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_4_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_4_sel_addressed) begin
        gpio_ios_0_4_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G4]
    }),
    .sel_i(gpio_ios_0_4_sel),
    .out_o(gpio_ios_o[0][4])
  );

  logic [1:0] gpio_ios_0_5_sel;
  logic gpio_ios_0_5_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_5_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 4 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_5_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_5_sel_addressed) begin
        gpio_ios_0_5_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_5_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G5]
    }),
    .sel_i(gpio_ios_0_5_sel),
    .out_o(gpio_ios_o[0][5])
  );

  logic [1:0] gpio_ios_0_6_sel;
  logic gpio_ios_0_6_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_6_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 4 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_6_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_6_sel_addressed) begin
        gpio_ios_0_6_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_6_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G6]
    }),
    .sel_i(gpio_ios_0_6_sel),
    .out_o(gpio_ios_o[0][6])
  );

  logic [1:0] gpio_ios_0_7_sel;
  logic gpio_ios_0_7_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_7_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 4 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_7_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_7_sel_addressed) begin
        gpio_ios_0_7_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_7_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G7]
    }),
    .sel_i(gpio_ios_0_7_sel),
    .out_o(gpio_ios_o[0][7])
  );

  logic [1:0] gpio_ios_0_8_sel;
  logic gpio_ios_0_8_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_8_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 8 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_8_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_8_sel_addressed) begin
        gpio_ios_0_8_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_8_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G8]
    }),
    .sel_i(gpio_ios_0_8_sel),
    .out_o(gpio_ios_o[0][8])
  );

  logic [1:0] gpio_ios_0_9_sel;
  logic gpio_ios_0_9_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_9_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 8 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_9_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_9_sel_addressed) begin
        gpio_ios_0_9_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_9_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G9]
    }),
    .sel_i(gpio_ios_0_9_sel),
    .out_o(gpio_ios_o[0][9])
  );

  logic [1:0] gpio_ios_0_10_sel;
  logic gpio_ios_0_10_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_10_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 8 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_10_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_10_sel_addressed) begin
        gpio_ios_0_10_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_10_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G10]
    }),
    .sel_i(gpio_ios_0_10_sel),
    .out_o(gpio_ios_o[0][10])
  );

  logic [1:0] gpio_ios_0_11_sel;
  logic gpio_ios_0_11_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_11_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 8 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_11_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_11_sel_addressed) begin
        gpio_ios_0_11_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_11_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G11]
    }),
    .sel_i(gpio_ios_0_11_sel),
    .out_o(gpio_ios_o[0][11])
  );

  logic [1:0] gpio_ios_0_12_sel;
  logic gpio_ios_0_12_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_12_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 12 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_12_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_12_sel_addressed) begin
        gpio_ios_0_12_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_12_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G12]
    }),
    .sel_i(gpio_ios_0_12_sel),
    .out_o(gpio_ios_o[0][12])
  );

  logic [1:0] gpio_ios_0_13_sel;
  logic gpio_ios_0_13_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_13_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 12 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_13_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_13_sel_addressed) begin
        gpio_ios_0_13_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_13_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G13]
    }),
    .sel_i(gpio_ios_0_13_sel),
    .out_o(gpio_ios_o[0][13])
  );

  logic [1:0] gpio_ios_0_14_sel;
  logic gpio_ios_0_14_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_14_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 12 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_14_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_14_sel_addressed) begin
        gpio_ios_0_14_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_14_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_TXD0]
    }),
    .sel_i(gpio_ios_0_14_sel),
    .out_o(gpio_ios_o[0][14])
  );

  logic [1:0] gpio_ios_0_15_sel;
  logic gpio_ios_0_15_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_15_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 12 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_15_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_15_sel_addressed) begin
        gpio_ios_0_15_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_15_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_RXD0]
    }),
    .sel_i(gpio_ios_0_15_sel),
    .out_o(gpio_ios_o[0][15])
  );

  logic [1:0] gpio_ios_0_16_sel;
  logic gpio_ios_0_16_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_16_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 16 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_16_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_16_sel_addressed) begin
        gpio_ios_0_16_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_16_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G16]
    }),
    .sel_i(gpio_ios_0_16_sel),
    .out_o(gpio_ios_o[0][16])
  );

  logic [1:0] gpio_ios_0_17_sel;
  logic gpio_ios_0_17_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_17_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 16 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_17_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_17_sel_addressed) begin
        gpio_ios_0_17_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_17_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G17]
    }),
    .sel_i(gpio_ios_0_17_sel),
    .out_o(gpio_ios_o[0][17])
  );

  logic [1:0] gpio_ios_0_18_sel;
  logic gpio_ios_0_18_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_18_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 16 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_18_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_18_sel_addressed) begin
        gpio_ios_0_18_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_18_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G18]
    }),
    .sel_i(gpio_ios_0_18_sel),
    .out_o(gpio_ios_o[0][18])
  );

  logic [1:0] gpio_ios_0_19_sel;
  logic gpio_ios_0_19_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_19_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 16 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_19_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_19_sel_addressed) begin
        gpio_ios_0_19_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_19_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G19]
    }),
    .sel_i(gpio_ios_0_19_sel),
    .out_o(gpio_ios_o[0][19])
  );

  logic [1:0] gpio_ios_0_20_sel;
  logic gpio_ios_0_20_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_20_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 20 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_20_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_20_sel_addressed) begin
        gpio_ios_0_20_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_20_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G20]
    }),
    .sel_i(gpio_ios_0_20_sel),
    .out_o(gpio_ios_o[0][20])
  );

  logic [1:0] gpio_ios_0_21_sel;
  logic gpio_ios_0_21_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_21_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 20 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_21_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_21_sel_addressed) begin
        gpio_ios_0_21_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_21_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G21]
    }),
    .sel_i(gpio_ios_0_21_sel),
    .out_o(gpio_ios_o[0][21])
  );

  logic [1:0] gpio_ios_0_22_sel;
  logic gpio_ios_0_22_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_22_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 20 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_22_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_22_sel_addressed) begin
        gpio_ios_0_22_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_22_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G22]
    }),
    .sel_i(gpio_ios_0_22_sel),
    .out_o(gpio_ios_o[0][22])
  );

  logic [1:0] gpio_ios_0_23_sel;
  logic gpio_ios_0_23_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_23_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 20 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_23_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_23_sel_addressed) begin
        gpio_ios_0_23_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_23_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G23]
    }),
    .sel_i(gpio_ios_0_23_sel),
    .out_o(gpio_ios_o[0][23])
  );

  logic [1:0] gpio_ios_0_24_sel;
  logic gpio_ios_0_24_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_24_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 24 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_24_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_24_sel_addressed) begin
        gpio_ios_0_24_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_24_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G24]
    }),
    .sel_i(gpio_ios_0_24_sel),
    .out_o(gpio_ios_o[0][24])
  );

  logic [1:0] gpio_ios_0_25_sel;
  logic gpio_ios_0_25_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_25_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 24 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_25_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_25_sel_addressed) begin
        gpio_ios_0_25_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_25_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G25]
    }),
    .sel_i(gpio_ios_0_25_sel),
    .out_o(gpio_ios_o[0][25])
  );

  logic [1:0] gpio_ios_0_26_sel;
  logic gpio_ios_0_26_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_26_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 24 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_26_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_26_sel_addressed) begin
        gpio_ios_0_26_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_26_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G26]
    }),
    .sel_i(gpio_ios_0_26_sel),
    .out_o(gpio_ios_o[0][26])
  );

  logic [1:0] gpio_ios_0_27_sel;
  logic gpio_ios_0_27_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_0_27_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 24 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_0_27_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_0_27_sel_addressed) begin
        gpio_ios_0_27_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_0_27_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G27]
    }),
    .sel_i(gpio_ios_0_27_sel),
    .out_o(gpio_ios_o[0][27])
  );

  logic [1:0] gpio_ios_1_0_sel;
  logic gpio_ios_1_0_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 28 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_0_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_0_sel_addressed) begin
        gpio_ios_1_0_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO0]
    }),
    .sel_i(gpio_ios_1_0_sel),
    .out_o(gpio_ios_o[1][0])
  );

  logic [1:0] gpio_ios_1_1_sel;
  logic gpio_ios_1_1_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 28 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_1_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_1_sel_addressed) begin
        gpio_ios_1_1_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO1]
    }),
    .sel_i(gpio_ios_1_1_sel),
    .out_o(gpio_ios_o[1][1])
  );

  logic [1:0] gpio_ios_1_2_sel;
  logic gpio_ios_1_2_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 28 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_2_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_2_sel_addressed) begin
        gpio_ios_1_2_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO2]
    }),
    .sel_i(gpio_ios_1_2_sel),
    .out_o(gpio_ios_o[1][2])
  );

  logic [1:0] gpio_ios_1_3_sel;
  logic gpio_ios_1_3_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 28 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_3_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_3_sel_addressed) begin
        gpio_ios_1_3_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO3]
    }),
    .sel_i(gpio_ios_1_3_sel),
    .out_o(gpio_ios_o[1][3])
  );

  logic [1:0] gpio_ios_1_4_sel;
  logic gpio_ios_1_4_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 32 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_4_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_4_sel_addressed) begin
        gpio_ios_1_4_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO4]
    }),
    .sel_i(gpio_ios_1_4_sel),
    .out_o(gpio_ios_o[1][4])
  );

  logic [1:0] gpio_ios_1_5_sel;
  logic gpio_ios_1_5_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_5_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 32 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_5_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_5_sel_addressed) begin
        gpio_ios_1_5_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_5_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO5]
    }),
    .sel_i(gpio_ios_1_5_sel),
    .out_o(gpio_ios_o[1][5])
  );

  logic [1:0] gpio_ios_1_6_sel;
  logic gpio_ios_1_6_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_6_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 32 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_6_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_6_sel_addressed) begin
        gpio_ios_1_6_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_6_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO6]
    }),
    .sel_i(gpio_ios_1_6_sel),
    .out_o(gpio_ios_o[1][6])
  );

  logic [1:0] gpio_ios_1_7_sel;
  logic gpio_ios_1_7_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_7_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 32 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_7_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_7_sel_addressed) begin
        gpio_ios_1_7_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_7_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO7]
    }),
    .sel_i(gpio_ios_1_7_sel),
    .out_o(gpio_ios_o[1][7])
  );

  logic [1:0] gpio_ios_1_8_sel;
  logic gpio_ios_1_8_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_8_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 36 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_8_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_8_sel_addressed) begin
        gpio_ios_1_8_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_8_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO8]
    }),
    .sel_i(gpio_ios_1_8_sel),
    .out_o(gpio_ios_o[1][8])
  );

  logic [1:0] gpio_ios_1_9_sel;
  logic gpio_ios_1_9_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_9_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 36 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_9_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_9_sel_addressed) begin
        gpio_ios_1_9_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_9_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO9]
    }),
    .sel_i(gpio_ios_1_9_sel),
    .out_o(gpio_ios_o[1][9])
  );

  logic [1:0] gpio_ios_1_10_sel;
  logic gpio_ios_1_10_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_10_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 36 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_10_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_10_sel_addressed) begin
        gpio_ios_1_10_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_10_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO10]
    }),
    .sel_i(gpio_ios_1_10_sel),
    .out_o(gpio_ios_o[1][10])
  );

  logic [1:0] gpio_ios_1_11_sel;
  logic gpio_ios_1_11_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_11_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 36 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_11_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_11_sel_addressed) begin
        gpio_ios_1_11_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_11_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO11]
    }),
    .sel_i(gpio_ios_1_11_sel),
    .out_o(gpio_ios_o[1][11])
  );

  logic [1:0] gpio_ios_1_12_sel;
  logic gpio_ios_1_12_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_12_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 40 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_12_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_12_sel_addressed) begin
        gpio_ios_1_12_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_12_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO12]
    }),
    .sel_i(gpio_ios_1_12_sel),
    .out_o(gpio_ios_o[1][12])
  );

  logic [1:0] gpio_ios_1_13_sel;
  logic gpio_ios_1_13_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_1_13_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 40 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_1_13_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_1_13_sel_addressed) begin
        gpio_ios_1_13_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_1_13_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_AH_TMPIO13]
    }),
    .sel_i(gpio_ios_1_13_sel),
    .out_o(gpio_ios_o[1][13])
  );

  logic [1:0] gpio_ios_2_0_sel;
  logic gpio_ios_2_0_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_2_0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 40 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_2_0_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_2_0_sel_addressed) begin
        gpio_ios_2_0_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_2_0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD0_1]
    }),
    .sel_i(gpio_ios_2_0_sel),
    .out_o(gpio_ios_o[2][0])
  );

  logic [1:0] gpio_ios_2_1_sel;
  logic gpio_ios_2_1_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_2_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 40 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_2_1_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_2_1_sel_addressed) begin
        gpio_ios_2_1_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_2_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD0_2]
    }),
    .sel_i(gpio_ios_2_1_sel),
    .out_o(gpio_ios_o[2][1])
  );

  logic [1:0] gpio_ios_2_2_sel;
  logic gpio_ios_2_2_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_2_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 44 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_2_2_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_2_2_sel_addressed) begin
        gpio_ios_2_2_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_2_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD0_3]
    }),
    .sel_i(gpio_ios_2_2_sel),
    .out_o(gpio_ios_o[2][2])
  );

  logic [1:0] gpio_ios_2_3_sel;
  logic gpio_ios_2_3_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_2_3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 44 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_2_3_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_2_3_sel_addressed) begin
        gpio_ios_2_3_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_2_3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD0_4]
    }),
    .sel_i(gpio_ios_2_3_sel),
    .out_o(gpio_ios_o[2][3])
  );

  logic [1:0] gpio_ios_2_4_sel;
  logic gpio_ios_2_4_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_2_4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 44 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_2_4_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_2_4_sel_addressed) begin
        gpio_ios_2_4_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_2_4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD0_7]
    }),
    .sel_i(gpio_ios_2_4_sel),
    .out_o(gpio_ios_o[2][4])
  );

  logic [1:0] gpio_ios_2_5_sel;
  logic gpio_ios_2_5_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_2_5_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 44 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_2_5_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_2_5_sel_addressed) begin
        gpio_ios_2_5_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_2_5_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD0_8]
    }),
    .sel_i(gpio_ios_2_5_sel),
    .out_o(gpio_ios_o[2][5])
  );

  logic [1:0] gpio_ios_2_6_sel;
  logic gpio_ios_2_6_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_2_6_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 48 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_2_6_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_2_6_sel_addressed) begin
        gpio_ios_2_6_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_2_6_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD0_9]
    }),
    .sel_i(gpio_ios_2_6_sel),
    .out_o(gpio_ios_o[2][6])
  );

  logic [1:0] gpio_ios_2_7_sel;
  logic gpio_ios_2_7_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_2_7_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 48 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_2_7_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_2_7_sel_addressed) begin
        gpio_ios_2_7_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_2_7_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD0_10]
    }),
    .sel_i(gpio_ios_2_7_sel),
    .out_o(gpio_ios_o[2][7])
  );

  logic [1:0] gpio_ios_3_0_sel;
  logic gpio_ios_3_0_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_3_0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 48 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_3_0_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_3_0_sel_addressed) begin
        gpio_ios_3_0_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_3_0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD1_1]
    }),
    .sel_i(gpio_ios_3_0_sel),
    .out_o(gpio_ios_o[3][0])
  );

  logic [1:0] gpio_ios_3_1_sel;
  logic gpio_ios_3_1_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_3_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 48 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_3_1_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_3_1_sel_addressed) begin
        gpio_ios_3_1_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_3_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD1_2]
    }),
    .sel_i(gpio_ios_3_1_sel),
    .out_o(gpio_ios_o[3][1])
  );

  logic [1:0] gpio_ios_3_2_sel;
  logic gpio_ios_3_2_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_3_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 52 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_3_2_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_3_2_sel_addressed) begin
        gpio_ios_3_2_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_3_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD1_3]
    }),
    .sel_i(gpio_ios_3_2_sel),
    .out_o(gpio_ios_o[3][2])
  );

  logic [1:0] gpio_ios_3_3_sel;
  logic gpio_ios_3_3_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_3_3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 52 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_3_3_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_3_3_sel_addressed) begin
        gpio_ios_3_3_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_3_3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD1_4]
    }),
    .sel_i(gpio_ios_3_3_sel),
    .out_o(gpio_ios_o[3][3])
  );

  logic [1:0] gpio_ios_3_4_sel;
  logic gpio_ios_3_4_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_3_4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 52 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_3_4_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_3_4_sel_addressed) begin
        gpio_ios_3_4_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_3_4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD1_7]
    }),
    .sel_i(gpio_ios_3_4_sel),
    .out_o(gpio_ios_o[3][4])
  );

  logic [1:0] gpio_ios_3_5_sel;
  logic gpio_ios_3_5_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_3_5_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 52 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_3_5_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_3_5_sel_addressed) begin
        gpio_ios_3_5_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_3_5_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD1_8]
    }),
    .sel_i(gpio_ios_3_5_sel),
    .out_o(gpio_ios_o[3][5])
  );

  logic [1:0] gpio_ios_3_6_sel;
  logic gpio_ios_3_6_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_3_6_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 56 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_3_6_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_3_6_sel_addressed) begin
        gpio_ios_3_6_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_3_6_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD1_9]
    }),
    .sel_i(gpio_ios_3_6_sel),
    .out_o(gpio_ios_o[3][6])
  );

  logic [1:0] gpio_ios_3_7_sel;
  logic gpio_ios_3_7_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_3_7_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 56 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_3_7_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_3_7_sel_addressed) begin
        gpio_ios_3_7_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_3_7_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMOD1_10]
    }),
    .sel_i(gpio_ios_3_7_sel),
    .out_o(gpio_ios_o[3][7])
  );

  logic [1:0] gpio_ios_4_0_sel;
  logic gpio_ios_4_0_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_4_0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 56 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_4_0_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_4_0_sel_addressed) begin
        gpio_ios_4_0_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_4_0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMODC_1]
    }),
    .sel_i(gpio_ios_4_0_sel),
    .out_o(gpio_ios_o[4][0])
  );

  logic [1:0] gpio_ios_4_1_sel;
  logic gpio_ios_4_1_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_4_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 56 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_4_1_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_4_1_sel_addressed) begin
        gpio_ios_4_1_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_4_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMODC_2]
    }),
    .sel_i(gpio_ios_4_1_sel),
    .out_o(gpio_ios_o[4][1])
  );

  logic [1:0] gpio_ios_4_2_sel;
  logic gpio_ios_4_2_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_4_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 60 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_4_2_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_4_2_sel_addressed) begin
        gpio_ios_4_2_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_4_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMODC_3]
    }),
    .sel_i(gpio_ios_4_2_sel),
    .out_o(gpio_ios_o[4][2])
  );

  logic [1:0] gpio_ios_4_3_sel;
  logic gpio_ios_4_3_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_4_3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 60 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_4_3_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_4_3_sel_addressed) begin
        gpio_ios_4_3_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_4_3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMODC_4]
    }),
    .sel_i(gpio_ios_4_3_sel),
    .out_o(gpio_ios_o[4][3])
  );

  logic [1:0] gpio_ios_4_4_sel;
  logic gpio_ios_4_4_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_4_4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 60 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_4_4_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_4_4_sel_addressed) begin
        gpio_ios_4_4_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_4_4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMODC_5]
    }),
    .sel_i(gpio_ios_4_4_sel),
    .out_o(gpio_ios_o[4][4])
  );

  logic [1:0] gpio_ios_4_5_sel;
  logic gpio_ios_4_5_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_ios_4_5_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 60 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      gpio_ios_4_5_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_ios_4_5_sel_addressed) begin
        gpio_ios_4_5_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_ios_4_5_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_PMODC_6]
    }),
    .sel_i(gpio_ios_4_5_sel),
    .out_o(gpio_ios_o[4][5])
  );

  logic [1:0] uart_rx_0_sel;
  logic uart_rx_0_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign uart_rx_0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 64 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      uart_rx_0_sel <= 2'b10;
    end else begin
      if (reg_we & uart_rx_0_sel_addressed) begin
        uart_rx_0_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) uart_rx_0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b1,
      in_from_pins_i[IN_PIN_SER0_RX]
    }),
    .sel_i(uart_rx_0_sel),
    .out_o(uart_rx_o[0])
  );

  logic [5:0] uart_rx_1_sel;
  logic uart_rx_1_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign uart_rx_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 64 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      uart_rx_1_sel <= 6'b10;
    end else begin
      if (reg_we & uart_rx_1_sel_addressed) begin
        uart_rx_1_sel <= reg_wdata[8+:6];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(6)
  ) uart_rx_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b1,
      in_from_pins_i[IN_PIN_SER1_RX],
      inout_from_pins_i[INOUT_PIN_RPH_RXD0],
      inout_from_pins_i[INOUT_PIN_AH_TMPIO0],
      in_from_pins_i[IN_PIN_MB8],
      inout_from_pins_i[INOUT_PIN_PMOD0_3]
    }),
    .sel_i(uart_rx_1_sel),
    .out_o(uart_rx_o[1])
  );

  logic [4:0] uart_rx_2_sel;
  logic uart_rx_2_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign uart_rx_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 64 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      uart_rx_2_sel <= 5'b10;
    end else begin
      if (reg_we & uart_rx_2_sel_addressed) begin
        uart_rx_2_sel <= reg_wdata[16+:5];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(5)
  ) uart_rx_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b1,
      in_from_pins_i[IN_PIN_SER1_RX],
      in_from_pins_i[IN_PIN_RS232_RX],
      in_from_pins_i[IN_PIN_RS485_RX],
      inout_from_pins_i[INOUT_PIN_PMOD1_3]
    }),
    .sel_i(uart_rx_2_sel),
    .out_o(uart_rx_o[2])
  );

  logic [2:0] spi_cipo_0_sel;
  logic spi_cipo_0_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign spi_cipo_0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 64 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      spi_cipo_0_sel <= 3'b10;
    end else begin
      if (reg_we & spi_cipo_0_sel_addressed) begin
        spi_cipo_0_sel <= reg_wdata[24+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) spi_cipo_0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      in_from_pins_i[IN_PIN_APPSPI_D1],
      in_from_pins_i[IN_PIN_MICROSD_DAT0]
    }),
    .sel_i(spi_cipo_0_sel),
    .out_o(spi_cipo_o[0])
  );

  logic [3:0] spi_cipo_1_sel;
  logic spi_cipo_1_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign spi_cipo_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 68 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      spi_cipo_1_sel <= 4'b10;
    end else begin
      if (reg_we & spi_cipo_1_sel_addressed) begin
        spi_cipo_1_sel <= reg_wdata[0+:4];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) spi_cipo_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G9],
      inout_from_pins_i[INOUT_PIN_AH_TMPIO12],
      inout_from_pins_i[INOUT_PIN_PMOD0_3]
    }),
    .sel_i(spi_cipo_1_sel),
    .out_o(spi_cipo_o[1])
  );

  logic [3:0] spi_cipo_2_sel;
  logic spi_cipo_2_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign spi_cipo_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 68 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second mux input by default so block is connected to the first pin that is specified in the configuration.
      spi_cipo_2_sel <= 4'b10;
    end else begin
      if (reg_we & spi_cipo_2_sel_addressed) begin
        spi_cipo_2_sel <= reg_wdata[8+:4];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(4)
  ) spi_cipo_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      inout_from_pins_i[INOUT_PIN_RPH_G19],
      in_from_pins_i[IN_PIN_MB3],
      inout_from_pins_i[INOUT_PIN_PMOD1_3]
    }),
    .sel_i(spi_cipo_2_sel),
    .out_o(spi_cipo_o[2])
  );

  // Combining inputs for combinable inouts
  assign i2c_scl_o[0] =
    (scl0_sel == $bits(scl0_sel)'(2) ? inout_from_pins_i[INOUT_PIN_SCL0] : 1'b1) &
    (rph_g1_sel == $bits(rph_g1_sel)'(2) ? inout_from_pins_i[INOUT_PIN_RPH_G1] : 1'b1) &
    (pmod0_3_sel == $bits(pmod0_3_sel)'(8) ? inout_from_pins_i[INOUT_PIN_PMOD0_3] : 1'b1);
  assign i2c_sda_o[0] =
    (sda0_sel == $bits(sda0_sel)'(2) ? inout_from_pins_i[INOUT_PIN_SDA0] : 1'b1) &
    (rph_g0_sel == $bits(rph_g0_sel)'(2) ? inout_from_pins_i[INOUT_PIN_RPH_G0] : 1'b1) &
    (pmod0_4_sel == $bits(pmod0_4_sel)'(8) ? inout_from_pins_i[INOUT_PIN_PMOD0_4] : 1'b1);
  assign i2c_scl_o[1] =
    (scl1_sel == $bits(scl1_sel)'(2) ? inout_from_pins_i[INOUT_PIN_SCL1] : 1'b1) &
    (rph_g3_scl_sel == $bits(rph_g3_scl_sel)'(2) ? inout_from_pins_i[INOUT_PIN_RPH_G3_SCL] : 1'b1) &
    (mb6_sel == $bits(mb6_sel)'(2) ? inout_from_pins_i[INOUT_PIN_MB6] : 1'b1) &
    (pmod1_3_sel == $bits(pmod1_3_sel)'(8) ? inout_from_pins_i[INOUT_PIN_PMOD1_3] : 1'b1);
  assign i2c_sda_o[1] =
    (sda1_sel == $bits(sda1_sel)'(2) ? inout_from_pins_i[INOUT_PIN_SDA1] : 1'b1) &
    (rph_g2_sda_sel == $bits(rph_g2_sda_sel)'(2) ? inout_from_pins_i[INOUT_PIN_RPH_G2_SDA] : 1'b1) &
    (mb5_sel == $bits(mb5_sel)'(2) ? inout_from_pins_i[INOUT_PIN_MB5] : 1'b1) &
    (pmod1_4_sel == $bits(pmod1_4_sel)'(8) ? inout_from_pins_i[INOUT_PIN_PMOD1_4] : 1'b1);
endmodule
