# Arma 3 Mod Development — General Skill

## Purpose

This skill defines general development guidelines for creating and maintaining Arma 3 modifications.

It is specifically intended for addon and mod development, including:
- SQF scripting
- Config.cpp and config inheritance
- Addon architecture
- User interfaces and dialogs
- Game engine integration
- Multiplayer compatibility
- Performance and debugging
- Working with Arma 3 assets and tools

This skill is the general Arma 3 development reference for AI agents working on this project.

It complements the specialized skills:
- `docs/skills/ace/skill.md` — ACE3 integration and APIs.
- `docs/skills/cba/skill.md` — CBA framework and APIs.
- `docs/skills/hemtt/skill.md` — HEMTT build system and tooling.

Do not duplicate their contents. Read the relevant specialized skill whenever a task involves those systems.

---

## 1. Documentation and Reference Sources

### 1.1. a3ref MCP — Primary Reference

The `a3ref` MCP server MUST be treated as the primary reference for Arma 3 scripting documentation.

It provides a searchable reference based on the Bohemia Interactive Community Wiki.

Whenever implementing or modifying Arma 3 functionality, use the available MCP tools to verify relevant information.

Use:

- `search` — find commands, functions, event handlers and documentation topics.
- `get` — retrieve detailed documentation for a specific command, function or topic.
- `lint_sqf` — check SQF code for invalid or unknown commands, missing operands and deprecated syntax, when available.

### 1.2. When to Consult Documentation

Use a3ref whenever:
- Using an unfamiliar SQF command.
- Calling a `BIS_fnc_*` function.
- Implementing event handlers.
- Working with object, group, display or control commands.
- Implementing multiplayer functionality.
- Working with locality or remote execution.
- Using engine configuration properties.
- Implementing UI controls and dialogs.
- Debugging unexpected engine behaviour.

Do not rely exclusively on model knowledge for engine-specific APIs.

Verify:
- Correct command or function name.
- Syntax and parameter order.
- Parameter types.
- Return value.
- Locality requirements.
- Scheduled or unscheduled execution requirements.
- Relevant engine limitations.

Never invent commands, functions, config properties or API behaviour.

If a3ref is unavailable, use the official Bohemia Interactive Community Wiki as a fallback. Clearly distinguish verified information from assumptions.

### 1.3. Documentation Links

- Arma 3 reference: https://wiki.arma3.io/
- a3ref MCP: https://wiki.arma3.io/mcp.html
- Bohemia Interactive Community Wiki: https://community.bistudio.com/wiki/
- Arma 3 modding documentation: https://community.bistudio.com/wiki/Arma_3:_Modding
- Arma 3 addon creation: https://community.bistudio.com/wiki/Arma_3:_Creating_an_Addon

---

## 2. Project Inspection Before Implementation

Before making changes, inspect the existing project structure and implementation.

Do not assume the project follows default Arma 3 or CBA conventions.

Always check:
- Existing addon structure.
- `config.cpp` and included HPP files.
- `script_component.hpp`.
- Project-specific macros.
- Function registration and compilation.
- Existing initialization handlers.
- Dependencies between addons.
- Existing implementations of similar features.

Prefer extending existing systems over introducing new, parallel implementations.

Do not create additional frameworks, helper layers or abstractions unless they solve an actual problem.

### Project-specific conventions

The project uses:
- `kolmip_` for custom identifiers.
- `ace_` for ACE3 identifiers and public APIs.
- `CBA_` for CBA identifiers and public APIs.

Do not rename or replace external framework identifiers.

For project-specific macros and compilation conventions, inspect the actual files in the repository. In particular:
- `addons/main/script_macros.hpp`
- `addons/main/script_mod.hpp`
- `addons/main/script_version.hpp`
- `addons/common/script_component.hpp`

Use the existing project implementation instead of copying macros from unrelated projects.

---

## 3. SQF Development

### 3.1. General Rules

Write modern SQF.

Prefer:
- `params` for function parameters.
- `private` for local variables.
- Explicit return values.
- Clear conditions and control flow.
- Small, reusable functions.
- Meaningful variable names.
- Early exits when appropriate.

Avoid:
- Unnecessary global variables.
- Unnecessary `execVM` calls.
- Excessive nesting.
- Repeated calculations.
- Unnecessary polling loops.
- Uncontrolled scheduled scripts.
- Obsolete SQS syntax.

Use the correct execution method:
- `call` for immediate execution.
- `spawn` for scheduled execution.
- Existing project function registration for reusable addon functions.

