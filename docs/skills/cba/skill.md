# CBA Development Guidelines — kolmipilot Police Mod

## Purpose

This skill defines how to use Community Base Addons (CBA) when developing `kolmipilot-Police-Mod`.

It focuses specifically on CBA framework features, APIs, lifecycle management and integration with the project's existing infrastructure.

**This skill complements `docs/skills/ace/skill.md`.**

Do not duplicate general SQF coding standards, naming conventions, addon architecture or documentation guidelines defined in the ACE coding skill. Follow those rules separately.

The project uses CBA as a dependency and relies on its macro infrastructure, Extended Event Handlers and function compilation system.

---

# 1. Official CBA References

The agent is explicitly allowed and encouraged to consult the official CBA documentation and source code.

Primary references:

- Documentation: https://cbateam.github.io/CBA_A3/docs/
- General documentation index: https://cbateam.github.io/CBA_A3/docs/index/General.html
- Functions index: https://cbateam.github.io/CBA_A3/docs/index/Functions.html
- Macros index: https://cbateam.github.io/CBA_A3/docs/index/Macros.html
- GitHub repository: https://github.com/cbateam/cba_a3
- Common macros: https://github.com/CBATeam/CBA_A3/blob/master/addons/main/script_macros_common.hpp

When implementing CBA functionality:

1. Check the official documentation.
2. Inspect the actual function implementation when necessary.
3. Verify argument types, order and return values.
4. Check whether an appropriate CBA function already exists.
5. Prefer established CBA APIs over custom implementations.

Never guess function signatures or assume that an API behaves like a similarly named Arma 3 command.

The official CBA source code takes precedence over outdated examples or third-party tutorials.

---

# 2. Project-Specific CBA Integration

## 2.1 Existing Macro Infrastructure

The project already includes CBA infrastructure through:

`addons/main/script_macros.hpp`

Currently included headers:

```cpp
#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"
```

Do not introduce duplicate CBA includes in individual functions without a specific reason.

Do not copy CBA macro definitions into individual addons.

Use the existing project macro system.

## 2.2 PREP and Function Compilation

The project overrides CBA's `PREP` macro.

Its implementation uses:

```cpp
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
```

The project also supports a separate compilation mode through `DISABLE_COMPILE_CACHE`.

Important rules:

- Use `PREP(functionName)` for function registration.
- Do not manually call `CBA_fnc_compileFunction` for ordinary project functions.
- Do not replace the project's compilation system with another implementation.
- Preserve compatibility with both compilation modes.
- Do not manually compile the same function multiple times.

The `PREP` macro already handles the integration with CBA.

## 2.3 CBA Function Namespace

CBA functions retain their original names:

```sqf
CBA_fnc_addEventHandler
CBA_fnc_localEvent
CBA_fnc_globalEvent
CBA_fnc_addPerFrameHandler
CBA_fnc_addSetting
```

Never rename CBA functions to the project's `kolmip_` namespace.

Likewise, do not create custom replacements for existing CBA functionality without a clear technical reason.

---

# 3. Extended Event Handlers (XEH)

XEH is one of the most important parts of CBA.

Prefer XEH over manually attaching event handlers to every object when the functionality is intended to integrate with Arma's configuration-based event system.

## 3.1 Available Lifecycle Events

Understand the differences between:

- `preStart`
- `preInit`
- `postInit`
- `Init`
- `InitPost`
- Other supported engine event handlers.

Use the appropriate lifecycle stage.

General guidance:

| Event | Intended use |
|---|---|
| `preStart` | Early initialization before mission initialization |
| `preInit` | Initialize addon systems and register required functionality |
| `postInit` | Initialize systems requiring later initialization stages |
| `Init` | Object initialization |
| `InitPost` | Object initialization after the regular initialization stage |

Do not assume that all events execute in the same environment or at the same time.

Check CBA implementation and Arma documentation when execution order matters.

## 3.2 XEH Configuration

Use the project's existing configuration organization.

`CfgEventHandlers.hpp` is part of the addon template.

Keep event handler declarations organized and avoid unnecessarily placing all event handlers inside `config.cpp`.

