# GitHub Copilot — Project Skill Router

You are an AI coding agent working on `kolmipilot-Police-Mod`.

You MUST follow the shared project specifications and development guidelines before implementing changes.

Your goal is to maintain consistency with the existing architecture and ensure that all generated code follows the project's established conventions.

# Shared Agent Instructions

Before performing any work in this repository, read the root `AGENTS.md`.

It defines the shared project rules, documentation structure, development workflow and validation requirements.

Use this file as the central source of instructions. This router only defines how to locate and load the relevant project-specific skills.

Do not duplicate or override the shared rules defined in `AGENTS.md`.

## 1. Shared Documentation

The project uses shared documentation as its source of truth:

- `SPECIFICATION.md` — overall project specification, requirements and architecture.
- `TODO.md` — current tasks, progress and planned features.

Consult the relevant sections before implementing or modifying functionality.

Do not invent requirements or contradict documented project decisions.

## 2. Dynamic Skill Loading

Development skills are located in:

`docs/skills/`

Load the appropriate skill files according to the task.

| Task scope | Required documentation |
|---|---|
| General Arma 3 development, SQF, addon configs, UI | `docs/skills/arma3/skill.md` |
| ACE3 interactions, actions, medical and other ACE APIs | `docs/skills/ace/skill.md` |
| CBA macros, XEH, events, settings, keybindings and PFH | `docs/skills/cba/skill.md` |
| HEMTT commands, validation, checks and build errors | `docs/skills/hemtt/skill.md` |

### Context routing rules

- **Any Arma 3 addon development:** Read `arma3/skill.md`.
- **Config.cpp, CfgPatches, CfgVehicles or other engine configuration:** Read `arma3/skill.md`.
- **SQF functions and engine commands:** Read `arma3/skill.md` and verify unfamiliar APIs using a3ref MCP.
- **Custom UI and dialogs:** Read `arma3/skill.md`.
- **ACE3 functionality:** Read `ace/skill.md` and `arma3/skill.md`.
- **CBA functionality or macros:** Read `cba/skill.md` and `arma3/skill.md`.
- **HEMTT checks or build errors:** Read `hemtt/skill.md` and any relevant implementation skill.

If a task involves multiple systems, read all relevant skill files.

## 3. Documentation Sources

Use `a3ref` MCP as the primary reference for Arma 3 engine documentation.

Use official ACE3 and CBA documentation and repositories for their respective APIs.

Do not invent:
- SQF commands.
- Engine functions.
- Configuration properties.
- Macro definitions.
- Function parameters.
- Return values.
- Event handler behaviour.

If the documentation cannot verify a detail, explicitly state the uncertainty.

## 4. Project Conventions

- Custom project identifiers use `kolmip_`.
- ACE3 identifiers retain `ace_`.
- CBA identifiers retain `CBA_`.
- Existing project macros must be preserved.
- Existing addon architecture must be respected.
- Existing functionality must not be removed or changed without justification.

Inspect actual project files before assuming how a macro, function or addon is configured.

Do not synthesize generic vanilla implementations when the project already provides an appropriate helper or framework API.

## 5. Code Quality and Scope

- Prefer minimal and targeted changes.
- Reuse existing functionality.
- Avoid unnecessary dependencies.
- Do not duplicate ACE3 or CBA functionality.
- Keep configuration and SQF code organized.
- Avoid unrelated refactoring.
- Preserve documented project requirements.

## 6. Validation Requirements

Before reporting a task as complete:

1. Inspect the final changes.
2. Verify compliance with the relevant skill files.
3. Check references, includes and dependencies.
4. Run `hemtt check` when appropriate.
5. Fix relevant errors and repeat validation.
6. Report what was changed and what was actually tested.

Never report successful validation without executing it.

## 7. Final Priority

Follow this order when determining implementation behaviour:

1. Explicit user instructions.
2. `SPECIFICATION.md`.
3. Existing project architecture and conventions.
4. Relevant specialized skill files.
5. General Arma 3 documentation and official framework references.
6. Generic coding conventions.

The goal is consistent development across all AI agents, not independent interpretations of the project.
