`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2026 06:05:11 PM
// Design Name: 
// Module Name: BaudGenerator
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


module BaudGenerator #(
    parameter integer CLK_FREQ  = 50000000,
    parameter integer BAUD_RATE = 9600
)(
    input  wire CLK,
    input  wire Reset,
    output reg  BaudTick
);

    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    reg [31:0] counter;

    always @(posedge CLK) begin
        if (Reset) begin
            counter  <= 32'd0;
            BaudTick <= 1'b0;
        end
        else begin
            if (counter == CLKS_PER_BIT - 1) begin
                counter  <= 32'd0;
                BaudTick <= 1'b1;
            end
            else begin
                counter  <= counter + 1'b1;
                BaudTick <= 1'b0;
            end
        end
    end

endmodule

