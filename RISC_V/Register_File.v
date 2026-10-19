`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2026 02:21:30 AM
// Design Name: 
// Module Name: Register_File
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


module Register_File (
    input  wire        clk,         
    input  wire        reset,       
    input  wire        RegWrite,    
    input  wire [4:0]  ReadReg1,    
    input  wire [4:0]  ReadReg2,    
    input  wire [4:0]  WriteReg,    
    input  wire [31:0] WriteData,   
    
    output wire [31:0] ReadData1,   
    output wire [31:0] ReadData2    
);

    // 32 Registers of 32-bit width
    reg [31:0] registers [31:0];
    integer i;

    // Write Operation (Synchronous on PosEdge Clock)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all 32 registers to 0
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end 
        else if (RegWrite && (WriteReg != 5'b00000)) begin
            // Register $0 (x0) is hardwired to 0, so write only if WriteReg != 0
            registers[WriteReg] <= WriteData;
        end
    end

    // Read Operation (Asynchronous / Combinationally MUXed)
    // Register $0 always returns 0
    assign ReadData1 = (ReadReg1 == 5'b00000) ? 32'b0 : registers[ReadReg1];
    assign ReadData2 = (ReadReg2 == 5'b00000) ? 32'b0 : registers[ReadReg2];

endmodule
