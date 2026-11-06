# Coding Guidelines — kolmipilot Police Mod

## Purpose

This skill defines mandatory coding, architectural and development guidelines for `kolmipilot-Police-Mod`.

The project uses ACE3 and CBA as dependencies. Development should follow the project's own conventions while remaining compatible with the architecture and APIs of these frameworks.

The guidelines are inspired by ACE3 Coding Guidelines but adapted to this project's namespace, macros, addon structure and development workflow.

**Primary objectives:**
- Consistent addon architecture.
- Correct use of macros.
- Separation of functionality into independent files.
- Reusable and maintainable SQF functions.
- Correct integration with ACE3 and CBA.
- Compatibility with the project's existing infrastructure.

These rules apply when creating, modifying, reviewing or refactoring SQF, HPP, CPP and XML files.

---

# 1. Project Identity and Namespaces

## 1.1 Project Namespace

The project's namespace is:

`kolmip`

Use the following naming conventions for functionality owned by this mod:

- Global variables: `kolmip_component_variableName`.
- Functions: `kolmip_component_fnc_functionName`.
- Stringtable entries: `STR_KOLMIP_COMPONENT_Name`.
- Components: lowercase `snake_case`.

Examples:

```sqf
kolmip_common_isSomething
kolmip_police_fnc_createInteraction
STR_KOLMIP_POLICE_Interaction
```

## 1.2 ACE3 Namespace Exception

ACE3 is a mandatory dependency of this mod.

**ACE3 identifiers must retain their original ACE namespace.**

When implementing or integrating ACE3 functionality, it is perfectly valid and expected to use:

```sqf
ace_interact_menu_fnc_createAction
ace_interact_menu_fnc_addActionToObject
ace_common_fnc_isPlayer
ace_medical_fnc_someFunction
```

Similarly, ACE3 variables, macros, configuration classes, event handlers and other identifiers must retain their original names.

Never rename ACE3 identifiers to `kolmip_`.

The namespace rules are:

| Functionality ownership | Namespace |
|---|---|
| Your mod's functions | `kolmip_` |
| Your mod's variables | `kolmip_` |
| Your mod's configuration | Project conventions |
| ACE3 functions | `ace_` |
| ACE3 variables | `ace_` |
| ACE3 configuration | Original ACE3 classes |
| CBA functions | `CBA_` |

When extending ACE3 functionality, use ACE3's public API and preserve its original identifiers.

For example, an interaction implemented by this mod should use `kolmip_` for its own functions while calling ACE3 functions through their original `ace_` identifiers.

---

# 2. ACE3 as a Development Reference

ACE3 is an official dependency and an important reference for this project.

## 2.1 Official Source Repository

The agent is explicitly allowed and encouraged to consult the official ACE3 repository:

https://github.com/acemod/ACE3/

Use it as a source of truth when implementing ACE3 integrations.

Relevant resources:

- Repository: https://github.com/acemod/ACE3/
- Development documentation: https://ace3.acemod.org/wiki/development/
- Coding Guidelines: https://ace3.acemod.org/wiki/development/coding-guidelines
- ACE3 source code: https://github.com/acemod/ACE3/tree/master/addons

## 2.2 When to Consult ACE3

Consult the ACE3 repository whenever the requested implementation involves:

- ACE Interactions.
- ACE Medical.
- ACE Arsenal.
- ACE Captives.
- ACE Explosives.
- ACE Explosions.
- ACE Common.
- ACE Hearing.
- ACE Equipment.
- Any other ACE3 subsystem.

For example, when asked to add an ACE interaction:

1. Inspect the relevant ACE3 addon.
2. Identify the appropriate public functions and APIs.
3. Check how ACE3 expects actions to be created and registered.
4. Check the expected arguments and return values.
5. Inspect existing implementations for established patterns.
6. Implement the integration using the project's own namespace and architecture.

Do not guess ACE3 function signatures or configuration requirements.

## 2.3 ACE3 Code Is a Reference, Not a Replacement

Do not blindly copy large sections of ACE3 code.

Prefer using existing ACE3 functions and public interfaces.

