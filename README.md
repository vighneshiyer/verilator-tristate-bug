# Inter-Module Tristate Verilator Bug

- https://github.com/ucb-bar/chipyard/pull/1205 (causing failures in the SPI tests that use a SPI model written in Verilog that has tri-state IOs)
- https://github.com/verilator/verilator/issues/3399 (potentially related Verilator issue)

## Results

### verilator 4.106 -O3 (good)

```
0
0
1
0
```

### verilator 4.224 -O3 (bad)

```
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
```

### verilator 4.224 -O0 (good-ish)

```
0
0
1
0
0
```

### iverilog (good)

```
z
z
1
z
```

Clearly a bug

### Bisecting

- Verilator v4.224 (known bad), v4.106 (known good)
    - Note v4.106 has 5 zeros in -O0 verilator binary (which is surprising, but -O0 is known to break some things anyways, will focus on -O3 results)
- Verilator 4.205 devel rev v4.204-41-gfcb8bc22 (GOOD)
- Verilator 4.215 devel rev v4.214-75-ge8148553 (BAD)
    - all zeros in opt verilator binary
- Verilator 4.213 devel rev v4.212-12-g72f198d7 (BAD)
    - same as above
- Verilator 4.211 devel rev v4.210-32-gd9c893af (GOOD)
    - opt verilator binary is correct, -O0 is still wrong, but leave it
    - Going to mark this as good to see when the optimized version breaks
- Verilator 4.211 devel rev v4.210-64-gbc3e24c8 (GOOD)
- Verilator 4.211 devel rev v4.210-80-gf64d9d87 (BAD)
- Verilator 4.211 devel rev v4.210-72-gfffc6397 (GOOD)
- Verilator 4.211 devel rev v4.210-76-gc3d64d97 (BAD)
- Verilator 4.211 devel rev v4.210-74-g34a0bb44 (BAD)
- Verilator 4.211 devel rev v4.210-73-g8681861b (BAD)

```
8681861be9aa167cecbb267b10881dc8d87e1b83 is the first bad commit
commit 8681861be9aa167cecbb267b10881dc8d87e1b83
Author: Geza Lore <gezalore@gmail.com>
Date:   Wed Aug 18 19:15:02 2021 +0100

    Improve bitop tree optimization

    - Remove redundant casting
    - Cheaper final XOR parity flip (~/^1 instead of != 0)
    - Support XOR reduction of ~XOR nodes
    - Don't add redundant masking of terms
    - Support unmasked terms
    - Add cheaper implementation for single bit only terms
    - Ensure result is clean under all circumstances (this fixes current bugs)

 src/V3Const.cpp                   | 660 +++++++++++++++++++++++++-------------
 src/V3Number.cpp                  |  15 +
 src/V3Number.h                    |   8 +-
 test_regress/t/t_const_opt_cov.pl |   2 +-
 test_regress/t/t_const_opt_red.pl |   2 +-
 test_regress/t/t_gate_ormux.pl    |   2 +-
 6 files changed, 460 insertions(+), 229 deletions(-)
```
