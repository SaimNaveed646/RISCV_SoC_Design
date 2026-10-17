# Baud Generator – UART

## 1. Overview

The Baud Generator is a Verilog hardware module used in a UART (Universal Asynchronous Receiver/Transmitter) system. It generates a periodic `BaudTick` signal based on the system clock frequency and the desired UART baud rate.

The `BaudTick` signal is used by the UART transmitter and receiver to control the timing of serial data transmission and reception.

## 2. Module Interface

**Module Name:** `BaudGenerator`

| Signal | Direction | Description |
|---|---|---|
| `CLK` | Input | System clock |
| `Reset` | Input | Active-high synchronous reset |
| `BaudTick` | Output | One-clock-cycle baud timing pulse |

### Parameters

| Parameter | Default Value | Description |
|---|---|---|
| `CLK_FREQ` | 50,000,000 Hz | System clock frequency |
| `BAUD_RATE` | 9,600 bps | Desired UART baud rate |

## 3. Timing Calculation

The approximate number of system clock cycles required for one UART bit period is:

`CLKS_PER_BIT = CLK_FREQ / BAUD_RATE`

For a 50 MHz system clock and a baud rate of 9600:

`CLKS_PER_BIT = 50,000,000 / 9,600 = 5208`

The approximate baud tick period is:

`Baud Tick Period = CLKS_PER_BIT / CLK_FREQ`

For the default configuration:

- **System clock frequency:** 50 MHz
- **System clock period:** 20 ns
- **Clock cycles per baud tick:** 5208
- **Baud tick period:** 104.16 µs
- **Effective baud rate:** Approximately 9600.61 baud

The small difference from exactly 9600 baud is caused by integer division in Verilog.
