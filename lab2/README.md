# Control Unit

**Name**: Prashant Neupane  
**Roll No**: 079BEI025  
**Name**: Suyog Bhandari 
**Roll No**: 079BCT091  

## Overview
Implementation of control unit for 8bit processor .This control unit implements a 5‑state finite‑state machine (FSM) and supports the following instruction types:

- **SWAP** – Exchange contents of two registers.
- **ARITH** – Arithmetic/logical operations (using the ALU).
- **MEMORY_OPERATION** – Load from memory to a register (MEM2REG) or store from a register to memory (REG2MEM).
- **JUMP** – Unconditional or conditional jump to a new address.

All instructions are 8‑bits wide, and some require additional address bytes (for memory and jump instructions).

---

## Instruction

| Opcode (binary) | Mnemonic | Description                                                                                     |
| --------------- | -------- | ----------------------------------------------------------------------------------------------- |
| `00xxxxxx`      | SWAP     | Exchange contents of two registers specified by `ir[5:3]` (source) and `ir[2:0]` (destination). |
| `0100xxxx`      | REG2MEM  | Store the value in register R0 to the 16‑bit memory address fetched in the next two bytes.      |
| `0101xxxx`      | MEM2REG  | Load data from the 16‑bit memory address (fetched in the next two bytes) into register R0.      |
| `01100xxx`      | JMP      | Unconditional jump to the 16‑bit address fetched in the next two bytes.                         |
| `011001xx`      | JC       | Jump if the carry flag is set.                                                                  |
| `011010xx`      | JNC      | Jump if the carry flag is not set.                                                              |
| `011011xx`      | JZ       | Jump if the zero flag is set.                                                                   |
| `011100xx`      | JNZ      | Jump if the zero flag is not set.                                                               |
| `10000xxx`      | NOP      | No operation; ALU result and flags remain unchanged.                                            |
| `10001xxx`      | ADD      | Add R0 and the selected register; store result in R0.                                           |
| `10010xxx`      | SUB      | Subtract the selected register from R0; store result in R0.                                     |
| `10011xxx`      | INC      | Increment R0; store result in R0.                                                               |
| `10100xxx`      | DEC      | Decrement R0; store result in R0.                                                               |
| `10101xxx`      | COMP     | Bitwise complement (NOT) of R0; store result in R0.                                             |
| `10110xxx`      | LSHIFT   | Left shift R0 by the amount given in the lower 3 bits of the selected register; store result.   |
| `10111xxx`      | RSHIFT   | Right shift R0 by the amount given in the lower 3 bits of the selected register; store result.  |
| `11000xxx`      | GETFLAG  | Load the current flag register into the selected register.                                      |
| `11001xxx`      | SETFLAG  | Set the flag register from the lower 3 bits of the selected register.                           |
| `11010xxx`      | AND      | Bitwise AND of R0 and the selected register; store result in R0.                                |
| `11011xxx`      | OR       | Bitwise OR of R0 and the selected register; store result in R0.                                 |
| `11100xxx`      | XOR      | Bitwise XOR of R0 and the selected register; store result in R0.                                |

**Notes**:
- For `MEM2REG`, `REG2MEM`, and all jump instructions, the 16‑bit address is fetched as two bytes immediately following the instruction (lower byte, then higher byte).
- For ALU operations, the selected register is specified by `ir[2:0]`; the source operand is always R0 (except for shift operations where the shift amount comes from the selected register).

---

## Instruction Types

### 1. SWAP

- **Operation**: Exchanges the contents of two registers.  
- **Fields**:  
  - `ir[5:3]` – source register (A)  
  - `ir[2:0]` – destination register (B)  

---

### 2. ARITH (Arithmetic / Logical)

- **Operation**: Performs an ALU operation on the contents of R0 and the selected register, stores the result in the selected register.  
- **Fields**:  
  - `ir[6:3]` – ALU opcode (e.g., ADD, SUB, AND, OR, etc.)  
  - `ir[2:0]` – destination register
