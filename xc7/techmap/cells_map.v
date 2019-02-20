module RAMB18E1 (
	input CLKARDCLK,
	input CLKBWRCLK,
	input ENARDEN,
	input ENBWREN,
	input REGCEAREGCE,
	input REGCEB,
	input RSTRAMARSTRAM,
	input RSTRAMB,
	input RSTREGARSTREG,
	input RSTREGB,

	input [13:0] ADDRARDADDR,
	input [13:0] ADDRBWRADDR,
	input [15:0] DIADI,
	input [15:0] DIBDI,
	input [1:0] DIPADIP,
	input [1:0] DIPBDIP,
	input [1:0] WEA,
	input [3:0] WEBWE,

	output [15:0] DOADO,
	output [15:0] DOBDO,
	output [1:0] DOPADOP,
	output [1:0] DOPBDOP
);
	parameter INITP_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INITP_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;

	parameter INIT_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_08 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_09 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_0F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_10 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_11 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_12 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_13 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_14 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_15 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_16 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_17 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_18 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_19 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_20 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_21 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_22 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_23 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_24 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_25 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_26 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_27 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_28 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_29 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_30 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_31 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_32 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_33 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_34 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_35 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_36 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_37 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_38 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_39 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3F = 256'h0000000000000000000000000000000000000000000000000000000000000000;

	parameter IS_CLKARDCLK_INVERTED = 1'b0;
	parameter IS_CLKBWRCLK_INVERTED = 1'b0;
	parameter IS_ENARDEN_INVERTED = 1'b0;
	parameter IS_ENBWREN_INVERTED = 1'b0;
	parameter IS_RSTRAMARSTRAM_INVERTED = 1'b0;
	parameter IS_RSTRAMB_INVERTED = 1'b0;
	parameter IS_RSTREGARSTREG_INVERTED = 1'b0;
	parameter IS_RSTREGB_INVERTED = 1'b0;

	parameter RAM_MODE = "TDP";
    parameter SIM_DEVICE = "7SERIES";
	parameter integer DOA_REG = 0;
	parameter integer DOB_REG = 0;

	parameter integer READ_WIDTH_A = 0;
	parameter integer READ_WIDTH_B = 0;
	parameter integer WRITE_WIDTH_A = 0;
	parameter integer WRITE_WIDTH_B = 0;

	parameter WRITE_MODE_A = "WRITE_FIRST";
	parameter WRITE_MODE_B = "WRITE_FIRST";

  reg _TECHMAP_FAIL_;
  wire [1023:0] _TECHMAP_DO_ = "proc; clean";

  initial begin
    _TECHMAP_FAIL_ <= 0;
    if(READ_WIDTH_A != 0
        && READ_WIDTH_A != 1
        && READ_WIDTH_A != 4
        && READ_WIDTH_A != 9
        && READ_WIDTH_A != 18)
        _TECHMAP_FAIL_ <= 1;
    if(READ_WIDTH_B != 0
        && READ_WIDTH_B != 1
        && READ_WIDTH_B != 4
        && READ_WIDTH_B != 9
        && READ_WIDTH_B != 18)
        _TECHMAP_FAIL_ <= 1;
    if(WRITE_WIDTH_A != 0
        && WRITE_WIDTH_A != 1
        && WRITE_WIDTH_A != 4
        && WRITE_WIDTH_A != 9
        && WRITE_WIDTH_A != 18)
        _TECHMAP_FAIL_ <= 1;
    if(WRITE_WIDTH_B != 0
        && WRITE_WIDTH_B != 1
        && WRITE_WIDTH_B != 4
        && WRITE_WIDTH_B != 9
        && WRITE_WIDTH_B != 18)
        _TECHMAP_FAIL_ <= 1;
    if(WRITE_MODE_A != "WRITE_FIRST" && WRITE_MODE_A != "NO_CHANGE" && WRITE_MODE_A != "READ_FIRST")
        _TECHMAP_FAIL_ <= 1;
    if(WRITE_MODE_B != "WRITE_FIRST" && WRITE_MODE_B != "NO_CHANGE" && WRITE_MODE_B != "READ_FIRST")
        _TECHMAP_FAIL_ <= 1;
  end

  wire REGCLKA;
  wire REGCLKB;

  wire [7:0] WEBWE_WIDE = {
      WEBWE[3], WEBWE[3], WEBWE[2], WEBWE[2],
      WEBWE[1], WEBWE[1], WEBWE[0], WEBWE[0]};

  wire [3:0] WEA_WIDE = {WEA[1], WEA[1], WEA[0], WEA[0]};


  if (DOA_REG)
      assign REGCLKA = CLKARDCLK;
  else
      assign REGCLKA = 0;

  if (DOB_REG)
      assign REGCLKB = CLKARDCLK;
  else
      assign REGCLKB = 0;

  RAMB18E1_VPR #(
      .INITP_00(INITP_00),
      .INITP_01(INITP_01),
      .INITP_02(INITP_02),
      .INITP_03(INITP_03),
      .INITP_04(INITP_04),
      .INITP_05(INITP_05),
      .INITP_06(INITP_06),
      .INITP_07(INITP_07),

      .INIT_00(INIT_00),
      .INIT_01(INIT_01),
      .INIT_02(INIT_02),
      .INIT_03(INIT_03),
      .INIT_04(INIT_04),
      .INIT_05(INIT_05),
      .INIT_06(INIT_06),
      .INIT_07(INIT_07),
      .INIT_08(INIT_08),
      .INIT_09(INIT_09),
      .INIT_0A(INIT_0A),
      .INIT_0B(INIT_0B),
      .INIT_0C(INIT_0C),
      .INIT_0D(INIT_0D),
      .INIT_0E(INIT_0E),
      .INIT_0F(INIT_0F),
      .INIT_10(INIT_10),
      .INIT_11(INIT_11),
      .INIT_12(INIT_12),
      .INIT_13(INIT_13),
      .INIT_14(INIT_14),
      .INIT_15(INIT_15),
      .INIT_16(INIT_16),
      .INIT_17(INIT_17),
      .INIT_18(INIT_18),
      .INIT_19(INIT_19),
      .INIT_1A(INIT_1A),
      .INIT_1B(INIT_1B),
      .INIT_1C(INIT_1C),
      .INIT_1D(INIT_1D),
      .INIT_1E(INIT_1E),
      .INIT_1F(INIT_1F),
      .INIT_20(INIT_20),
      .INIT_21(INIT_21),
      .INIT_22(INIT_22),
      .INIT_23(INIT_23),
      .INIT_24(INIT_24),
      .INIT_25(INIT_25),
      .INIT_26(INIT_26),
      .INIT_27(INIT_27),
      .INIT_28(INIT_28),
      .INIT_29(INIT_29),
      .INIT_2A(INIT_2A),
      .INIT_2B(INIT_2B),
      .INIT_2C(INIT_2C),
      .INIT_2D(INIT_2D),
      .INIT_2E(INIT_2E),
      .INIT_2F(INIT_2F),
      .INIT_30(INIT_30),
      .INIT_31(INIT_31),
      .INIT_32(INIT_32),
      .INIT_33(INIT_33),
      .INIT_34(INIT_34),
      .INIT_35(INIT_35),
      .INIT_36(INIT_36),
      .INIT_37(INIT_37),
      .INIT_38(INIT_38),
      .INIT_39(INIT_39),
      .INIT_3A(INIT_3A),
      .INIT_3B(INIT_3B),
      .INIT_3C(INIT_3C),
      .INIT_3D(INIT_3D),
      .INIT_3E(INIT_3E),
      .INIT_3F(INIT_3F),

      .ZINV_CLKARDCLK(!IS_CLKARDCLK_INVERTED),
      .ZINV_CLKBWRCLK(!IS_CLKBWRCLK_INVERTED),
      .ZINV_ENARDEN(!IS_ENARDEN_INVERTED),
      .ZINV_ENBWREN(!IS_ENBWREN_INVERTED),
      .ZINV_RSTRAMARSTRAM(!IS_RSTRAMARSTRAM_INVERTED),
      .ZINV_RSTRAMB(!IS_RSTRAMB_INVERTED),
      .ZINV_RSTREGARSTREG(!IS_RSTREGARSTREG_INVERTED),
      .ZINV_RSTREGB(!IS_RSTREGB_INVERTED),
      .ZINV_REGCLKARDRCLK(!IS_CLKARDCLK_INVERTED),
      .ZINV_REGCLKB(!IS_CLKBWRCLK_INVERTED),
      .DOA_REG(DOA_REG),
      .DOB_REG(DOB_REG),
      .READ_WIDTH_A_1(READ_WIDTH_A == 1 || READ_WIDTH_A == 0),
      .READ_WIDTH_A_2(READ_WIDTH_A == 2),
      .READ_WIDTH_A_4(READ_WIDTH_A == 4),
      .READ_WIDTH_A_9(READ_WIDTH_A == 9),
      .READ_WIDTH_A_18(READ_WIDTH_A == 18),
      .READ_WIDTH_B_1(READ_WIDTH_B == 1 || READ_WIDTH_B == 0),
      .READ_WIDTH_B_2(READ_WIDTH_B == 2),
      .READ_WIDTH_B_4(READ_WIDTH_B == 4),
      .READ_WIDTH_B_9(READ_WIDTH_B == 9),
      .READ_WIDTH_B_18(READ_WIDTH_B == 18),
      .WRITE_WIDTH_A_1(WRITE_WIDTH_A == 1 || WRITE_WIDTH_A == 0),
      .WRITE_WIDTH_A_2(WRITE_WIDTH_A == 2),
      .WRITE_WIDTH_A_4(WRITE_WIDTH_A == 4),
      .WRITE_WIDTH_A_9(WRITE_WIDTH_A == 9),
      .WRITE_WIDTH_A_18(WRITE_WIDTH_A == 18),
      .WRITE_WIDTH_B_1(WRITE_WIDTH_B == 1 || WRITE_WIDTH_B == 0),
      .WRITE_WIDTH_B_2(WRITE_WIDTH_B == 2),
      .WRITE_WIDTH_B_4(WRITE_WIDTH_B == 4),
      .WRITE_WIDTH_B_9(WRITE_WIDTH_B == 9),
      .WRITE_WIDTH_B_18(WRITE_WIDTH_B == 18),
      .WRITE_MODE_A_NO_CHANGE(WRITE_MODE_A == "NO_CHANGE"),
      .WRITE_MODE_A_READ_FIRST(WRITE_MODE_A == "READ_FIRST"),
      .WRITE_MODE_B_NO_CHANGE(WRITE_MODE_B == "NO_CHANGE"),
      .WRITE_MODE_B_READ_FIRST(WRITE_MODE_B == "READ_FIRST"),
  ) _TECHMAP_REPLACE_ (
    .CLKARDCLK(CLKARDCLK),
    .REGCLKARDRCLK(REGCLKA),
    .CLKBWRCLK(CLKBWRCLK),
    .REGCLKB(REGCLKB),
    .ENARDEN(ENARDEN),
    .ENBWREN(ENBWREN),
    .REGCEAREGCE(REGCEAREGCE),
    .REGCEB(REGCEB),
    .RSTRAMARSTRAM(RSTRAMARSTRAM),
    .RSTRAMB(RSTRAMB),
    .RSTREGARSTREG(RSTREGARSTREG),
    .RSTREGB(RSTREGB),

    .ADDRATIEHIGH(2'b11),
    .ADDRARDADDR(ADDRARDADDR),
    .ADDRBTIEHIGH(2'b11),
    .ADDRBWRADDR(ADDRBWRADDR),
    .DIADI(DIADI),
    .DIBDI(DIBDI),
    .DIPADIP(DIPADIP),
    .DIPBDIP(DIPBDIP),
    .WEA(WEA_WIDE),
    .WEBWE(WEBWE_WIDE),

    .DOADO(DOADO),
    .DOBDO(DOBDO),
    .DOPADOP(DOPADOP),
    .DOPBDOP(DOPBDOP)
  );
endmodule
