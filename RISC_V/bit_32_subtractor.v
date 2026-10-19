`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2026 04:28:25 PM
// Design Name: 
// Module Name: bit_32_subtractor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module bit_32_subtractor (
    input  [31:0] A,
    input  [31:0] B,
    input         Bin,
    output [31:0] Diff,
    output        Bout
);

    wire [32:0] borrow;

    assign borrow[0] = Bin;
    assign Bout = borrow[32];

    genvar i;

    generate
        for (i = 0; i < 32; i = i + 1) begin : FS
            full_subtractor FS_inst (
                .a(A[i]),
                .b(B[i]),
                .bin(borrow[i]),
                .diff(Diff[i]),
                .bout(borrow[i+1])
            );
        end
    endgenerate

endmodule