- **Execution**:  
  - The control unit sets `reg_sel[0] = 3'b000` (R0) and `reg_sel[1] = ir[2:0]` (destination).  
  - It asserts `reg_cs`, `reg_alu_db_bar = 1` (ALU result to register), and `reg_rd_wr_bar = 1` (write enable).  
  - The ALU receives the two register values and produces a result.  
  - The result is written into the destination register in the STORE state.  
---

### 3. MEMORY_OPERATION

This type includes both **load** (memory → register) and **store** (register → memory). It uses a 16‑bit address that is fetched in two additional bytes following the instruction.

#### Encoding

- `ir[7:5] = 010` for memory operation  
- `ir[4]` – `1` for **MEM2REG** (load), `0` for **REG2MEM** (store)  

The address is stored in the two bytes immediately after the instruction:  
- First byte → low byte (bits 7:0 of address)  
- Second byte → high byte (bits 15:8 of address)  

---

### 4. JUMP

The jump instruction transfers control to a new Program Counter (PC) address. It can be unconditional or conditional based on the `flag_register` (which stores the ALU flags from the last ALU operation).

#### Encoding

- `ir[7:5] = 011` for jump  
- `ir[4:2]` – condition code (as listed above)  
- The target address is stored in the two bytes following the instruction (same as memory operation).  

---

## State Machine

The control unit is a Moore‑type FSM with following five states:

| State        | Description                                                                                     |
| ------------ | ----------------------------------------------------------------------------------------------- |
| `FETCH`      | Read the instruction from memory at address `pc` into `ir`; increment `pc`.                     |
| `DECODE`     | Decode `ir`; set `instruction_type`, `store_type`, and prepare for next state.                  |
| `FETCH_ADDR` | Fetch two address bytes (for memory and jump instructions). Assembled into `mem_address`.       |
| `EXECUTE`    | Perform the core operation (e.g., set control signals for ALU, swap, or prepare memory access). |
| `STORE`      | Write result to register or memory (used by ALU and memory operations).                         |

---

## Control Signals

The control unit generates the following output signals:

| Signal           | Description                                                               |
| ---------------- | ------------------------------------------------------------------------- |
| `addr_bus`       | Address bus driven to memory or used internally.                          |
| `data_bus`       | Bidirectional data bus (connected to memory and register bank).           |
| `mem_cs`         | Memory chip select.                                                       |
| `mem_rd_wr_bar`  | Memory read (1) / write (0) control.                                      |
| `reg_sel[1:0]`   | Two 3‑bit register selects (source and destination).                      |
| `reg_alu_db_bar` | Selects data source for register write: `1` = ALU result, `0` = data bus. |
| `reg_rd_wr_bar`  | Register read (1) / write (0).                                            |
| `swp`            | Enables register swap.                                                    |
| `reg_cs`         | Register bank chip select.                                                |
| `alu_sel`        | 4‑bit ALU opcode.                                                         |

---

## Test