If a custom implementation is necessary, follow ACE3's established coding conventions where appropriate.

Do not unnecessarily recreate functionality that ACE3 already provides.

Do not introduce private ACE3 implementation details as dependencies when a public API exists.

## 2.4 ACE3 Macros

ACE3-specific macros may be used when they are provided by the appropriate ACE3 headers and are needed for integration.

However:

- Do not assume ACE3 macros are automatically available.
- Verify the required include and dependency.
- Do not overwrite project macros with ACE3 definitions.
- Do not copy ACE3 macro definitions into project headers unnecessarily.
- Keep ACE3 and project namespaces separate.

---

# 3. Existing Project Macro System

Macros are fundamental to this project.

**Always prefer existing macros over manually constructed identifiers and paths.**

Before creating or changing macros, inspect:

- `addons/main/script_macros.hpp`
- `addons/main/script_mod.hpp`
- `addons/main/script_component.hpp`
- `addons/common/script_component.hpp`
- `include/x/cba/addons/main/script_macros_common.hpp`
- `include/x/cba/addons/xeh/script_xeh.hpp`

The project uses CBA macro infrastructure with its own extensions.

Do not replace this system with a different macro implementation.

## 3.1 Component Definition

The component header defines the component:

```cpp
#define COMPONENT common
#define COMPONENT_BEAUTIFIED Common

#include "\z\kolmip\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#include "\z\kolmip\addons\main\script_macros.hpp"
```

When creating another addon, replace the component definitions appropriately.

For example:

```cpp
#define COMPONENT police
#define COMPONENT_BEAUTIFIED Police

#include "\z\kolmip\addons\main\script_mod.hpp"
#include "\z\kolmip\addons\main\script_macros.hpp"
```

Do not manually define the project's function and variable namespaces when they are already generated by CBA macros.

## 3.2 Global Variable Macros

Use:

```sqf
GVAR(variableName)
QGVAR(variableName)
EGVAR(component,variableName)
QEGVAR(component,variableName)
```

Examples:

```sqf
GVAR(isPoliceOfficer) = true;

_unit setVariable [QGVAR(isPoliceOfficer), true];
```

Use external component macros when accessing variables owned by another project addon.

Never manually write a complete `kolmip_` global variable name when the appropriate macro is available.

## 3.3 Function Macros

Use:

```sqf
FUNC(functionName)
EFUNC(component,functionName)
QFUNC(functionName)
QEFUNC(component,functionName)
```

Examples:

```sqf
[] call FUNC(initialize);

[_unit] call EFUNC(common,validateUnit);
```

Use the quoted variants when a string representation is required.

ACE3 functions are an exception: use their original ACE3 function identifiers.

## 3.4 PREP Macro

The project overrides CBA's `PREP` macro.

Its implementation is defined in:

`addons/main/script_macros.hpp`

The current implementation:

```cpp
#undef PREP

#ifdef DISABLE_COMPILE_CACHE
    #define LINKFUNC(x) {call FUNC(x)}
    #define PREP(fncName) FUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
    #define LINKFUNC(x) FUNC(x)
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif
```

Important rules:

- Always use `PREP(functionName)` for registering independently compiled functions.
- Never replace it with manual compilation without a justified reason.
- Understand that the project expects function filenames in the `fnc_` format.
- Respect the existing compile-cache mechanism.
- Do not redefine `PREP` inside individual addons.

Function registration belongs in the component's `XEH_PREP.hpp`.

Example:

```cpp
PREP(initialize);
PREP(createInteraction);
PREP(validateUnit);
```

## 3.5 Path Macros

The project defines additional path macros:

```cpp
PATHTOF2(var1)
QPATHTOF2(var1)
```

It also modifies existing CBA path macros when `SUBCOMPONENT` is defined.

Understand the difference between:

- `PATHTOF`
- `QPATHTOF`
- `PATHTO`
- `PATHTOEF`
- `QPATHTOEF`
- `PATHTOF2`
- `QPATHTOF2`

Do not manually construct addon paths when an appropriate macro already exists.

Use the appropriate macro depending on whether the path is quoted and whether the target is inside the current addon or another addon.

