# Asynchronous FIFO — RTL Design & Verification

## Overview

This project implements and verifies an **Asynchronous FIFO (First-In, First-Out)** using Verilog.

An asynchronous FIFO is used to safely transfer data between two independent clock domains. Unlike a synchronous FIFO, the write and read sides operate using separate clocks and may run at different frequencies.

The design uses **Gray-coded read/write pointers** and **clock-domain synchronization** to safely communicate FIFO status information between the two clock domains.

## Key Features

* Dual-clock asynchronous FIFO architecture
* Independent write and read clock domains
* Parameterized FIFO memory
* Gray-code pointer synchronization
* Full-condition detection
* Empty-condition detection
* Separate write and read control logic
* Clock-domain crossing synchronization
* RTL testbench for functional verification
* Simulation waveform generation
* FIFO block diagram and verification results

## Architecture

The FIFO consists of two independent clock domains:

### Write Clock Domain

The write side is controlled by `wclk`.

The write logic:

1. Checks the `full` condition.
2. Writes data into FIFO memory when `w_en` is asserted.
3. Advances the binary write pointer.
4. Converts the binary write pointer to Gray code.
5. Synchronizes the Gray-coded write pointer information into the read clock domain.

### Read Clock Domain

The read side is controlled by `rclk`.

The read logic:

1. Checks the `empty` condition.
2. Reads data from FIFO memory when `r_en` is asserted.
3. Advances the binary read pointer.
4. Converts the binary read pointer to Gray code.
5. Synchronizes the Gray-coded read pointer information into the write clock domain.

### Clock Domain Crossing

Because the write and read clocks are asynchronous, directly passing binary counters between clock domains can cause metastability and incorrect status detection.

To avoid this, the design uses:

* Binary read/write pointers
* Gray-code conversion
* Multi-stage synchronizers
* Separate synchronization paths for each clock domain

Gray code is particularly useful because only one bit changes between consecutive pointer values, reducing the possibility of an inconsistent pointer being observed during clock-domain crossing.

## FIFO Status

The design generates two important status signals:

### `fifo_full`

Indicates that the FIFO cannot accept another write operation.

When the FIFO is full, additional write operations are prevented until data is read from the FIFO.

### `fifo_empty`

Indicates that the FIFO does not contain valid unread data.

When the FIFO is empty, additional read operations are prevented until new data is written.

## Project Structure

```text
Asynchronous-Fifo/
│
├── README.md
│
├── docs/
│   └── CummingsSNUG2002SJ_FIFO1.pdf
│
├── rtl/
│   ├── FIFO.v
│   ├── FIFO_memory.v
│   ├── ff_synchronization.v
│   ├── rptr_empty.v
│   └── wptr_full.v
│
├── sim/
│   └── tb_FIFO_Ultimate.v
│
├── waveform/
│   ├── dump.vcd
│   └── fifo_sim.vvp
│
└── results/
    ├── FIFO_BLOCK_DIAGRAM.png
    └── simulation screenshots
```

## RTL Modules

| Module                 | Description                                            |
| ---------------------- | ------------------------------------------------------ |
| `FIFO.v`               | Top-level asynchronous FIFO module                     |
| `FIFO_memory.v`        | FIFO storage/memory implementation                     |
| `ff_synchronization.v` | Synchronizes Gray-coded pointers between clock domains |
| `rptr_empty.v`         | Read pointer generation and empty detection            |
| `wptr_full.v`          | Write pointer generation and full detection            |

## Verification

The design is verified using a dedicated Verilog testbench.

The testbench exercises the FIFO using independent write and read clocks and verifies operations including:

* Reset behavior
* Data write operations
* Data read operations
* FIFO empty condition
* FIFO full condition
* Multiple consecutive writes
* Multiple consecutive reads
* Different clock-domain timing
* Data integrity between write and read operations

Simulation waveforms are generated in **VCD format** for inspection using a waveform viewer such as GTKWave.

## Simulation

A typical simulation flow is:

```text
RTL Design
    ↓
Testbench
    ↓
Compilation
    ↓
Simulation
    ↓
VCD Waveform
    ↓
Waveform Analysis
```

The generated waveform can be inspected to verify:

* Write pointer movement
* Read pointer movement
* Gray-coded pointers
* Synchronizer outputs
* FIFO full status
* FIFO empty status
* Write/read enable signals
* Data flow through the FIFO

## Design Concepts Demonstrated

This project demonstrates practical RTL and digital-design concepts including:

* Asynchronous FIFO architecture
* Clock Domain Crossing (CDC)
* Metastability considerations
* Gray-code counters
* Pointer synchronization
* FIFO memory design
* Full and empty detection
* RTL verification
* Simulation and waveform debugging

## Reference

The asynchronous FIFO architecture is based on concepts described in:

**Clifford E. Cummings — "Simulation and Synthesis Techniques for Asynchronous FIFO Design"**

The reference material used during the design study is included in the `docs/` directory.

## Results

The repository contains the FIFO block diagram, simulation screenshots, and generated waveform files in the `results/` and `waveform/` directories.

These results demonstrate the functional behavior of the FIFO across independent clock domains.

## Future Improvements

Possible future improvements include:

* Parameterizing FIFO data width and depth
* Adding assertions for protocol checking
* Adding automated self-checking scoreboard logic
* Adding functional coverage
* Testing additional clock-frequency ratios
* Adding reset-domain-crossing verification
* Adding automated simulation scripts
* Supporting SystemVerilog assertions and constrained-random verification

## Author

**Harsh Kumar**

This project was developed as part of an RTL/digital-design learning and verification portfolio, with a focus on asynchronous FIFO design and clock-domain crossing techniques.