Verify execution-context requirements before using commands that depend on the scheduler.

### 3.2. Function Parameters

Use `params` with appropriate defaults and validation.

Example:

```sqf
params [
    ["_object", objNull, [objNull]],
    ["_enabled", true, [true]]
];

if (isNull _object) exitWith {};

_object setVariable ["kolmip_enabled", _enabled, true];
```

Do not blindly trust arguments received from other scripts or network events.

### 3.3. Namespaces and Variables

Understand the difference between:
- `missionNamespace`
- `uiNamespace`
- `parsingNamespace`
- `profileNamespace`

Use the appropriate namespace for the lifetime and purpose of the data.

Avoid storing temporary values globally when local variables are sufficient.

Do not use `profileNamespace` as a substitute for multiplayer synchronization.

### 3.4. Locality and Multiplayer

Locality must be considered whenever modifying game objects or executing commands that may have local execution requirements.

Before implementing multiplayer behaviour, determine:
- Where the code executes.
- Where the affected object is local.
- Whether the operation must execute on the server.
- Whether other clients need to receive the result.
- Whether joining players need the current state.

Do not assume that a command executed on one client automatically affects every client.

Use remote execution only when necessary and verify the correct function, target and execution conditions.

Never expose unrestricted remote execution for arbitrary client-provided code.

---

## 4. Addon Configuration

### 4.1. Config.cpp

Understand the Arma 3 configuration system before changing addon configuration.

Pay attention to:
- Class inheritance.
- `CfgPatches`.
- `CfgFunctions`.
- `CfgVehicles`.
- `CfgWeapons`.
- `CfgAmmo`.
- `CfgSounds`.
- `CfgMusic`.
- `CfgUI` and UI-related configuration classes.
- Event handler configuration.
- Required addon dependencies.

Only modify configuration classes relevant to the task.

Do not duplicate existing class definitions or introduce conflicting class names.

### 4.2. Includes

Split large configuration files into logical HPP files.

Use the existing project structure and include conventions.

Keep configuration declarations organized and avoid circular includes.

Before adding a new include, check whether the relevant file is already included elsewhere.

### 4.3. Dependencies

Declare dependencies correctly.

Do not rely on another addon being loaded unless it is explicitly declared as a dependency or otherwise guaranteed by the project's architecture.

When using ACE3 or CBA functionality, follow their dedicated project skills.

---

## 5. User Interface Development

This project includes custom UI, so UI development is an important part of this skill.

Use the Arma 3 UI system and verify unfamiliar control properties, commands and event handlers through a3ref.

### 5.1. UI Configuration

Keep UI configuration organized.

Use appropriate base classes and inheritance instead of repeating complete control definitions.

Separate large UI definitions into dedicated HPP files where appropriate.

Pay attention to:
- `idd`
- `controls`
- `controlsBackground`
- `onLoad`
- `onUnload`
- Control classes.
- Display classes.
- Event handlers.
- Control IDs.
- UI namespaces.

Avoid unnecessary duplication of base controls.

### 5.2. UI Scaling and Positioning

Use the project's existing UI layout conventions.

Before introducing new coordinate systems, inspect existing UI implementations.

Ensure that interfaces remain usable across different screen resolutions and aspect ratios.

Avoid hardcoding positions without considering safe zones and scaling.

### 5.3. UI Scripts

Keep UI logic separate from configuration declarations whenever practical.

Use dedicated functions for complex UI behaviour.

Avoid placing large amounts of logic directly inside config event-handler expressions.

When working with displays and controls:
- Verify that the display or control exists before accessing it.
- Handle display closure and unloading.
- Avoid stale control references.
- Clean up event handlers when they are no longer needed.
- Avoid unnecessary per-frame UI updates.

### 5.4. UI Testing

Test interfaces in-game whenever possible.

Static configuration inspection is not sufficient to verify:
- Actual positioning.
- Scaling.
- Control interactions.
- Focus and input handling.
- Display lifecycle.
- Multiplayer behaviour.

---

## 6. Event Handlers and Initialization

Choose the appropriate initialization mechanism for the feature.

Understand the difference between:
- Addon preStart.
- Addon preInit.
- Addon postInit.
- Object initialization.
- Display initialization.
- Runtime event handlers.

Do not assume that all objects, displays or player entities are available during addon initialization.

Avoid relying on initialization order unless it is guaranteed by the engine or the project's dependencies.

Remove dynamically registered event handlers when their lifetime ends.

For CBA Extended Event Handlers and CBA-specific event systems, follow `docs/skills/cba/skill.md`.

