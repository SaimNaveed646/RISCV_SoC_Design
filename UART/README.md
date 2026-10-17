# UART Implementation in Verilog

## 1. Project Overview

This project implements a UART (Universal Asynchronous Receiver/Transmitter) using Verilog HDL. It consists of three main modules:

- **Baud Generator:** Generates timing pulses for UART communication.
- **Transmitter:** Converts 8-bit parallel data into serial data.
- **Receiver:** Converts incoming serial data into 8-bit parallel data and checks parity and framing errors.

The design uses an FSM (Finite State Machine) to control the transmission and reception processes.

## 2. Baud Generator

### Overview

The Baud Generator generates a periodic `BaudTick` signal based on the system clock frequency and the desired UART baud rate.

The `BaudTick` signal controls the timing of serial data transmission and reception.

### Module Interface

**Module Name:** `BaudGenerator`

| Signal | Direction | Description |
|---|---|---|
| `CLK` | Input | System clock |
| `Reset` | Input | Active-high synchronous reset |
| `BaudTick` | Output | One-clock-cycle baud timing pulse |

### Parameters

| Parameter | Default Value | Description |
|---|---:|---|
| `CLK_FREQ` | 50,000,000 Hz | System clock frequency |
| `BAUD_RATE` | 9,600 bps | Desired UART baud rate |

### Timing Calculation

The number of system clock cycles required for one UART bit period is approximately:

`CLKS_PER_BIT = CLK_FREQ / BAUD_RATE`

For a 50 MHz system clock and a baud rate of 9600:

`CLKS_PER_BIT = 50,000,000 / 9,600 = 5208`

For the default configuration:

- **System clock frequency:** 50 MHz
- **System clock period:** 20 ns
- **Clock cycles per bit:** 5208
- **Baud tick interval:** Approximately 104.16 µs
- **Effective baud rate:** Approximately 9600.61 baud

The actual timing depends on the counter implementation and the clock frequency.

## 3. UART Transmitter

### Overview

The Transmitter converts 8-bit parallel data into a serial data stream using the UART frame format.

### UART Frame Format

Each transmitted frame consists of 11 bits.

| Field | Size | Description |
|---|---:|---|
| Start Bit | 1 bit | Logic `0` |
| Data Bits | 8 bits | Transmitted LSB first |
| Parity Bit | 1 bit | Odd parity |
| Stop Bit | 1 bit | Logic `1` |

### Module Interface

**Module Name:** `Transmitter`

#### Inputs

| Signal | Width | Description |
|---|---:|---|
| `CLK` | 1 bit | System clock |
| `Reset` | 1 bit | Synchronous active-high reset |
| `BaudTick` | 1 bit | Timing pulse controlling transmission |
| `tx_start` | 1 bit | Request to start transmission |
| `tx_data` | 8 bits | Parallel data to transmit |

#### Outputs

| Signal | Width | Description |
|---|---:|---|
| `tx` | 1 bit | Serial transmission