## 3.6 Stringtable Macros

Use the available CBA localization macro family:

```sqf
LSTRING(name)
LLSTRING(name)

ELSTRING(component,name)
LELSTRING(component,name)
```

In configuration files:

```cpp
CSTRING(name)
ECSTRING(component,name)
```

Check the macro definitions before using an unfamiliar variant.

All user-facing text must be localized through `stringtable.xml`.

## 3.7 Other Project Macros

The project also defines utility macros, including:

- `QQUOTE`
- `CLAMP`
- `WEAP_XX`
- `MAG_XX`
- `ITEM_XX`
- `CARGO_XX`
- `MAG_CSW`
- `DBUG_TEX_RED`
- `DBUG_TEX_GRN`
- `DBUG_TEX_BLU`
- `DBUG_TEX_PUR`
- `DBUG_TEX_YEL`

Use existing helpers where appropriate.

Do not create duplicate macros with equivalent functionality.

Do not introduce new global macros for functionality that is only needed in one function.

---

# 4. Addon Architecture

## 4.1 Project Addon Template

The authoritative template for creating new addons is the project's own:

`extras/blank`

**This is a project-maintained template, not an ACE3 template.**

Its current structure:

```text
extras/
└── blank/
    ├── $PBOPREFIX$
    ├── CfgEventHandlers.hpp
    ├── config.cpp
    ├── script_component.hpp
    ├── stringtable.xml
    ├── XEH_preInit.sqf
    ├── XEH_PREP.hpp
    ├── XEH_preStart.sqf
    │
    └── functions/
        └── fnc_empty.sqf
```

When creating a new addon:

1. Use `extras/blank` as the starting point.
2. Preserve the established initialization structure.
3. Preserve the existing configuration organization.
4. Adapt component names and paths.
5. Remove unnecessary example functionality.
6. Add only the files needed by the new addon.

Do not invent a new addon structure when the template already provides one.

If the template changes, use its current version rather than relying on an old example.

## 4.2 Addon Isolation

Each addon should represent a logically independent feature or a closely related group of features.

Examples:

- `common` — shared utilities.
- `police` — police-specific functionality.
- `equipment` — equipment systems.
- `interactions` — interaction systems.

These are examples, not mandatory addon names.

Do not create an addon for every individual function.

Do not put unrelated functionality into one addon simply to reduce the number of directories.

## 4.3 Separation of Responsibilities

Separate functionality according to its purpose.

Typical directories:

```text
functions/
data/
    textures/
    images/
ui/
    dialogs/
```

Typical configuration headers:

```text
CfgEventHandlers.hpp
CfgVehicles.hpp
CfgWeapons.hpp
CfgSettings.hpp
RscTitles.hpp
```

These are examples. Only create what the addon actually requires.

Do not put unrelated configuration classes directly into `config.cpp`.

Keep configuration headers focused on a single responsibility.

## 4.4 No Monolithic Files

Never put multiple unrelated functions into one SQF file.

Every independently compiled function must have its own file.

Correct:

```text
functions/
├── fnc_initialize.sqf
├── fnc_createInteraction.sqf
├── fnc_validateUnit.sqf
├── fnc_openPoliceMenu.sqf
└── fnc_handleInteraction.sqf
```

Incorrect:

```text
functions/
└── fnc_policeSystem.sqf
```

Containing initialization, interaction handling, validation, UI management and unrelated functionality.

Split code logically, not artificially.

---

# 5. Function Organization

## 5.1 Function Location

Independently compiled functions belong in:

```text
functions/fnc_functionName.sqf
```

Register them in `XEH_PREP.hpp`:

```cpp
PREP(functionName);
```

Do not create function files outside the established structure without a specific architectural reason.

## 5.2 Function Includes

Every function must include its component header.

Example:

```sqf
#include "..\script_component.hpp"
```

Use the correct relative path for the file's location.

## 5.3 Function Documentation

Use a consistent documentation header:

