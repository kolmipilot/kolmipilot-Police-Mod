# Cline Skill System Router

You are an AI coding agent working on `kolmipilot-Police-Mod`.

Before generating code or modifying project files, you MUST inspect the shared project documentation and load the relevant development skills.

Use the available filesystem tools to read the actual files from the repository. Do not rely on outdated instructions or previously assumed project structures.

# Shared Agent Instructions

Before performing any work in this repository, read the root `AGENTS.md`.

It defines the shared project rules, documentation structure, development workflow and validation requirements.

Use this file as the central source of instructions. This router only defines how to locate and load the relevant project-specific skills.

Do not duplicate or override the shared rules defined in `AGENTS.md`.

## 1. Mandatory Project Documentation

The following documents define the shared project context:

- `SPECIFICATION.md` — project requirements, architecture and expected functionality.
- `TODO.md` — current tasks and implementation progress.

Read the relevant sections before implementing features or changing established behaviour.

## 2. Mandatory Skill Routing

All development skills are stored in:

`docs/skills/`

Always read the relevant skill completely before implementing work in that area.

| Task | Required skill |
|---|---|
| General Arma 3 modding, SQF, configs, UI, engine integration | `docs/skills/arma3/skill.md` |
| ACE3 functionality and APIs | `docs/skills/ace/skill.md` |
| CBA functionality, macros, XEH and events | `docs/skills/cba/skill.md` |
| HEMTT validation, checks and build troubleshooting | `docs/skills/hemtt/skill.md` |

### Multiple skill requirements

If a task spans multiple areas, read every applicable skill.

Examples:

- Creating an addon with SQF functions: Arma 3 + CBA.
- Implementing an ACE interaction: Arma 3 + ACE3 + CBA.
- Creating a custom UI: Arma 3, plus ACE3 or CBA if their APIs are involved.
- Fixing an HEMTT error in an addon: HEMTT + the relevant Arma 3, ACE3 or CBA skill.

Do not assume that reading one skill automatically covers another.

## 3. API and Documentation Verification

Use the `a3ref` MCP server as the primary reference for Arma 3 engine documentation.

Consult it before using unfamiliar:
- SQF commands and functions.
- Config properties and classes.
- Event handlers.
- UI controls and commands.
- Locality-sensitive commands.
- Multiplayer and remote execution functionality.

For ACE3 and CBA APIs, use their official documentation and source repositories.

Never guess macro definitions, parameter order, return values or engine behaviour.

## 4. Existing Project Conventions

Before creating or modifying code, inspect the existing implementation.

Pay particular attention to:
- Project-specific macros.
- `script_component.hpp`.
- `script_macros.hpp`.
- Function registration.
- Addon dependencies.
- Existing initialization logic.
- Existing UI definitions.

Use `kolmip_` for custom project identifiers.

Preserve original `ace_` and `CBA_` identifiers when using external framework APIs.

Never replace project-specific macros with generic or copied definitions without verifying compatibility.

## 5. Implementation Rules

- Prefer minimal, targeted modifications.
- Reuse existing project systems.
- Do not introduce unnecessary dependencies.
- Do not duplicate ACE3 or CBA functionality.
- Preserve existing behaviour.
- Do not silently change the project specification.
- Do not disable validation rules merely to hide errors.

## 6. Validation

After implementation:

1. Review modified files.
2. Verify all relevant references and includes.
3. Check compatibility with the relevant skills.
4. Run `hemtt check` when appropriate.
5. Fix relevant errors and run the check again.
6. Clearly report validation results.

Never claim that a check or test passed unless it was actually executed.

## 7. Important

The shared documentation in `SPECIFICATION.md`, `TODO.md` and `docs/skills/` is the project's source of truth.

If instructions are unclear or conflict with the existing implementation, inspect the repository and resolve the conflict before proceeding.
