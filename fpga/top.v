module top (input [3:0] SW, input P3_1, input P3_2, input P3_3, input P3_4, input P3_9, input P3_10, input P3_11, input P3_12, output P2_1, output P2_2, output P2_3, output P2_4);

    wire [7:0] i_in, i_out, io_in;
    assign io_in[0] = ~SW[0];
    assign io_in[1] = ~SW[1];
    assign i_in[0] = P3_1;
    assign i_in[1] = P3_2;
    assign i_in[2] = P3_3;
    assign i_in[3] = P3_4;
    assign i_in[4] = P3_12;
    assign i_in[5] = P3_11;
    assign i_in[6] = P3_10;
    assign i_in[7] = P3_9;
    assign P2_1 = ~i_out[0];
    assign P2_2 = ~i_out[1];
    assign P2_3 = ~i_out[2];
    assign P2_4 = ~i_out[3];

    tt_um_refil_01  t0(.ui_in(i_in), .uo_out(i_out), .uio_in(io_in));

endmodule