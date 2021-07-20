`timescale 1ns/10ps
(* blackbox *)
(* keep *)
module ASSPR (
  input  wire        RAM1_CLK,
  input  wire [3:0]  RAM1_RM_af,
  input  wire        RAM1_RME_af,
  input  wire [35:0] RAM1_WR_DATA,
  input  wire [3:0]  RAM1_WR_BE,
  input  wire        RAM1_RD_EN,
  input  wire        RAM1_WR_EN,
  input  wire        RAM1_TEST1_af,
  input  wire [8:0]  RAM1_ADDR,
  input  wire [31:0] Amult1,
  input  wire [31:0] Bmult1,
  input  wire        wb_rst,
  input  wire        Valid_mult1,
  input  wire [2:0]  wb_adr,
  input  wire        arst,
  input  wire [7:0]  wb_dat_i,
  input  wire        wb_we,
  input  wire        wb_stb,
  input  wire        wb_cyc,
  input  wire        rxack_stick_en_i,
  input  wire        rxack_clr_i,
  input  wire        al_stick_en_i,
  input  wire        RAM2_P0_CLK,
  input  wire        al_clr_i,
  input  wire        RAM3_P0_WR_EN,
  input  wire [3:0]  RAM2_RM_af,
  input  wire        RAM2_RME_af,
  input  wire [31:0] RAM2_P0_WR_DATA,
  input  wire [3:0]  RAM2_P0_WR_BE,
  input  wire        RAM2_P0_WR_EN,
  input  wire        RAM2_TEST1_af,
  input  wire [8:0]  RAM2_P0_ADDR,
  input  wire        wb_clk,
  input  wire [8:0]  RAM2_P1_ADDR,
  input  wire        RAM2_P1_CLK,
  input  wire        RAM2_P1_RD_EN,
  input  wire        RAM3_P0_CLK,
  input  wire [3:0]  RAM3_RM_af,
  input  wire        RAM3_RME_af,
  input  wire [31:0] RAM3_P0_WR_DATA,
  input  wire        RAM3_TEST1_af,
  input  wire [8:0]  RAM3_P0_ADDR,
  input  wire        RAM3_P1_CLK,
  input  wire [8:0]  RAM3_P1_ADDR,
  input  wire        RAM3_P1_RD_EN,
  input  wire        SDA_i,
  input  wire        SCL_i,

  output wire [35:0] RAM1_RD_DATA,
  output wire [63:0] Cmult1,
  output wire [7:0]  wb_dat_o,
  output wire        wb_ack,
  output wire        wb_inta,
  output wire        rxack_o,
  output wire        al_o,
  output wire        tip_o,
  output wire        i2c_busy_o,
  output wire [31:0] RAM2_P1_RD_DATA,
  output wire [31:0] RAM3_P1_RD_DATA,
  output wire        SDA_oen,
  output wire        SDA_o,
  output wire        SCL_oen,
  output wire        SCL_o,
  output wire        DrivingI2cBusOut
);

endmodule
