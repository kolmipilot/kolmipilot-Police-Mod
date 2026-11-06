# Agy Agent Skill Router

You are an AI agent working on `kolmipilot-Police-Mod`.

Your responsibility is to maintain the integrity, consistency and functionality of the project while following its shared specifications and development guidelines.

# Shared Agent Instructions

Before performing any work in this repository, read the root `AGENTS.md`.

It defines the shared project rules, documentation structure, development workflow and validation requirements.

Use this file as the central source of instructions. This router only defines how to locate and load the relevant project-specific skills.

Do not duplicate or override the shared rules defined in `AGENTS.md`.

## 1. Shared Project Documentation

The following files are the shared source of truth for all agents:

- `SPECIFICATION.md` — project requirements, architecture, functionality and design decisions.
- `TODO.md` — current tasks, progress and planned work.

Before implementing a feature, consult the relevant sections of `SPECIFICATION.md`.

When continuing existing work, check `TODO.md` for relevant tasks and progress.

Do not contradict the project specification or silently change established design decisions.

## 2. Skill System

All development guidelines are maintained in:

`docs/skills/`

Before implementing a task, identify the relevant development areas and read their corresponding skill files.

### Skill routing

| Task area | Required skill |
|---|---|
| General Arma 3 mod development, SQF, configs, UI | `docs/skills/arma3/skill.md` |
| ACE3 interactions, actions, medical systems and APIs | `docs/skills/ace/skill.md` |
| CBA macros, XEH, events, settings, keybindings and PFH | `docs/skills/cba/skill.md` |
| HEMTT checks, validation and build troubleshooting | `docs/skills/hemtt/skill.md` |

For tasks involving multiple areas, read all relevant skills.

For example, implementing an ACE interaction may require the Arma 3, ACE3 and CBA skills.

## 3. Documentation and API Verification

Use the `a3ref` MCP server as the primary reference for Arma 3 engine documentation.

Verify unfamiliar:
- SQF commands.
- Engine functions.
- Event handlers.
- Configuration properties.
- UI commands and control properties.
- Locality and multiplayer behaviour.

Use official ACE3 and CBA documentation and source code when working with their APIs.

Never invent commands, functions, parameters or API behaviour.

If a required reference or tool is unavailable, state this clearly.

## 4. Project Integrity

- Follow existing project architecture and naming conventions.
- Preserve existing functionality unless explicitly instructed otherwise.
- Reuse existing functions, macros and systems.
- Avoid unnecessary abstractions and dependencies.
- Do not duplicate functionality already provided by ACE3 or CBA.
- Do not introduce unrelated changes.
- Do not modify project specifications without a reason.

Project-specific identifiers use the `kolmip_` prefix. External framework identifiers retain their original namespaces.

## 5. Validation

Before reporting a task as complete:

1. Review all modified files.
2. Verify that the implementation follows the relevant skill files.
3. Check that includes, references and dependencies are correct.
4. Run `hemtt check` when appropriate.
5. Resolve relevant errors.
6. Report what was changed and what was actually tested.

Never claim that code was tested or validated if the corresponding operation was not performed.

## 6. General Rule

The shared project documentation and specialized skills take precedence over generic development assumptions.

When uncertain, inspect the existing implementation and consult the appropriate documentation before making changes.
