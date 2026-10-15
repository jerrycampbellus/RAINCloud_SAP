# Engineering decisions

RAINCloud Digital | RAINCloud_SAP | J. Campbell

## 2026-10-15 — Author and RAINCloud Digital attribution

- User-confirmed name: Jerry Campbell; preferred documentation credit:
  J. Campbell. Corrects the earlier mistaken use of John Campbell.
- User confirmed that RAINCloud Digital notices mean project attribution in the
  documentation and source headers.
- Added RAINCloud Digital / J. Campbell attribution to active project files. Existing
  vendor notices and the original reference snapshot remain intact. These
  attribution notices introduce no new license terms or functional changes.

## 2026-10-15 — Standalone local project

- Authorization: user approved proceeding with the review fixes and requested
  RAINCloud_SAP under `D:\RAINCloud\GitHub\FPGA\DE10_Lite`.
- Decision: copy only the 20 active design sources and associated RAM/settings
  baseline; preserve originals with hashes; explicitly list all active files.
- Reason: avoid dependence on OneDrive, implicit Quartus searches, and stale
  restored copies. Original project remains unchanged.
- Status: active. Local Git only; no remote publishing or device programming.

## 2026-10-15 — Preserve the educational structural datapath

- Decision: retain the existing register/ALU/74LS-style decomposition rather
  than replace the CPU with a different architecture.
- Changes: registered CPU clock, combinational microcode decode, explicit
  five-state counter, arithmetic flag write enable and reset.
- Alternative: single 50 MHz clock with clock enables throughout every primitive.
  This would require broader datapath changes; retain it as a later option.
- Evidence: original topology and review findings; regression benches exercise
  the revised boundary behavior. Runtime verification remains pending.
- Consequence: the board clock and divided CPU clock both require timing
  analysis; internal tri-state logic still synthesizes to FPGA logic.
- Status: active, implementation provisional pending validation.

## 2026-10-15 — Flags and branch semantics

- Decision: bit 0 = zero; bit 1 = carry on ADD, borrow on SUB; latch both on
  microstep T4 with A writeback and preserve until arithmetic or reset.
- JZ opcode 7 and JC opcode 8 branch on SET. The old BNZ/BNC comments were
  inconsistent with the implemented tests, so the new documentation uses JZ/JC.
- Branch instructions preserve flags; the old one-cycle clear/shadow behavior
  is removed. RAM survives reset, as in the original.
- Status: active; covered by pending arithmetic and CPU regression tests.

## 2026-10-15 — Clock, reset and board inputs

- Decision: CLK is a flip-flop output, NOT_CLK is its exact inverse. Mode
  handover occurs only at a low clock boundary. Synchronize switch/key inputs,
  debounce KEY1, assert reset asynchronously and release on the board clock.
- Preserve actual fast-mode behavior: selector 111 = 25 MHz, not the old
  comment's 128 Hz. Other positions are nominal 1–64 Hz.
- Timing baseline: 20 ns board clock, generated CPU clock divide-by-two as
  the fastest possible operating envelope. No internal clock paths are waived.
- External exceptions: asynchronous inputs only to first synchronizer stages;
  human display output pins have no clocked receiver setup/hold requirement.
- Evidence: Altera create_generated_clock syntax and clocking guidance:
  https://docs.altera.com/r/docs/683432/25.3/quartus-prime-pro-edition-user-guide-scripting/create_generated_clock-quartus-sdc
- Status: active; constraint object resolution and timing closure are unverified
  because the installed IP-catalog helper is blocked by Windows application control.

## 2026-10-15 — Output capture and display

- Decision: store the raw OUT byte on the capture edge; format it combinationally.
  Signed mode derives the sign from bit 7; mode changes work while halted.
- Reason: remove the inferred formatting latch, avoid an extra capture latency,
  and make reset initialize output even when the CPU clock is stopped.
- Validation: 256 values x signed/unsigned x decimal/hex cases in tb_output.
- Status: active; testbench compiled, runtime pending.

## 2026-10-15 — Updated tools and synthesizable clock-mode reset

- Context: the user installed Quartus 25.1std.0 and Questa 2025.2. The new
  Quartus installation completes compilation with Smart App Control still on.
  This supersedes the earlier environment-blocked timing status.
- Finding: the first full build inferred a latch for `manual_mode` because its
  asynchronous reset loaded `CLK_SELECT`. TimeQuest treated reset as an
  additional unconstrained clock.
- Decision: asynchronously reset `manual_mode` to zero; the existing low-phase
  handover samples `CLK_SELECT` on the first board clock after reset. A held
  step button remains disarmed until release and a new press.