---

## 7. Performance

Arma 3 performance can be affected by scripts running on multiple clients and by frequent engine interactions.

Prefer event-driven implementations over continuous polling.

Avoid:
- Unnecessary `while` loops.
- Unnecessary `waitUntil` loops.
- Per-frame handlers when a less frequent update is sufficient.
- Repeated searches through large arrays.
- Repeated config lookups inside frequently executed code.
- Excessive network traffic.
- Creating scripts for operations that can be performed directly.

When a loop or periodic update is necessary:
- Use an appropriate update interval.
- Provide an exit condition.
- Avoid unnecessary work inside each iteration.
- Ensure the loop does not continue after its associated object or display is removed.

Do not optimize blindly. First identify the actual performance problem.

---

## 8. Debugging and Validation

Use the available debugging tools and game logs.

Useful sources include:
- Arma 3 RPT logs.
- `diag_log`.
- `diag_tickTime`.
- `diag_fps`.
- `diag_fpsMin`.
- Script and configuration error messages.

For SQF code:
1. Inspect the code and its execution context.
2. Verify unfamiliar commands with a3ref.
3. Use `lint_sqf` when available.
4. Check syntax and parameter types.
5. Review locality and scheduler requirements.
6. Test the implementation in-game when possible.

For config errors:
1. Inspect the relevant inheritance chain.
2. Verify class names and included files.
3. Check addon dependencies.
4. Inspect the RPT for configuration errors.
5. Confirm that the correct addon is loaded.

Never claim that something has been tested in-game if it has only been inspected statically.

---

## 9. Arma 3 Tools

The project has Arma 3 Tools installed at:

```text
D:\SteamLibrary\steamapps\common\Arma 3 Tools
```

The tools may be used when they are useful and accessible in the current environment.

Examples include:
- Inspecting or validating addon assets.
- Checking packed addon files.
- Working with supported game file formats.
- Performing simple asset-related operations.
- Using available tools for straightforward validation tasks.

Do not assume that every Arma 3 Tool is available through a command-line interface.

Before attempting automation:
1. Check whether the relevant tool exists.
2. Determine whether it supports command-line usage.
3. Verify its arguments and expected input/output.
4. Prefer a simple, reliable workflow.

For trivial tasks, use Arma 3 Tools directly when practical.

For complex or unsupported operations, explain the limitation instead of inventing commands or pretending that the operation was completed.

### PAA Textures and Images

PAA image assets are prepared manually by the user.

Do not generate, edit, convert or replace PAA assets automatically unless explicitly requested.

When a task requires an image:
- Implement the relevant config or UI reference.
- Use an existing asset if one is available.
- Clearly indicate where the user needs to provide the PAA file.
- Do not invent an asset path.

---

## 10. External Frameworks

This skill covers general Arma 3 development, not the internal documentation of external frameworks.

When working with:

### ACE3
Read:

`docs/skills/ace/skill.md`

Use official ACE3 documentation and source code to verify APIs.

### CBA
Read:

`docs/skills/cba/skill.md`

Use official CBA documentation and source code to verify APIs.

### HEMTT
Read:

`docs/skills/hemtt/skill.md`

Use it for build configuration, project validation and packaging.

Do not reimplement functionality already provided by a dependency without a clear reason.

---

## 11. Working with AI Agents

Agents must work incrementally and preserve the existing project architecture.

Before implementation:
1. Understand the requested behaviour.
2. Inspect the relevant addon and its dependencies.
3. Identify the engine APIs involved.
4. Consult a3ref for unfamiliar functionality.
5. Read relevant specialized skills.
6. Plan the smallest appropriate implementation.

During implementation:
- Follow existing naming and macro conventions.
- Reuse existing functions and systems.
- Avoid unrelated changes.
- Keep code organized.
- Do not introduce unnecessary dependencies.
- Do not silently change existing behaviour.

After implementation:
- Inspect the complete changes.
- Check includes and references.
- Run available static validation.
- Use a3ref SQF linting when available.
- Report what was changed.
- Clearly state what has and has not been tested.

If an API or implementation detail cannot be verified, say so explicitly.

Correctness and compatibility with the existing project take priority over producing code quickly.

---

## 12. Priority Rules

When instructions conflict, use this priority:

1. Explicit user requirements.
2. Existing project architecture and conventions.
3. Relevant specialized project skills.
4. This general Arma 3 skill.
5. Official Arma 3 documentation.
6. General development conventions.

Do not replace project-specific decisions with generic conventions without a good reason.
