# RISC-V-Based System-on-Chip (SoC)

## Overview

This project focuses on the design and development of a RISC-V-based System-on-Chip (SoC) using Verilog and Xilinx Vivado.

The project currently includes a RISC-V CPU and a UART peripheral. System integration, bus interconnect, memory integration, and GPIO are planned for future development.

## System Architecture

<img width="681" height="610" alt="image" src="https://github.com/user-attachments/assets/7f81101e-e22e-4e8b-8716-617feac6046e" />

## Components

### 1. RISC-V CPU

The CPU fetches and executes instructions and performs arithmetic, logical, and control operations.

### 2. AXI Bus Interface

AXI (Advanced eXtensible Interface) is an on-chip communication protocol used to transfer data between compatible components.

Its functions include:

- Transferring read and write requests.
- Carrying address and data information.
- Coordinating transfers using handshake signals.
- Connecting the processor to memory and peripherals through an interconnect.

The selected AXI variant must match the interfaces supported by the CPU, memory, and peripherals.

### 3. Memory

Memory stores program instructions and data required by the processor.

Instruction memory supplies instructions to the CPU. Data memory stores values used during program execution when implemented separately.

### 4. UART Peripheral

UART (Universal Asynchronous Receiver/Transmitter) provides serial communication with external devices, such as a computer.

Data transmission process:

1. The CPU writes a byte to the UART data register.
2. The bus transfers the write request to the UART.
3. The UART converts the parallel byte into serial bits.
4. The UART transmits the data through its TX pin.

The RX pin can receive serial data from external devices.

### 5. GPIO Peripheral

GPIO (General-Purpose Input/Output) provides digital input and output functionality.

It can be used to control LEDs, read buttons, and interface with other digital devices.

## Data Flow

A typical UART transmission follows these steps:

1. The CPU fetches and executes program instructions.
2. The CPU prepares the required data in its registers.
3. The CPU issues a write request to the UART register address.
4. The bus interconnect routes the request to the UART.
5. The UART converts the byte from parallel to serial format.
6. The serial data is transmitted through the TX pin.

GPIO operations use register accesses to control digital output pins or read digital inputs.

## Tools and Technologies

- **HDL:** Verilog
- **Design Tool:** Xilinx Vivado
- **Processor Architecture:** RISC-V
- **Communication Interface:** UART
- **Planned Interconnect:** AXI-based interface
- **Target Platform:** Compatible Xilinx FPGA

## Conclusion

This project aims to develop a RISC-V-based SoC using Verilog and Xilinx Vivado. The current work includes the CPU and UART, with bus integration, memory connectivity, and GPIO planned as subsequent development stages.
