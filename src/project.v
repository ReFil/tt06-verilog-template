/*
 * Copyright (c) 2024 Willow Herring
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_refil_01 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out [4:7]  = 0;
  assign uio_out = 0;
  assign uio_oe  = 0;

  four_bit_alu fba0(ui_in[0], ui_in[1], ui_in[2], ui_in[3], ui_in[4], ui_in[5], ui_in[6], ui_in[7], uio_in[0], uio_in[1], uo_out[0], uo_out[1], uo_out[2], uo_out[3]);

endmodule


module four_bit_multiplexer(input X0, input X1, input X2, input X3, input Y0, input Y1, input Y2, input Y3, input MUX, output OUT0, output OUT1, output OUT2, output OUT3);
    mux_cell m0 (X0, Y0, MUX, OUT0);
    mux_cell m1 (X1, Y1, MUX, OUT1);
    mux_cell m2 (X2, Y2, MUX, OUT2);
    mux_cell m3 (X3, Y3, MUX, OUT3);
endmodule

module single_bit_adder_xor(input X, input Y, input Cin, input Sub, output XY, output Cout, output XOR );

    wire N_1;
    wire N_2;
    wire N_3;

    xor_cell xor_1(Y, Sub, N_1);
    xor_cell xor_2(N_1, X, XOR);
    xor_cell xor_3(XOR, Cin, XY);

    nand_cell nand_1(Cin, XOR, N_2);
    nand_cell nand_2(X, N_1, N_3);
    nand_cell nand_3(N_2, N_3, Cout);

endmodule

module four_bit_adder_xor(input X0, input X1, input X2, input X3, input Y0, input Y1, input Y2, input Y3, input F, output XOR0, output XOR1, output XOR2, output XOR3, output XY0, output XY1, output XY2, output XY3);
    wire N_1;
    wire N_2;
    wire N_3;

    single_bit_adder_xor a0 (X0, Y0, F, F, XY0, N_1, XOR0);
    single_bit_adder_xor a1 (X1, Y1, N_1, F, XY1, N_2, XOR1);
    single_bit_adder_xor a2 (X2, Y2, N_2, F, XY2, N_3, XOR2);
    single_bit_adder_xor a3 (.X(X3), .Y(Y3), .Cin(N_3), .Sub(F), .XY(XY3), .XOR(XOR3));
endmodule


module four_bit_alu(input X0, input X1, input X2, input X3, input Y0, input Y1, input Y2, input Y3, input F0, input F1, output OUT0, output OUT1, output OUT2, output OUT3);
    wire XOR0;
    wire XOR1;
    wire XOR2;
    wire XOR3;
    wire XY0;
    wire XY1;
    wire XY2;
    wire XY3;

    four_bit_adder_xor fbax0 (X0, X1, X2, X3, Y0, Y1, Y2, Y3, F0, XOR0, XOR1, XOR2, XOR3, XY0, XY1, XY2, XY3);
    four_bit_multiplexer fbm0 (XY0, XY1, XY2, XY3, XOR0, XOR1, XOR2, XOR3, F1, OUT0, OUT1, OUT2, OUT3);

endmodule