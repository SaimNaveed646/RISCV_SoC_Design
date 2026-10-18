`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2026 07:10:40 PM
// Design Name: 
// Module Name: Receiver
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

`timescale 1ns / 1ps

module Receiver (
    input  wire       CLK,
    input  wire       Reset,
    input  wire       BaudTick,
    input  wire       rx,                    //HIGH = 1 , No data is being received at the moment.

    output reg  [7:0] rx_data,
    output reg        rx_done,
    output reg        ParityError,
    output reg        FrameError
);

    localparam IDLE   = 3'd0;
    localparam START  = 3'd1;
    localparam DATA   = 3'd2;
    localparam PARITY = 3'd3;
    localparam STOP   = 3'd4;

    reg [2:0] state;
    reg [7:0] data_buffer;
    reg [2:0] bit_index;
    reg       parity_bit;

    always @(posedge CLK) begin
        if (Reset) begin
            state       <= IDLE;
            data_buffer <= 8'd0;
            bit_index   <= 3'd0;
            parity_bit  <= 1'b0;
            rx_data     <= 8'd0;
            rx_done     <= 1'b0;
            ParityError <= 1'b0;
            FrameError  <= 1'b0;
        end
        else begin
            rx_done <= 1'b0;

            case (state)

                IDLE: begin
                    if (rx == 1'b0) begin
                        state     <= START;
                        bit_index <= 3'd0;
                    end
                end

                START: begin
                    if (BaudTick) begin
                        if (rx == 1'b0) begin
                            state <= DATA;
                        end
                        else begin
                            state <= IDLE;
                        end
                    end
                end

                DATA: begin
                    if (BaudTick) begin
                        data_buffer[bit_index] <= rx;

                        if (bit_index == 3'd7) begin
                            state <= PARITY;
                        end
                        else begin
                            bit_index <= bit_index + 1'b1;
                        end
                    end
                end

                PARITY: begin
                    if (BaudTick) begin
                        parity_bit  <= rx;
                        ParityError <= (rx != ~(^data_buffer));
                        state       <= STOP;
                    end
                end

                STOP: begin
                    if (BaudTick) begin
                        if (rx == 1'b1) begin
                            rx_data <= data_buffer;
                            rx_done <= 1'b1;
                        end

                        FrameError <= (rx != 1'b1);
                        state      <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule

