`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2026 02:27:19 AM
// Design Name: 
// Module Name: Imm_Gen
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


module Imm_Gen (
    input  wire [31:0] Instruction,  // 32-bit RISC-V Instruction
    output reg  [31:0] ImmOut        // 32-bit Sign-Extended Immediate Output
);

    wire [6:0] opcode = Instruction[6:0];

    // RISC-V Opcode Decoding
    localparam [6:0]
        OP_ITYPE  = 7'b0010011, // I-Type arithmetic 
        OP_LTYPE  = 7'b0000011, // Load instructions 
        OP_JALR   = 7'b1100111, // JALR
        OP_STYPE  = 7'b0100011, // Store instructions 
        OP_BTYPE  = 7'b1100011, // Branch instructions 
        OP_LUI    = 7'b0110111, // LUI
        OP_AUIPC  = 7'b0010111, // AUIPC
        OP_JAL    = 7'b1101111; // JAL

    always @(*) begin
        case (opcode)
            // I-Type Instructions (Sign extension of 12 bits)
            OP_ITYPE, OP_LTYPE, OP_JALR: begin
                ImmOut = {{20{Instruction[31]}}, Instruction[31:20]};
            end

            // S-Type Instructions (Sign extension of inst[31:25] and inst[11:7])
            OP_STYPE: begin
                ImmOut = {{20{Instruction[31]}}, Instruction[31:25], Instruction[11:7]};
            end

            // B-Type Instructions (Sign extension with 1-bit left shift / LSB = 0)
            OP_BTYPE: begin
                ImmOut = {{19{Instruction[31]}}, Instruction[31], Instruction[7], Instruction[30:25], Instruction[11:8], 1'b0};
            end

            // U-Type Instructions (Upper 20 bits shifted left by 12)
            OP_LUI, OP_AUIPC: begin
                ImmOut = {Instruction[31:12], 12'b0};
            end

            // J-Type Instructions (Sign extension with 1-bit left shift)
            OP_JAL: begin
                ImmOut = {{11{Instruction[31]}}, Instruction[31], Instruction[19:12], Instruction[20], Instruction[30:21], 1'b0};
            end

            // Default output for non-immediate instructions (e.g. R-Type)
            default: begin
                ImmOut = 32'b0;
            end
        endcase
    end

endmodule
