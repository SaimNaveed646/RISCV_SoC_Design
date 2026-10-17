
# UART Implementation in Verilog

## 1. Overview

This project implements a UART (Universal Asynchronous Receiver/Transmitter) using Verilog HDL. The design consists of three main modules:

- **Baud Generator:** Generates timing pulses for UART communication.
- **Transmitter:** Converts 8-bit parallel data into serial data.
- **Receiver:** Converts incoming serial data into 8-bit parallel data and detects parity and framing errors.

The design uses finite state machines (FSMs) to control serial data transmission and reception.

## 2. Baud Generator

### Overview

The Baud Generator generates a periodic `BaudTick` signal based on the system clock frequency and the desired UART baud rate.

### Parameters

| Parameter | Default Value | Description |
|---|---:|---|
| `CLK_FREQ` | 50,000,000 Hz | System clock frequency |
| `BAUD_RATE` | 9,600 bps | Desired UART baud rate |

### Module Interface

| Signal | Direction | Description |
|---|---|---|
| `CLK` | Input | System clock |
| `Reset` | Input | Active-high synchronous reset |
| `BaudTick` | Output | Baud timing pulse |

### Timing Calculation

The number of system clock cycles per bit is calculated as:

`CLKS_PER_BIT = CLK_FREQ / BAUD_RATE`

For a 50 MHz clock and 9600 baud:

- **System clock period:** 20 ns
- **Clock cycles per bit:** 5208
- **Baud tick interval:** Approximately 104.16 µs
- **Effective baud rate:** Approximately 9600.61 baud, assuming one tick every 5208 clock cycles.

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
| `tx` | 1 bit | Serial transmission output |
| `busy` | 1 bit | Indicates an ongoing transmission |
| `tx_done` | 1 bit | One-clock-cycle completion pulse |

### Finite State Machine (FSM)

The transmitter uses five states.

| State | Operation |
|---|---|
| `IDLE` | Waits for `tx_start` and captures input data |
| `START` | Holds the start-bit interval and then outputs the first data bit |
| `DATA` | Transmits eight data bits, LSB first |
| `PARITY` | Transmits the generated odd parity bit |
| `STOP` | Holds the stop bit high and signals completion |

### Parity Generation

The parity bit is calculated using:

```verilog
parity_bit <= ~(^tx_data);
```

This generates odd parity across the data and parity fields.

## 4. UART Receiver

### Overview

The Receiver converts incoming serial data into an 8-bit parallel output. It validates the start bit, receives data bits, checks odd parity, and detects framing errors.

### Module Interface

**Module Name:** `Receiver`

#### Inputs

| Signal | Width | Description |
|---|---:|---|
| `CLK` | 1 bit | System clock |
| `Reset` | 1 bit | Synchronous active-high reset |
| `BaudTick` | 1 bit | Timing pulse controlling reception |
| `rx` | 1 bit | Incoming serial data input |

#### Outputs

| Signal | Width | Description |
|---|---:|---|
| `rx_data` | 8 bits | Received parallel data |
| `rx_done` | 1 bit | One-clock-cycle pulse for successful stop-bit detection |
| `ParityError` | 1 bit | Indicates a parity mismatch |
| `FrameError` | 1 bit | Indicates an invalid stop bit |

### UART Frame Format

The receiver expects an 11-bit UART frame.

| Field | Size | Description |
|---|---:|---|
| Start Bit | 1 bit | Logic `0` |
| Data Bits | 8 bits | Received LSB first |
| Parity Bit | 1 bit | Odd parity |
| Stop Bit | 1 bit | Logic `1` |

### Finite State Machine (FSM)

The receiver uses five states.

| State | Operation |
|---|---|
| `IDLE` | Waits for the incoming line to go low |
| `START` | Checks the start bit at a `BaudTick` |
| `DATA` | Receives eight data bits, LSB first |
| `PARITY` | Samples and checks the odd parity bit |
| `STOP` | Checks the stop bit and updates the output data |

### Parity Checking

The expected odd parity bit is calculated using:

```verilog
~(^data_buffer)
```

- `ParityError = 0`: Received parity matches the expected value.
- `ParityError = 1`: A parity mismatch is detected.

### Frame Error Detection

The receiver expects the stop bit to be logic `1`.

- `FrameError = 0`: Valid stop bit.
- `FrameError = 1`: Invalid stop bit.

The current implementation updates `rx_data` and asserts `rx_done` when the stop bit is valid, even if a parity error was detected.