- Evidence: rebuilt with zero TimeQuest errors/warnings and zero unconstrained
  clocks or I/O paths. Added the held-key reset case to `tb_clock`; all benches
  compile, but functional simulation remains blocked by license checkout.
- Consequences: retain the original board interface and instruction set.
  `SALT_LICENSE_SERVER` must identify a renewed license for Questa simulation;
  no system-wide license or security settings were changed.

## 2026-10-15 — Licensed functional regression completed

- Authorization: user supplied a renewed Starter license and requested readiness
  checks after installation. Set `SALT_LICENSE_SERVER` in the Windows user
  environment; the license remains outside the repository and expires 2027-10-15.
- Decision: map the Questa `work` library in a project-local `modelsim.ini` and
  use forward-slash paths with `-ini`. Run the batch commands as a Tcl macro so
  `onerror` is effective. Preserve the explicit per-bench PASS requirement.
- Evidence: all five suites pass in Questa 2025.2, including 131,072 arithmetic
  cases, 1,024 output formats, and 11 CPU programs. This supersedes all earlier
  pending-runtime and license-blocked statuses in this decision log.
- Status: simulation and fitted timing verified; remaining build/elaboration
  warnings are recorded in VALIDATION.md. Board programming/testing is pending.

## 2026-10-15 — Explicit FPGA bus and warning cleanup

- Authorization: user requested remediation of the pasted Quartus warnings.
- Decision: retain the structural SAP decomposition and use FPGA_MODE=1 on
  active 74LS245/RAM instances. Disabled sources drive zero into one explicit
  OR-combined CPU data bus. Idle and disabled sampled-bus display values are zero.
  The primitive default mode still models high impedance for standalone use.
- Fixed omitted structural connections and the unused ALU net; removed unused
  conflicting upper-bit MAR tie-offs. Explicit 8 mA LED/segment output settings
  preserve the previous fitted drive strength on all 58 output pins.
- Evidence: Quartus warnings reduced from 72 to 9, no errors; fitted timing
  passes. Five Questa suites pass with zero warnings, including stronger bus
  ownership, six-source/idle, and exhaustive ALU bus-gating checks.
- Remaining warnings: intentional decimal-point constants, unavailable optional
  LogicLock functionality in Lite, and the automatic MAX 10 input-voltage
  advisory. No warnings were suppressed. See VALIDATION.md for disposition.

## 2026-10-15 — RAINCloud Digital identity and descriptive net names

- User clarified that the attribution is RAINCloud Digital and requested an LLC
  description based on its website. README.md paraphrases the company's mission
  and published services, with links to raincloud.digital. J. Campbell remains
  the original author credit; existing vendor notices remain unchanged.
- Decision: use descriptive lower-case internal signal names, with _n for
  active-low/complement signals. Trace each signal's function, including the
  negative-logic adder carry network and counter JK excitation terms.
- Changed 190 module-scoped identifiers across 10 RTL files and corresponding
  CPU testbench references. Port interfaces, instance names, Boolean logic,
  bit ordering, clocking and reset behavior are unchanged by this naming pass.
- Evidence: inverse substitutions reproduce the original logic tokens exactly;
  full Quartus rebuild and all five Questa regression suites pass afterward.
  Full mapping: reference/NET_RENAMES.json. Naming guidance: NET_NAMES.md.
- Preserved the original 23-file reference snapshot and its hashes, all 13
  imported vendor notice blocks, and the existing programmer-chain assignment.

## 2026-10-15 — Public GitHub source baseline

- Authorization: J. Campbell requested a Git commit and public availability with
  appropriate descriptions and documentation.
- Destination: https://github.com/jerrycampbellus/RAINCloud_SAP on branch main,
  using the authenticated account and existing Git author identity.
- Scope: active RTL, constraints, program image, regression suites, build/check
  scripts, engineering records, and the hashed original source snapshot.
- Documentation: added clone requirements, contribution guidance, and NOTICE.md.
  The source manifest now uses paths relative to the original project root;
  all 23 original file hashes remain unchanged. Historical source contents,
  including their original paths and vendor notices, remain preserved.
- Portability: corrected the reference manifest's RAM directory casing to match
  Git and added exact-case path checks for active RTL and original references.
- Licensing: preserve existing file-level notices. Public availability does not
  select a new repository-wide license; none has been added.
- Exclusions: build databases/logs, programming images, local programmer chains,
  simulator license files, credentials, and installation/runtime files.
- This publication authorization supersedes the earlier local-only repository
  status. Simulation and fitted timing pass; board qualification remains pending.
