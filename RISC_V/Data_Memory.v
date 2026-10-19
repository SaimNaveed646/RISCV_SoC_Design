`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2026 02:58:01 AM
// Design Name: 
// Module Name: Data_Memory
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


module Data_Memory (
    input  wire        clk,
    input  wire        MemRead,     
    input  wire        MemWrite,    
    input  wire [31:0] Address,     
    input  wire [31:0] WriteData,   
    output wire [31:0] ReadData     
);

    // 1024 words Data RAM
    reg [31:0] dmem [1023:0];

    // Word Addressing
    wire [9:0] word_addr = Address[11:2];

    // Synchronous Write Operation
    always @(posedge clk) begin
        if (MemWrite) begin
            dmem[word_addr] <= WriteData;
        end
    end

    // Asynchronous Read Operation
    assign ReadData = (MemRead) ? dmem[word_addr] : 32'b0;

endmodule
