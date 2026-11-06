# AGENTS.md
# kolmipilot-Police-Mod — Agent Instructions

This document defines the shared rules and development workflow for all AI agents working on `kolmipilot-Police-Mod`.

It is the central entry point for project documentation and development guidelines.

All agents, regardless of the AI platform or editor being used, must follow these instructions.

---

## 1. Project Documentation

The following documents are the shared source of truth for the project.

### Main documentation

| File | Purpose |
|---|---|
| `SPECIFICATION.md` | Main project specification, requirements, architecture and expected functionality. |
| `TODO.md` | Current tasks, implementation progress, known issues and planned work. |
| `AGENTS.md` | Shared instructions and rules for all AI agents. |

### Development skills

All specialized development guidelines are maintained in `docs/skills/`.

| Skill | Purpose |
|---|---|
| `docs/skills/arma3/skill.md` | General Arma 3 mod development, SQF, configuration, UI and engine integration. |
| `docs/skills/ace/skill.md` | ACE3 APIs, interactions, actions and integrations. |
| `docs/skills/cba/skill.md` | CBA framework, macros, XEH, events, settings and keybindings. |
| `docs/skills/hemtt/skill.md` | HEMTT validation, checks and troubleshooting. |

Do not duplicate the detailed contents of these skills in this file.

---
## Task Execution Workflow

When asked to implement tasks from `TODO.md`:

1. Read the root `AGENTS.md` before starting.
2. Read `SPECIFICATION.md` to understand the project's goals, architecture and requirements.
3. Read `TODO.md` and identify the requested tasks and their dependencies.
4. Load all relevant project-specific skills from `docs/skills/`.
5. Use available MCP servers and tools when relevant, especially a3ref for Arma 3 documentation and Obsidian MCP for vault operations.
6. Inspect the existing implementation before making changes.
7. Implement the requested tasks while following project conventions and architecture.
8. Run appropriate validation, including `hemtt check` when applicable.
9. Update `TODO.md` to reflect completed work, remaining tasks and newly discovered issues.
10. Report implemented changes, validation results and any unresolved problems.

Do not assume that a task is complete simply because code was written. Verify the implementation and report any limitations.

If a task is ambiguous or missing essential requirements, investigate the existing specification and code first. Ask for clarification only when the missing information cannot be reasonably determined.

## 2. Mandatory Workflow

Before implementing changes, follow this workflow.

### Step 1 — Understand the request

Determine:
- What the user wants to achieve.
- Which addons and systems are involved.
- Whether the task modifies existing functionality or introduces something new.
- Which project requirements apply.

Do not assume that the requested implementation is the only possible solution.

### Step 2 — Read project documentation

Read the relevant sections of:
- `SPECIFICATION.md`
- `TODO.md`

Use the specification to understand intended behaviour and architecture.

Use TODO to understand existing progress and unfinished work.

If a document does not exist yet, do not invent its contents. Continue using the available documentation.

### Step 3 — Load relevant skills

Read all applicable files from `docs/skills/`.

Every Arma 3 mod development task requires:

`docs/skills/arma3/skill.md`

Additionally:

- ACE3 functionality requires `docs/skills/ace/skill.md`.
- CBA functionality requires `docs/skills/cba/skill.md`.
- HEMTT operations require `docs/skills/hemtt/skill.md`.

A task involving multiple systems requires all relevant skills.

### Step 4 — Inspect existing implementation

Before editing:
- Inspect relevant source files.
- Check existing macros and function registration.
- Understand addon dependencies.
- Identify existing implementations that can be reused.
- Follow established project structure.

Never assume that the repository uses default framework conventions without checking.

### Step 5 — Implement

Make the smallest correct changes that satisfy the request.

Preserve existing architecture and functionality.

Avoid unnecessary refactoring, abstractions, dependencies and unrelated modifications.

### Step 6 — Validate

After implementation:
- Review modified files.
- Check references and includes.
- Verify API usage.
- Run relevant validation tools.
- Use `hemtt check` when appropriate.
- Fix relevant errors and repeat validation.

### Step 7 — Report

Provide a concise summary:
- What was changed.
- Which files were modified.
- What validation was performed.
- Whether any issues remain.

Never claim that something was tested or validated if it was not.

---

## 3. Project Identity and Naming

The project uses the following naming conventions:

| Namespace | Usage |
|---|---|
| `kolmip_` | Custom project identifiers. |
| `ace_` | ACE3 identifiers and public APIs. |
| `CBA_` | CBA identifiers and public APIs. |

Do not rename external framework identifiers.

Use existing project macros and conventions instead of introducing alternative implementations.

When unsure, inspect:
- `addons/main/script_macros.hpp`
- `addons/main/script_mod.hpp`
- `addons/common/script_component.hpp`

Do not duplicate CBA or ACE3 macros.

---

## 4. Documentation and API Verification

### Arma 3

Use the `a3ref` MCP server as the primary reference for Arma 3 engine documentation.

Verify unfamiliar:
- SQF commands and functions.
- Configuration classes and properties.
- Event handlers.
- UI controls and commands.
- Locality requirements.
- Multiplayer behaviour.

Do not invent engine APIs or assume that a command behaves as expected.

