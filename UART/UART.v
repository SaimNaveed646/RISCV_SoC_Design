`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2026 07:31:00 PM
// Design Name: 
// Module Name: UART
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


module UART #(
    parameter integer CLK_FREQ  = 50000000,
    parameter integer BAUD_RATE = 9600
)(
    input  wire       CLK,
    input  wire       Reset,

    // Transmitter interface
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output wire       tx,
    output wire       tx_busy,
    output wire       tx_done,

    // Receiver interface
    input  wire       rx,
    output wire [7:0] rx_data,
    output wire       rx_done,
    output wire       ParityError,
    output wire       FrameError
);

    wire BaudTick;

    // Baud rate generator
    BaudGenerator #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) baud_gen (
        .CLK(CLK),
        .Reset(Reset),
        .BaudTick(BaudTick)
    );

    // UART transmitter
    Transmitter transmitter (
        .CLK(CLK),
        .Reset(Reset),
        .BaudTick(BaudTick),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .busy(tx_busy),
        .tx_done(tx_done)
    );

    // UART receiver
    Receiver receiver (
        .CLK(CLK),
        .Reset(Reset),
        .BaudTick(BaudTick),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .ParityError(ParityError),
        .FrameError(FrameError)
    );

endmodule