When adding class-specific event handlers:

- Use the appropriate Extended Event Handler mechanism.
- Verify the correct event name.
- Check inheritance behavior.
- Avoid registering duplicate handlers.
- Account for client, server and dedicated-server execution.

## 3.3 Initialization Safety

Initialization must be predictable.

Avoid:

- Registering the same event handler multiple times.
- Initializing the same system in both `preInit` and `postInit`.
- Assuming `player` exists during `preInit`.
- Accessing mission objects before they are available.
- Running client-specific functionality on dedicated servers.

If functionality requires a player object, use an appropriate player initialization or respawn event.

## 3.4 Event Handler Cleanup

When registering handlers dynamically, retain their IDs when necessary.

Remove handlers when they are no longer required.

Avoid accumulating handlers after respawn, object replacement or repeated initialization.

---

# 4. CBA Custom Event System

Use CBA's custom event system for communication between independent systems.

This is preferable to creating unnecessary global variables or tightly coupling unrelated functions.

## 4.1 Event Registration

Use:

```sqf
CBA_fnc_addEventHandler
```

Example:

```sqf
[
    QGVAR(policeUnitRegistered),
    {
        params ["_unit"];

        [_unit] call FUNC(handlePoliceUnit);
    }
] call CBA_fnc_addEventHandler;
```

The function returns an event handler ID.

Retain this ID if the handler may need to be removed later.

## 4.2 Raising Events

CBA provides different event execution mechanisms:

| Function | Purpose |
|---|---|
| `CBA_fnc_localEvent` | Local event |
| `CBA_fnc_globalEvent` | Global event |
| `CBA_fnc_globalEventJIP` | Global event with Join-In-Progress handling |
| `CBA_fnc_serverEvent` | Server-targeted event |
| `CBA_fnc_targetEvent` | Targeted event |
| `CBA_fnc_ownerEvent` | Event directed to the owner of an object |
| `CBA_fnc_remoteEvent` | Remote event mechanism |

Use the appropriate mechanism according to where the event must execute.

Do not use a global event when a local event is sufficient.

Do not use a network event to communicate information that only one client needs.

## 4.3 Event Naming

Use the project's namespace for custom event names.

Example:

```sqf
QGVAR(policeUnitRegistered)
QGVAR(interactionStarted)
QGVAR(interactionCompleted)
```

Do not use generic event names that could conflict with other addons.

## 4.4 Event Arguments

Keep event payloads simple and consistent.

Use arrays containing the required arguments.

Document the expected argument order.

Validate received arguments when events can originate from other systems.

## 4.5 Networked Events

Before using a networked event, determine:

- Which machine sends the event?
- Which machine receives it?
- Does the operation need to execute on the server?
- Does it need to execute on every client?
- Is Join-In-Progress support required?
- Is the event payload validated?

Never assume that an event being networked automatically makes its contents trustworthy.

Do not use remote events as a substitute for proper server-side validation.

Do not broadcast unnecessary data.

---

# 5. Per-Frame Handlers (PFH)

Use CBA Per-Frame Handlers for functionality that genuinely requires periodic execution.

Primary API:

```sqf
CBA_fnc_addPerFrameHandler
CBA_fnc_removePerFrameHandler
```

## 5.1 Registration

Example:

```sqf
GVAR(pfhHandle) = [{
    params ["_args", "_handle"];

    // Periodic functionality
}, 1, []] call CBA_fnc_addPerFrameHandler;
```

The parameters are:

1. Code to execute.
2. Delay between executions in seconds.
3. Arguments passed to the handler.

The handler receives:

- `_this select 0` — supplied arguments.
- `_this select 1` — handler ID.

A delay of `0` means execution every frame.

## 5.2 Performance

Avoid using PFH for functionality that can be implemented using event handlers.

Prefer a reasonable execution interval.

Do not use every-frame execution for operations that only need to happen once per second or after a specific event.

Avoid expensive operations inside PFH callbacks.

Never perform unnecessary object searches, config lookups or large array operations every frame.

## 5.3 Handler Cleanup

Store the returned handler ID when the handler needs to be removed.

Example:

