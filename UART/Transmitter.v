`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2026 07:03:26 PM
// Design Name: 
// Module Name: Transmitter
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

module Transmitter (
    input  wire       CLK,
    input  wire       Reset,
    input  wire       BaudTick,
    input  wire       tx_start,
    input  wire [7:0] tx_data,

    output reg        tx,            //tx is the UART transmitter's serial output pin. It sends data one bit at a time.
    output reg        busy,
    output reg        tx_done
);

    // FSM states
    localparam IDLE   = 3'd0;
    localparam START  = 3'd1;
    localparam DATA   = 3'd2;
    localparam PARITY = 3'd3;
    localparam STOP   = 3'd4;

    reg [2:0] state;
    reg [7:0] data_reg;
    reg [2:0] bit_index;
    reg       parity_bit;

    always @(posedge CLK) begin
        if (Reset) begin
            state      <= IDLE;
            data_reg   <= 8'd0;
            bit_index  <= 3'd0;
            parity_bit <= 1'b0;
            tx         <= 1'b1;          //HIGH = 1 , No data is being transmitted at the moment.
            busy       <= 1'b0;
            tx_done    <= 1'b0;
        end
        else begin
            // Default: one-cycle completion pulse
            tx_done <= 1'b0;

            case (state)

                IDLE: begin
                    tx   <= 1'b1;
                    busy <= 1'b0;

                    if (tx_start) begin
                        data_reg   <= tx_data;
                        parity_bit <= ~(^tx_data);
                        bit_index  <= 3'd0;
                        busy       <= 1'b1;
                        tx         <= 1'b0;
                        state      <= START;
                    end
                end

                START: begin
                    if (BaudTick) begin
                        tx    <= data_reg[0];           //data ka pehla bit output par aata hai.
                        state <= DATA;
                    end
                end

                DATA: begin
                    if (BaudTick) begin
                        if (bit_index == 3'd7) begin
                            tx    <= parity_bit;
                            state <= PARITY;
                        end
                        else begin
                            bit_index <= bit_index + 1'b1;
                            tx        <= data_reg[bit_index + 1'b1];
                        end
                    end
                end

                PARITY: begin
                    if (BaudTick) begin
                        tx    <= 1'b1;
                        state <= STOP;
                    end
                end

                STOP: begin
                    if (BaudTick) begin
                        tx      <= 1'b1;
                        busy    <= 1'b0;
                        tx_done <= 1'b1;
                        state   <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                    tx    <= 1'b1;
                    busy  <= 1'b0;
                end

            endcase
        end
    end

endmodule


