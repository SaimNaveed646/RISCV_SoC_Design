`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2026 07:38:00 PM
// Design Name: 
// Module Name: UART_Testbench
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

module UART_TestBench;

    reg CLK, Reset;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx, tx_busy, tx_done;
    wire [7:0] rx_data;
    wire rx_done, ParityError, FrameError;

    // UART loopback
    UART #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(9600)
    ) uut (
        .CLK(CLK),
        .Reset(Reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .rx(tx),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .ParityError(ParityError),
        .FrameError(FrameError)
    );

    // 50 MHz clock: 20 ns period
    initial CLK = 1'b0;
    always #10 CLK = ~CLK;

    initial begin
        Reset    = 1'b1;
        tx_start = 1'b0;
        tx_data  = 8'h00;

        repeat (5) @(posedge CLK);
        @(negedge CLK);
        Reset = 1'b0;


        repeat (10) @(posedge CLK);

        // Transmit byte A5
        @(negedge CLK);
        tx_data  = 8'hA5;
        tx_start = 1'b1;

        @(negedge CLK);
        tx_start = 1'b0;

        // Wait for receiver to finish
        wait (rx_done == 1'b1);
        #1;

        $display("Transmitted data = 0x%02h", tx_data);
        $display("Received data    = 0x%02h", rx_data);
        $display("ParityError      = %b", ParityError);
        $display("FrameError       = %b", FrameError);

        if ((rx_data == 8'hA5) &&
            (ParityError == 1'b0) &&
            (FrameError == 1'b0))
            $display("TEST PASS");
        else
            $display("TEST FAIL");

        #100;
        $finish;
    end

endmodule