### External frameworks

Use official documentation and source repositories:

- ACE3: https://ace3.acemod.org/wiki/
- ACE3 source: https://github.com/acemod/ACE3/
- CBA documentation: https://cbateam.github.io/CBA_A3/docs/
- CBA source: https://github.com/cbateam/cba_a3

When working with framework APIs, consult the relevant specialized skill.

If documentation is unavailable or does not confirm an implementation detail, state the uncertainty.

---

## 5. General Development Principles

### Correctness

Correctness takes priority over implementation speed.

Do not produce code based on assumptions when the relevant API can be verified.

### Consistency

Follow existing project architecture, naming conventions and formatting.

Prefer existing project systems over new implementations.

### Maintainability

Keep code understandable and organized.

Avoid:
- Unnecessary global variables.
- Duplicate functionality.
- Unnecessary dependencies.
- Large unrelated refactors.
- Workarounds that hide actual errors.

### Scope control

Only modify files relevant to the requested task.

Do not silently change existing functionality or documented requirements.

If a requested change requires modifying established architecture, explain why.

### Assets

PAA textures and images are prepared manually by the user.

Do not automatically generate, edit or convert PAA assets unless explicitly requested.

Do not invent paths to assets that do not exist.

---

## 6. HEMTT and Validation

HEMTT is the primary project validation and build tool.

For ordinary code validation, prefer:

```powershell
hemtt check
```

When validation reports errors:
1. Read the complete output.
2. Identify the source of each issue.
3. Inspect the affected files.
4. Fix the underlying problem.
5. Run the check again.

Do not disable lints or modify validation configuration simply to hide errors.

For detailed HEMTT instructions, read:

`docs/skills/hemtt/skill.md`

---

## 7. Working with Project Specifications and TODO

### SPECIFICATION.md

Treat this file as the primary description of what the mod should become.

It should contain:
- Project goals.
- Feature requirements.
- Expected behaviour.
- Architecture decisions.
- Important technical constraints.
- Design decisions that should remain consistent.

Do not automatically rewrite the specification when implementing a feature.

Only modify it when the user requests a specification change or explicitly approves documenting a new decision.

### TODO.md

Use this file to track development progress.

When appropriate:
- Mark completed tasks.
- Update task status.
- Add newly discovered issues.
- Record unfinished work.
- Avoid duplicating existing tasks.

Do not mark work as completed until it has actually been implemented.

Keep TODO focused on actionable tasks rather than long technical explanations.

---

## 8. Agent Independence and Shared Standards

Different AI agents may use different tools, workflows and interfaces.

However, they must all follow the same:
- Project specification.
- Naming conventions.
- Architecture.
- Development skills.
- Validation requirements.

Do not create agent-specific implementations of shared project functionality.

Do not assume that another agent has already read the required documentation.

Load the relevant instructions into the current context before starting work.

---

## 9. Priority of Instructions

When instructions conflict, use the following priority:

1. Explicit user instructions for the current task.
2. `SPECIFICATION.md` and explicitly approved project decisions.
3. Existing project architecture and established conventions.
4. Relevant specialized skills in `docs/skills/`.
5. This general agent instruction document.
6. Official engine and framework documentation.
7. Generic development conventions.

If two project documents contradict each other, do not silently choose one. Identify the conflict and ask for clarification when it materially affects implementation.

---

## 10. Final Rule

All agents contribute to the same project.

The objective is not merely to generate working code, but to maintain a consistent, reliable and maintainable Arma 3 modification.

Follow the shared documentation, verify unfamiliar APIs, preserve existing architecture and validate changes before reporting completion.

## 2. Documentation Tools and Workflow

This repository uses **Obsidian** and **Graphify** for project documentation, knowledge management and code relationship visualization.

### Obsidian

- Treat the repository as an Obsidian-compatible vault.
- Use standard Markdown files (`.md`) for documentation.
- Use Obsidian-compatible internal links (`[[Page Name]]`) when linking between documentation pages.
- Use YAML frontmatter when appropriate.
- Preserve existing Obsidian metadata, tags, aliases and links.
- Do not break existing wikilinks when renaming or moving files.
- Prefer relative links for resources outside Obsidian-specific linking.
- Keep documentation compatible with both Obsidian and standard Markdown viewers whenever practical.
- Use the **Obsidian MCP Server** when available to interact with the vault and its contents.

### Graphify

- Use Graphify to explore and understand relationships between project files, components and systems.
- Treat the Graphify-generated graph as a representation of the current repository structure and dependencies.
- Graphify's watchdog monitors repository changes and automatically keeps the graph up to date.
- Do not introduce redundant graph generation or update mechanisms.
- Do not manually modify generated graph data unless explicitly required.
- Use the graph to support code exploration and architectural understanding, but always verify important details against the actual source files.

### General Documentation Rules

- Keep documentation consistent with the actual project implementation.
- Keep documentation close to the relevant project files or within the established documentation structure.
- Preserve existing documentation structure and naming conventions.
- Do not introduce unnecessary documentation formats or duplicate information.
- Update relevant documentation whenever architectural or functional changes make it outdated.
- Prefer concise, structured documentation over unnecessary descriptions.
