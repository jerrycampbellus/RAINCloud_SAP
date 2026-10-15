# Changelog

RAINCloud Digital | RAINCloud_SAP | J. Campbell

## 0.1.0 development — 2026-10-15

- Prepared the public source baseline with clone/build instructions, contribution
  guidance, preserved attribution notices, and portable provenance metadata.
- Corrected RAM snapshot path casing in the manifest and added exact-case path
  checks so Windows validation also catches paths that would fail on Linux.

- Corrected author credit to J. Campbell (Jerry Campbell) and added RAINCloud Digital
  attribution to active source/configuration headers and project documentation.
  Existing vendor notices and the original reference snapshot are preserved.
- Created the standalone RAINCloud_SAP Quartus project and preserved a hashed
  source baseline from BenEater_8Bit_Computer.
- Replaced absolute paths and implicit module discovery with explicit relative inputs.
- Corrected manual clock inversion, registered clock selection, and synchronized/
  debounced board inputs.
- Added reset behavior independent of halted CPU clock activity.
- Made microcode decode combinational and microstep rollover explicit.
- Captured arithmetic flags with writeback and retained them across instructions.
- Removed unintended MAR reloads during operand read/store cycles.
- Corrected output register capture/reset and signed formatting; removed
  nonblocking assignments from the combinational display decoder.
- Added timing constraints, standalone build scripts, structural checks and
  five SystemVerilog regression benches.
- Updated build scripts for Quartus 25.1 and Questa 2025.2; added a Questa
  regression backend and an optional per-run license file argument.
- Replaced the clock-mode register's variable asynchronous reset value with
  a fixed reset and synchronous mode adoption, removing an inferred latch and
  its unconstrained clock. Added a held-key-after-reset regression case.
- Corrected Questa's Windows library mapping and Tcl batch execution in the
  regression runner. Configured the renewed Starter license for the local user.
- Replaced internal tri-state inference with explicit FPGA-mode gated bus
  sources, fixed unused connections, and specified the existing 8 mA output drive.
  Idle bus and disabled sampled-bus display values are now defined as zero.
- Renamed 190 internal nets/register aliases across 10 RTL files by function,
  updated CPU testbench references, and recorded the mapping in NET_NAMES.md
  and reference/NET_RENAMES.json. The naming pass preserves logic and ports.
- Updated attribution to RAINCloud Digital and added a company description
  based on its published mission and services at raincloud.digital.
- Validation: full Quartus build and fitted timing pass with 9 expected warnings,
  down from 72. All five functional suites pass with zero warnings, down from
  24 CPU elaboration warnings. Hardware tests remain pending. See VALIDATION.md.
- Fabrication impact: none; existing DE10-Lite board only.