| Cycle | State      | Instruction | Operation                                    | Expected Result                          | Actual Result                            |
| ----- | ---------- | ----------- | -------------------------------------------- | ---------------------------------------- | ---------------------------------------- |
| 1     | FETCH      | SWAP        | Fetch opcode `0x01`                          | PC = 0x01, IR = 0x01                     | PC = 0x01, IR = 0x01                     |
| 2     | DECODE     | SWAP        | Decode as SWAP; src=R1 (001), dst=R0 (000)   | instruction_type = SWAP                  | instruction_type = SWAP                  |
| 3     | EXECUTE    | SWAP        | Swap R0 and R1                               | R0 = 0x66, R1 = 0x55                     | R0 = 0x66, R1 = 0x55                     |
| 4     | FETCH      | ADD         | Fetch opcode `0x89`                          | PC = 0x02, IR = 0x89                     | PC = 0x02, IR = 0x89                     |
| 5     | DECODE     | ADD         | Decode as ALU opcode `1001` (ADD); dst=R1    | instruction_type = ARITH, alu_sel = 9    | instruction_type = ARITH, alu_sel = 9    |
| 6     | EXECUTE    | ADD         | ALU adds R0 (0x66) and R1 (0x55)             | result = 0xBB, flags = 0b000             | result = 0xBB, flags = 0b000             |
| 7     | STORE      | ADD         | Write ALU result to R1                       | R0 = 0x66, R1 = 0xBB                     | R0 = 0x66, R1 = 0xBB                     |
| 8     | FETCH      | MEM2REG     | Fetch opcode `0x50`                          | PC = 0x03, IR = 0x50                     | PC = 0x03, IR = 0x50                     |
| 9     | DECODE     | MEM2REG     | Decode as MEM2REG; store_type = MEMORY_2_REG | store_type = MEMORY_2_REG                | store_type = MEMORY_2_REG                |
| 10    | FETCH_ADDR | MEM2REG     | Fetch low address byte `0x34`                | mem_address[7:0] = 0x34, PC = 0x04       | mem_address[7:0] = 0x34, PC = 0x04       |
| 11    | FETCH_ADDR | MEM2REG     | Fetch high address byte `0x12`               | mem_address[15:8] = 0x12, PC = 0x05      | mem_address[15:8] = 0x12, PC = 0x05      |
| 12    | EXECUTE    | MEM2REG     | Prepare memory read at 0x1234                | addr_bus = 0x1234, mem_cs=1, mem_rd_wr=1 | addr_bus = 0x1234, mem_cs=1, mem_rd_wr=1 |
| 13    | STORE      | MEM2REG     | Read data from memory into R0                | R0 = 0xAA (value at 0x1234)              | R0 = 0xAA                                |
| 14    | FETCH      | REG2MEM     | Fetch opcode `0x40`                          | PC = 0x06, IR = 0x40                     | PC = 0x06, IR = 0x40                     |
| 15    | DECODE     | REG2MEM     | Decode as REG2MEM; store_type = REG_2_MEMORY | store_type = REG_2_MEMORY                | store_type = REG_2_MEMORY                |
| 16    | FETCH_ADDR | REG2MEM     | Fetch low address byte `0x78`                | mem_address[7:0] = 0x78, PC = 0x07       | mem_address[7:0] = 0x78, PC = 0x07       |
| 17    | FETCH_ADDR | REG2MEM     | Fetch high address byte `0x56`               | mem_address[15:8] = 0x56, PC = 0x08      | mem_address[15:8] = 0x56, PC = 0x08      |
| 18    | EXECUTE    | REG2MEM     | Prepare memory write at 0x5678               | addr_bus = 0x5678, mem_cs=1, mem_rd_wr=0 | addr_bus = 0x5678, mem_cs=1, mem_rd_wr=0 |
| 19    | STORE      | REG2MEM     | Write R0 (0xAA) to memory                    | Memory[0x5678] = 0xAA                    | Memory[0x5678] = 0xAA                    |
| 20    | FETCH      | JMP         | Fetch opcode `0x60`                          | PC = 0x09, IR = 0x60                     | PC = 0x09, IR = 0x60                     |
| 21    | DECODE     | JMP         | Decode as unconditional jump                 | instruction_type = JUMP                  | instruction_type = JUMP                  |
| 22    | FETCH_ADDR | JMP         | Fetch low address byte `0x00`                | mem_address[7:0] = 0x00, PC = 0x0A       | mem_address[7:0] = 0x00, PC = 0x0A       |
| 23    | FETCH_ADDR | JMP         | Fetch high address byte `0x20`               | mem_address[15:8] = 0x20, PC = 0x0B      | mem_address[15:8] = 0x20, PC = 0x0B      |
| 24    | EXECUTE    | JMP         | Update PC to 0x2000                          | PC = 0x2000                              | PC = 0x2000                              |
| 25    | FETCH      | NOP         | Fetch NOP at 0x2000                          | PC = 0x2001, IR = 0x00                   | PC = 0x2001, IR = 0x00                   |

The screenshot of the control signals in GTKwave is:
![Control Unit Signals](./imgs/cu_waves.png)
