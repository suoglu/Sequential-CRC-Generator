# Sequential CRC Generators

## Contents of Readme

1. About
2. Modules
3. Interface Description
4. Simulation
5. Test
6. Status Information
7. Issues

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

## Simulation

Both modules are simulated with their default values, which corresponds to CRC-16 CCITT-FALSE.

## Test

INFO ABOUT TEST CODE

## Status Information

**Last Simulation:** 16 September 2021, with [Icarus Verilog](http://iverilog.icarus.com).

**Last Test:** -