```sqf
#include "..\script_component.hpp"
/*
 * Author: kolmipilot
 * Description: Validates whether a unit is eligible for an interaction.
 *
 * Arguments:
 * 0: Unit to validate <OBJECT>
 *
 * Return Value:
 * Whether the unit is valid <BOOL>
 *
 * Example:
 * [_unit] call FUNC(validateUnit);
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]]];

if (isNull _unit) exitWith {
    false
};

true
```

Document arguments, return values and expected behavior accurately.

Public functions must validate their inputs.

## 5.4 Function Size

Aim to keep functions below 250 lines, excluding documentation and includes.

If a function becomes too large, consider splitting it into smaller functions.

Do not split code artificially when it would reduce readability.

## 5.5 Function Reuse

Extract repeated functionality into reusable functions.

Avoid duplicating implementations across addons.

Shared functionality should belong in an appropriate shared component.

Use external component macros when accessing functionality from another project addon.

---

# 6. Configuration Organization

Keep configuration files separated by purpose.

Examples:

- `CfgVehicles.hpp`
- `CfgWeapons.hpp`
- `CfgEventHandlers.hpp`
- `CfgSettings.hpp`
- `Cfg3DEN.hpp`
- `RscTitles.hpp`

The main `config.cpp` should primarily:

1. Include `script_component.hpp`.
2. Define `CfgPatches`.
3. Declare addon dependencies and metadata.
4. Include the appropriate configuration headers.

Follow the existing project template for exact declarations and ordering.

## 6.1 Dependencies

The mod depends on ACE3 and CBA.

When an addon directly uses functionality from another addon, declare the appropriate dependency in `CfgPatches.requiredAddons`.

Do not assume that another addon is available merely because ACE3 is a dependency.

Check the actual ACE3 addon configuration to identify the correct `CfgPatches` class.

Do not invent dependency class names.

Avoid unnecessary dependencies.

---

# 7. SQF Coding Standards

## 7.1 Private Variables

Always declare private variables using `private` or `params`.

Correct:

```sqf
private _unit = player;
private _isValid = true;
```

Correct:

```sqf
params ["_unit", "_vehicle"];
```

Incorrect:

```sqf
_unit = player;
```

Use descriptive variable names.

## 7.2 Variable Scope

Declare variables in the smallest reasonable scope.

Avoid unnecessarily long-lived variables.

Do not use global variables to transfer data between functions when parameters and return values are sufficient.

## 7.3 Function Parameters

Use `params` or `param`.

Example:

```sqf
params [
    ["_unit", objNull, [objNull]],
    ["_enabled", true, [true]]
];
```

Validate inputs for public APIs.

## 7.4 Return Values

Functions must return meaningful values when callers depend on their results.

Use `nil` when no meaningful return value exists.

Avoid arbitrary return values.

## 7.5 Magic Numbers

Avoid unexplained numeric constants.

Bad:

```sqf
if (_distance > 15) then {
    // ...
};
```

Better:

```sqf
#define INTERACTION_MAX_DISTANCE 15

if (_distance > INTERACTION_MAX_DISTANCE) then {
    // ...
};
```

Use component-level definitions for constants shared by multiple functions.

Keep function-specific constants local when appropriate.

## 7.6 getVariable

Always provide a sensible default.

```sqf
private _isPolice = _unit getVariable [QGVAR(isPoliceOfficer), false];
```

## 7.7 Arrays

Use consistent spacing.

Prefer `pushBack` for adding a single element and `append` for adding multiple elements.

Avoid unnecessary array recreation.

---

# 8. Code Formatting

Follow `.editorconfig` and the project's existing formatting conventions.

- Indentation: 4 spaces.
- No tabs.
- No trailing whitespace.
- Opening braces on the same line.
- Closing braces on their own lines.
- Consistent array formatting.

Example:

```sqf
if (_condition) then {
    private _result = true;

    if (_result) then {
        call FUNC(doSomething);
    };
} else {
    call FUNC(handleFailure);
};
```

Use comments to explain why something is done rather than repeating what the code already expresses.

Remove obsolete commented-out code.

---

# 9. Performance and Design

## 9.1 Event-Driven Architecture

Prefer event-driven implementations over continuous polling.

Use CBA and Arma event handlers where appropriate.

Avoid unnecessary permanently running scripts.

