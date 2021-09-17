# Sequential CRC Generators

## Contents of Readme

1. About
2. Modules
3. Interface Description
4. CRC Configurations
5. Utilization
6. Simulation
7. Test
8. Status Information

[![Repo on GitLab](https://img.shields.io/badge/repo-GitLab-6C488A.svg)](LINK)
[![Repo on GitHub](https://img.shields.io/badge/repo-GitHub-3D76C2.svg)](LINK)

---

## About

This repository contains two sequential crc calculation modules.

## Modules

- `crc_static`: This module can only calculate crc value for one configuration.
- `crc_dynamic`: This module can be configured in use.

## Interface Description

|   Port   | Type | Width |  Description |
| :------: | :----: | :----: |  ------  |
| `clk` | I | 1 | System Clock |
| `rst` | I | 1 | Reset/Clear, required before new calculation |
| `data` | I | 1 | Serial Data Input |
| `valid` | I | 1 | `data` should be used for crc calculation |
| `crc_out` | O | `CRC_SIZE` | Calculated crc value |

I: Input  O: Output

## CRC Configurations

All of these should have the size of `CRC_SIZE`.

|   Parameter / Port   |  Description |
| :------: |  ------  |
| `initial_value` / `INITAL_VAL` | Initial value for crc calculation |
| `crc_poly` / `CRC_POLY`  | CRC polynomial, LSB is always 1  |
| `final_xor` / `FINAL_XOR`  | Final exor value, calculated value will be xored with this |

## Utilization

### `crc_static` CRC-16 CCITT-FALSE

**(Synthesized) Utilization on Artix-7:**

- Slice LUTs: 2 (as Logic)
- Slice Registers: 16 (as Flip Flop)

### `crc_static` CRC-32 POSIX

**(Synthesized) Utilization on Artix-7:**

- Slice LUTs: 39 (as Logic)
- Slice Registers: 32 (as Flip Flop)

### `crc_dynamic` CRC-16

**(Synthesized) Utilization on Artix-7:**

- Slice LUTs: 32 (as Logic)
- Slice Registers: 16 (as Flip Flop)

### `crc_dynamic` CRC-32

**(Synthesized) Utilization on Artix-7:**

- Slice LUTs: 64 (as Logic)
- Slice Registers: 32 (as Flip Flop)

## Simulation

Both modules are simulated with their default values, which corresponds to CRC-16 CCITT-FALSE, in [testbench_16b.v](Sim/testbench_16b.v). Additionally, configurations for CRC-32 POSIX is simulated in [testbench_32b.v](Sim/testbench_32b.v). All results are verified via [crccalc.com](https://crccalc.com/).

## Test

Both modules are tester on [testboard.v](Test/testboard.v). Data taken via uart and current crc result displayed on seven segment display. Second led is used to indicate modules calculated diffrent crc values. During test CRC-16 CCITT-FALSE configuration is used. All results are verified via [crccalc.com](https://crccalc.com/).

## Status Information

**Last Simulation:** 17 September 2021, with [Icarus Verilog](http://iverilog.icarus.com).

**Last Test:** 17 September 2021, on [Digilent Basys 3](https://reference.digilentinc.com/reference/programmable-logic/basys-3/reference-manual).