```sqf
[GVAR(pfhHandle)] call CBA_fnc_removePerFrameHandler;
```

Remove handlers when:

- Their functionality is no longer required.
- A system is disabled.
- An object is deleted.
- A temporary monitoring process ends.

Prevent duplicate PFH registration.

## 5.4 PFH Design

A PFH should:

- Have one clear responsibility.
- Use explicit arguments.
- Avoid unnecessary global state.
- Avoid expensive operations.
- Have a clearly defined lifecycle.

Do not create permanent PFHs without a justified reason.

---

# 6. CBA Keybindings

Use CBA's keybinding system for configurable user controls.

Primary API:

- `CBA_fnc_addKeybind`
- `CBA_fnc_addKeyHandler`
- `CBA_fnc_addKeyHandlerFromConfig`
- `CBA_fnc_getKeybind`
- `CBA_fnc_registerKeybind`

Consult the official documentation for the correct API and current argument structure.

## 6.1 Keybind Registration

Use the appropriate CBA keybinding registration mechanism.

Keybindings should:

- Have a unique addon identifier.
- Have a unique action identifier.
- Have a localized display name.
- Have a tooltip when useful.
- Support configurable default keys.
- Respect user-defined key assignments.

Do not hardcode key handling through custom display event handlers when CBA's keybinding system is appropriate.

## 6.2 DIK Codes

The official CBA documentation references:

```cpp
#include "\a3\ui_f\hpp\defineDIKCodes.inc"
```

This project already contains:

```text
include/a3/ui_f/hpp/defineDIKCodes.inc
```

Use the existing project include infrastructure.

Prefer named DIK constants:

```cpp
DIK_TAB
DIK_K
DIK_ESCAPE
```

Avoid unexplained numeric key codes.

## 6.3 Key Down and Key Up

Understand the difference between key-down and key-up callbacks.

Use separate callbacks when the functionality requires detecting both events.

Do not use continuous key-hold execution when a single key-down event is sufficient.

Avoid blocking normal game controls unnecessarily.

## 6.4 Keybinding Localization

All keybinding names and tooltips must use the project's localization system.

Do not hardcode user-facing labels.

---

# 7. CBA Settings

Use CBA Settings for user-configurable addon options.

Primary API:

```sqf
CBA_fnc_addSetting
```

Settings should be registered during an appropriate initialization stage, normally `preInit`.

## 7.1 Supported Setting Types

CBA supports:

- `CHECKBOX`
- `EDITBOX`
- `LIST`
- `SLIDER`
- `COLOR`
- `TIME`

Check the official documentation for the required value format for each type.

## 7.2 Setting Registration

A setting registration must define:

- Unique setting identifier.
- Setting type.
- Display name.
- Category.
- Default value and additional parameters.
- Whether it is global.
- Optional callback executed when the value changes.
- Whether a mission restart is required.

Use the project's namespace for setting identifiers.

Example identifier:

```sqf
QGVAR(enablePoliceInteractions)
```

## 7.3 Setting Callbacks

Use callbacks when functionality needs to react immediately to setting changes.

Do not continuously poll settings through PFH just to detect changes.

Keep callbacks focused.

## 7.4 Settings and Multiplayer

Understand the difference between local and global settings.

Do not assume that a setting automatically synchronizes arbitrary gameplay state across machines.

For networked functionality, implement the necessary synchronization explicitly.

## 7.5 Localization

Setting names, tooltips and categories must use localized strings.

Never hardcode user-facing text.

---

# 8. CBA Utility Functions

Before implementing common functionality manually, inspect the CBA function library.

Relevant categories include:

- Arrays.
- Strings.
- Hashes.
- Vectors.
- Events.
- Network.
- UI.
- Keybindings.
- Settings.
- Diagnostics.
- XEH.

Examples of useful functions include:

```sqf
CBA_fnc_waitAndExecute
CBA_fnc_waitUntilAndExecute
CBA_fnc_execNextFrame
CBA_fnc_execAfterNFrames
CBA_fnc_hashCreate
CBA_fnc_hashGet
CBA_fnc_hashSet
CBA_fnc_hashRemove
CBA_fnc_select
CBA_fnc_filter
```

