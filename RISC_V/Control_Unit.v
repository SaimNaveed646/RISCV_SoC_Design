`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2026 01:51:46 AM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(

    input  wire [6:0] opcode,        
    input  wire [2:0] funct3,        
    input  wire [6:0] funct7,        
    
    // Main Control Unit Outputs
    output reg        Branch,
    output reg        MemRead,
    output reg        MemtoReg,
    output reg        MemWrite,
    output reg        ALUSrc,
    output reg        RegWrite,
    
    // ALU Control Output
    output reg  [3:0] ALUOperation   
);

    
    // 1. MAIN CONTROL UNIT LOGIC
    // ------------------------------------------------------------------------
    // RISC-V Opcodes Definition
    localparam [6:0]
        OP_RTYPE  = 7'b0110011, 
        OP_ITYPE  = 7'b0010011, 
        OP_LTYPE  = 7'b0000011, 
        OP_STYPE  = 7'b0100011, 
        OP_BTYPE  = 7'b1100011, 
        OP_JAL    = 7'b1101111, 
        OP_JALR   = 7'b1100111, 
        OP_LUI    = 7'b0110111, 
        OP_AUIPC  = 7'b0010111; 

    always @(*) begin
       
        Branch   = 1'b0;
        MemRead  = 1'b0;
        MemtoReg = 1'b0;
        MemWrite = 1'b0;
        ALUSrc   = 1'b0;
        RegWrite = 1'b0;

        case (opcode)
            OP_RTYPE: begin
                RegWrite = 1'b1;
            end
            OP_ITYPE: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
            end
            OP_LTYPE: begin
                ALUSrc   = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead  = 1'b1;
            end
            OP_STYPE: begin
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
            end
            OP_BTYPE: begin
                Branch   = 1'b1;
            end
            OP_JAL, OP_JALR: begin
                RegWrite = 1'b1;
            end
            OP_LUI, OP_AUIPC: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
            end
            default: begin
                // All outputs remain 0
            end
        endcase
    end

    
    // 2. ALU CONTROL UNIT LOGIC
    // ------------------------------------------------------------------------
    // ALU Control Output Operations Mapping
    localparam [3:0]
        ALU_AND  = 4'b0000,
        ALU_OR   = 4'b0001,
        ALU_ADD  = 4'b0010,
        ALU_SUB  = 4'b0011,
        ALU_XOR  = 4'b0100,
        ALU_SLL  = 4'b0101,
        ALU_SRL  = 4'b0110,
        ALU_SRA  = 4'b0111,
        ALU_SLT  = 4'b1000,
        ALU_SLTU = 4'b1001,
        ALU_BEQ  = 4'b1010,
        ALU_BNE  = 4'b1011,
        ALU_BGE  = 4'b1100,
        ALU_BGEU = 4'b1101;

    always @(*) begin
        ALUOperation = ALU_ADD; // Default Fallback

        case (opcode)
            // Loads and Stores address calculation me hamesha ADD hota hai
            OP_LTYPE, OP_STYPE, OP_LUI, OP_AUIPC, OP_JAL, OP_JALR: begin
                ALUOperation = ALU_ADD;
            end

            // R-Type Instructions
            OP_RTYPE: begin
                case (funct3)
                    3'b000: ALUOperation = (funct7[5]) ? ALU_SUB : ALU_ADD; // SUB agar funct7[5]==1, warna ADD
                    3'b001: ALUOperation = ALU_SLL;
                    3'b010: ALUOperation = ALU_SLT;
                    3'b011: ALUOperation = ALU_SLTU;
                    3'b100: ALUOperation = ALU_XOR;
                    3'b101: ALUOperation = (funct7[5]) ? ALU_SRA : ALU_SRL; // SRA agar funct7[5]==1, warna SRL
                    3'b110: ALUOperation = ALU_OR;
                    3'b111: ALUOperation = ALU_AND;
                    default: ALUOperation = ALU_ADD;
                endcase
            end

            // I-Type Instructions
            OP_ITYPE: begin
                case (funct3)
                    3'b000: ALUOperation = ALU_ADD; // ADDI
                    3'b001: ALUOperation = ALU_SLL; // SLLI
                    3'b010: ALUOperation = ALU_SLT; // SLTI
                    3'b011: ALUOperation = ALU_SLTU;// SLTIU
                    3'b100: ALUOperation = ALU_XOR; // XORI
                    3'b101: ALUOperation = (funct7[5]) ? ALU_SRA : ALU_SRL; // SRAI / SRLI
                    3'b110: ALUOperation = ALU_OR;  // ORI
                    3'b111: ALUOperation = ALU_AND; // ANDI
                    default: ALUOperation = ALU_ADD;
                endcase
            end

            // Branch Instructions (B-Type)
            OP_BTYPE: begin
                case (funct3)
                    3'b000: ALUOperation = ALU_BEQ;
                    3'b001: ALUOperation = ALU_BNE;
                    3'b100: ALUOperation = ALU_SLT;  // BLT (Signed Compare)
                    3'b101: ALUOperation = ALU_BGE;  // BGE
                    3'b110: ALUOperation = ALU_SLTU; // BLTU (Unsigned Compare)
                    3'b111: ALUOperation = ALU_BGEU; // BGEU
                    default: ALUOperation = ALU_BEQ;
                endcase
            end

            default: ALUOperation = ALU_ADD;
        endcase
    end

endmodule


