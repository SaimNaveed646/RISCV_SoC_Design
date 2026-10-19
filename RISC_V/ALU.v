`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2026 02:09:14 AM
// Design Name: 
// Module Name: ALU
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


module ALU (
    input  wire [31:0] A,            // Read Data 1 / Register Input A
    input  wire [31:0] B,            // Read Data 2 / Immediate Input B
    input  wire [3:0]  ALUOperation, 
    
    output reg  [31:0] ALUResult,    // 32-bit Output Result
    output wire        Zero          // Zero Flag (Branch testing ke liye)
);

    // 4-bit ALU Operations Mapping
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
        case (ALUOperation)
            ALU_ADD:  ALUResult = A + B;
            ALU_SUB:  ALUResult = A - B;
            ALU_AND:  ALUResult = A & B;
            ALU_OR:   ALUResult = A | B;
            ALU_XOR:  ALUResult = A ^ B;
            ALU_SLL:  ALUResult = A << B[4:0];                    // Logical Left Shift
            ALU_SRL:  ALUResult = A >> B[4:0];                    // Logical Right Shift
            ALU_SRA:  ALUResult = $signed(A) >>> B[4:0];          // Arithmetic Right Shift
            
            // Set Less Than (Signed & Unsigned)
            ALU_SLT:  ALUResult = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            ALU_SLTU: ALUResult = (A < B) ? 32'd1 : 32'd0;
            
            // Branch Operations Output Logic
            ALU_BEQ:  ALUResult = (A == B) ? 32'd0 : 32'd1;        // Zero flag high hoga agar A == B
            ALU_BNE:  ALUResult = (A != B) ? 32'd0 : 32'd1;        // Zero flag high hoga agar A != B
            ALU_BGE:  ALUResult = ($signed(A) >= $signed(B)) ? 32'd0 : 32'd1;
            ALU_BGEU: ALUResult = (A >= B) ? 32'd0 : 32'd1;

            default:  ALUResult = 32'd0;
        endcase
    end

    // Zero Flag Logic (Branching Decisions ke liye active-high output)
    assign Zero = (ALUResult == 32'd0) ? 1'b1 : 1'b0;

endmodule
