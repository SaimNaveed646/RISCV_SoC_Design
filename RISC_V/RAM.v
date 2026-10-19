`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2026 02:50:47 AM
// Design Name: 
// Module Name: RAM
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


module Instruction_RAM (
    input  wire        clk,
    input  wire        enable,      // RAM Enable signal
    input  wire [31:0] Addr,        // PC Address (Word Addressed or Splitter 24-bit input)
    output wire [31:0] Instruction  // 32-bit Output Instruction
);

    // 2^10 = 1024 words RAM (24-bit addressing in circuit)
    reg [31:0] ram [1023:0];

    
    wire [9:0] word_addr = Addr[11:2];

    assign Instruction = (enable) ? ram[word_addr] : 32'b0;

endmodule