## 9.2 Scheduled and Unscheduled Execution

Understand the execution environment before using `spawn`, `sleep` or `execVM`.

Do not introduce scheduled execution without a reason.

Do not sacrifice correctness simply to avoid scheduled execution.

## 9.3 Avoid Duplicate Work

Avoid unnecessary recalculation, temporary objects and repeated data retrieval.

Cache data when it is appropriate and safe.

## 9.4 Readability

Readability and maintainability take priority over premature optimization.

Document unusual performance-related decisions.

---

# 10. Initialization

Follow the initialization architecture from `extras/blank`.

Understand the responsibilities of:

- `XEH_preInit.sqf`
- `XEH_preStart.sqf`
- `XEH_postInit.sqf`, when required.
- `XEH_PREP.hpp`
- `CfgEventHandlers.hpp`

Keep function registration separate from runtime initialization.

Avoid duplicate initialization.

Do not put gameplay logic into `config.cpp`.

---

# 11. Localization

All user-facing text must be stored in `stringtable.xml`.

Use the project's localization conventions and CBA macros.

Example:

```xml
<Package name="KOLMIP_POLICE">
    <Key ID="STR_KOLMIP_POLICE_Interaction">
        <Original>Police interaction</Original>
        <English>Police interaction</English>
        <Polish>Interakcja policyjna</Polish>
    </Key>
</Package>
```

Follow the existing XML structure.

Do not hardcode user-facing text in SQF or configuration files.

---

# 12. AI-Assisted Development Workflow

These rules are mandatory when working on this repository.

## 12.1 Before Creating Code

1. Inspect the relevant addon.
2. Read its `script_component.hpp`.
3. Inspect the project macro definitions.
4. Examine similar existing implementations.
5. Check `extras/blank` when creating a new addon.
6. Determine whether functionality belongs in an existing addon.
7. Consult ACE3 source code when implementing ACE3 integrations.

Never assume an existing project convention without checking the actual implementation.

## 12.2 When Creating a New Addon

1. Use `extras/blank` as the template.
2. Preserve its architecture.
3. Use the project's naming conventions.
4. Use existing macros.
5. Separate independently compiled functions into individual SQF files.
6. Separate configuration into appropriate HPP files.
7. Register functions through `PREP`.
8. Add localization when needed.
9. Declare correct addon dependencies.
10. Verify includes and paths.

## 12.3 When Implementing ACE3 Functionality

1. Identify the relevant ACE3 subsystem.
2. Consult its official source repository.
3. Verify function signatures and expected arguments.
4. Prefer public ACE3 APIs.
5. Retain original `ace_` identifiers.
6. Keep custom functionality under the `kolmip_` namespace.
7. Declare required dependencies.
8. Follow ACE3 conventions where appropriate without replacing the project's architecture.

## 12.4 When Modifying Existing Code

- Preserve the existing architecture.
- Do not rename unrelated functions.
- Do not replace macros with manually written identifiers.
- Do not introduce another macro system.
- Do not move files without a clear reason.
- Do not duplicate existing functionality.
- Avoid unnecessary refactoring.

## 12.5 Before Finishing

Verify:

- All functions are registered.
- All includes resolve correctly.
- Macro names are valid.
- Global variables use the correct namespace.
- ACE3 identifiers retain their original names.
- Configuration files are properly separated.
- Dependencies are correct.
- User-facing text is localized.
- No unnecessary files or directories were created.
- No duplicated or unreachable code was introduced.

Use HEMTT and existing validation tools when appropriate.

Never claim a build or validation succeeded without actually running it.

---

# 13. Priority Rules

When implementation choices conflict, prioritize:

1. Existing project architecture and conventions.
2. The project's `extras/blank` template for addon structure.
3. Existing project macro definitions.
4. Official ACE3 and CBA APIs for framework integration.
5. Modularity and separation of responsibilities.
6. Readability and maintainability.
7. Performance optimizations.

**Core principle:**

Develop `kolmip` functionality using `kolmip` conventions, integrate ACE3 using ACE3's original APIs and identifiers, and preserve the project's established addon architecture.

Never invent conventions when an established implementation already exists.