These are examples, not an exhaustive list.

Before implementing a utility function:

1. Search the official CBA function index.
2. Check its documentation.
3. Verify its arguments and return value.
4. Determine whether it fits the use case.
5. Prefer the existing CBA implementation when appropriate.

Do not reimplement an existing CBA utility without a technical reason.

---

# 9. CBA Macros

The project includes:

`include/x/cba/addons/main/script_macros_common.hpp`

This provides the common CBA macro infrastructure.

Use the existing macro definitions.

When an unfamiliar macro is needed:

1. Search the CBA macro index.
2. Inspect `script_macros_common.hpp`.
3. Verify how it expands.
4. Check whether the project already provides an equivalent macro.
5. Avoid defining conflicting macros.

The project has its own macro extensions and overrides.

**Never overwrite project-specific definitions with stock CBA definitions.**

In particular, preserve the project's:

- `PREP`
- `LINKFUNC`
- `PATHTOF2`
- `QPATHTOF2`
- `QQUOTE`
- `SUBADDON` handling.

---

# 10. Debugging and Diagnostics

Use CBA debugging functionality where appropriate.

Relevant resources include:

- CBA debugging macros.
- `CBA_fnc_debug`.
- CBA diagnostic addons.
- RPT logging.
- CBA XEH diagnostics.

Use the project's existing debug configuration.

Do not introduce a second logging framework unnecessarily.

Do not leave excessive debug output in production code.

When debugging an event-related problem, verify:

- Whether the handler was registered.
- Whether the event was raised.
- Which machine received it.
- Whether the callback executed.
- Whether its arguments are correct.

When debugging PFH problems, verify registration, execution interval and cleanup.

---

# 11. Common Mistakes to Avoid

Avoid these implementation patterns:

1. Using PFH when an event handler is sufficient.
2. Registering the same event handler multiple times.
3. Forgetting to remove dynamically registered handlers.
4. Using global events for local-only functionality.
5. Assuming network events automatically validate their payload.
6. Running client functionality on dedicated servers.
7. Assuming `player` is available during `preInit`.
8. Hardcoding DIK numbers.
9. Hardcoding setting names and descriptions.
10. Reimplementing existing CBA utilities.
11. Manually compiling functions instead of using the project's `PREP`.
12. Copying CBA macro definitions into project addons.
13. Using an API without verifying its signature.
14. Running expensive operations every frame.
15. Creating duplicate initialization logic.

---

# 12. AI-Assisted CBA Development Workflow

Whenever a task involves CBA functionality:

## Before implementation

1. Identify the relevant CBA subsystem.
2. Consult the official CBA documentation.
3. Inspect the relevant source implementation when necessary.
4. Check the project's current macro infrastructure.
5. Check how similar functionality is implemented in the repository.
6. Determine the correct initialization stage.
7. Determine the correct execution environment.

## During implementation

- Use CBA APIs instead of unnecessary custom systems.
- Keep CBA identifiers unchanged.
- Use project macros for custom functionality.
- Respect the project's `PREP` implementation.
- Use event-driven architecture where possible.
- Handle client/server execution correctly.
- Retain handler IDs when cleanup is required.

## Before finishing

Verify:

- Correct CBA API usage.
- Correct argument order and types.
- Correct initialization stage.
- Correct event execution environment.
- No duplicate registrations.
- PFH handlers have appropriate cleanup.
- Keybindings are configurable.
- Settings are properly registered.
- Network events are used appropriately.
- No existing CBA functionality was unnecessarily recreated.

Use HEMTT and the project's validation tools when appropriate.

Never claim successful validation without actually running it.

---

# 13. Priority Rules

When implementing CBA functionality, prioritize:

1. Existing project-specific CBA integration.
2. Official CBA documentation.
3. Official CBA source code.
4. Existing project implementations.
5. Correct lifecycle and execution environment.
6. Performance and maintainability.

**Core principle:**

Use CBA as the framework for event handling, scheduling, keybindings, settings, utilities and initialization.

Do not recreate CBA functionality unnecessarily, and never bypass the project's existing integration with CBA.
