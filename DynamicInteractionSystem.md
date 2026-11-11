# Dynamic Civilian and Suspect Interaction System

## Arma 3 --- SQF Technical Design and Implementation Guide

**Document type:** Implementation specification\
**Target:** Arma 3, SQF, CBA, ACE3 (optional)\
**Primary goal:** A reusable, data-driven police interaction system for
civilians and suspects, whether they are on foot or inside a vehicle.

------------------------------------------------------------------------

## 1. Design goals

The system should create believable, varied interactions without
requiring a separate script or config entry for every possible question
and answer.

The implementation should follow these principles:

1.  **Vehicle-agnostic interaction logic.** The core system operates on
    a civilian unit and an interaction context. It does not care whether
    the unit is walking or seated in a vehicle. A small adapter layer
    handles stopping, approaching, and vehicle-specific details.
2.  **Wanted records exist before an interaction.** Populate the wanted
    database during mission initialization, before any dynamic police
    interaction begins.
3.  **Generate the complete civilian profile when an officer requests a
    stop.** Do not generate a full behavioural profile when the unit is
    spawned.
4.  **Allow a pre-dialogue reaction.** Immediately after profile
    generation, an aware wanted person or an active offender may choose
    to flee before the first dialogue line is displayed.
5.  **Keep hidden information hidden.** The officer must not receive the
    civilian's criminal status, awareness, personality values, or
    internal decision variables until a legitimate in-game check reveals
    relevant information.
6.  **Use a state machine, not a long chain of nested conditions.**
    Every interaction has one current state and a defined set of valid
    transitions.
7.  **Use data-driven dialogue.** Store dialogue lines and their
    conditions in SQF data structures or external data files. Do not
    create a new UI config class for every line.
8.  **Separate dialogue from behaviour.** A line of dialogue is
    presentation. A state transition is game logic. Do not make the text
    itself determine the NPC's state.
9.  **Make the server authoritative in multiplayer.** The server owns
    the profile, hidden status, random decisions, and state transitions.
    Clients request actions and display approved results.
10. **Keep the system extensible.** New civilian types, dialogue packs,
    and police actions should be addable without rewriting the core.

The system may represent flight, surrender, refusal, or hostile
escalation as abstract gameplay states. It should not attempt to
reproduce real-world tactics or provide real-world guidance for violence
or evasion.

------------------------------------------------------------------------

## 2. High-level lifecycle

The intended lifecycle is:

``` text
MISSION INITIALIZATION
    |
    +--> Build wanted database
    |
    +--> Register functions and event handlers
    |
    +--> Register generic police interaction entry point
    |
    v
OFFICER REQUESTS A STOP
    |
    +--> Resolve the civilian unit
    +--> Check that no interaction is already active
    +--> Generate the complete hidden profile
    +--> Create an interaction session
    |
    v
PRE-DIALOGUE DECISION
    |
    +--> Eligible aware wanted / active offender?
    |       |
    |       +--> May select an immediate flight state
    |       +--> Otherwise continue
    |
    v
INITIAL DIALOGUE
    |
    v
POLICE ACTION <--> CIVILIAN RESPONSE
    |
    +--> Dialogue
    +--> Identity request
    +--> Registration lookup
    +--> Database lookup
    +--> Cooperation / refusal
    +--> Other supported interaction actions
    |
    v
END INTERACTION
```

The profile is generated at the **stop request**, before the first
dialogue line. The pre-dialogue decision is evaluated immediately after
the profile is created. Therefore, a civilian can react before the
officer gets a spoken response.

### Important distinction

There are two separate moments:

-   **Wanted database creation:** mission initialization.
-   **Civilian profile creation:** when the officer requests the stop.

A wanted record is not the same thing as an active interaction profile.
The database record may already exist, while the civilian's personality,
awareness, stress, and initial decision are generated only when the
interaction begins.

------------------------------------------------------------------------

## 3. Data model

Use HashMaps for named fields. They are easier to maintain than arrays
with undocumented numeric indexes.

### 3.1 Wanted database

The wanted database should be created before interactions start. A
HashMap keyed by a stable identity is a reasonable starting point.

``` sqf
missionNamespace setVariable ["TAG_wantedDatabase", createHashMap];

private _database = missionNamespace getVariable ["TAG_wantedDatabase"];

_database set ["ID_0001", createHashMapFromArray [
    ["wanted", true],
    ["reason", "Outstanding warrant"],
    ["severity", "high"],
    ["displayName", "Example Person"]
]];
```

Use a stable identity key that is appropriate for the mission. Do not
rely only on a display name: names may be duplicated or changed.

For a prototype, records can be declared in a mission data file. For a
larger system, load them from a structured data source during
initialization.

### 3.2 Civilian profile

Generate this profile when the officer requests a stop.

Suggested fields:

  -----------------------------------------------------------------------
  Field                   Type                    Purpose
  ----------------------- ----------------------- -----------------------
  `identityKey`           String                  Key used for database
                                                  lookup

  `category`              String                  `wanted`, `clean`, or
                                                  `unregistered`

  `knowsWantedStatus`     Boolean                 Whether the person
                                                  knows they are wanted

  `stress`                Number                  Current stress value

  `aggression`            Number                  Abstract behavioural
                                                  tendency

  `compliance`            Number                  Likelihood of
                                                  cooperation

  `fear`                  Number                  Abstract fear value

  `personality`           String                  Optional personality
                                                  preset

  `initialReaction`       String                  Result of the
                                                  pre-dialogue decision

  `profileCreated`        Boolean                 Prevents accidental
                                                  regeneration
  -----------------------------------------------------------------------

Example structure:

``` sqf
private _profile = createHashMapFromArray [
    ["identityKey", _identityKey],
    ["category", "clean"],
    ["knowsWantedStatus", false],
    ["stress", 15],
    ["aggression", 10],
    ["compliance", 75],
    ["fear", 10],
    ["personality", "calm"],
    ["initialReaction", "none"],
    ["profileCreated", true]
];
```

The values above are examples, not final balancing values. Define ranges
and distributions centrally.

### 3.3 Interaction session

Keep the session separate from the profile. A profile describes the
civilian; a session describes one particular encounter.

``` sqf
private _session = createHashMapFromArray [
    ["sessionId", format ["%1_%2", diag_tickTime, floor random 100000]],
    ["officer", _officer],
    ["civilian", _civilian],
    ["profile", _profile],
    ["state", "created"],
    ["dialogueNode", "initial_greeting"],
    ["knownFacts", createHashMap],
    ["startedAt", diag_tickTime],
    ["active", true]
];
```

`knownFacts` contains only information legitimately discovered by the
officer. For example, a successful identity lookup can add a fact to
this map. Do not copy the entire hidden profile into `knownFacts`.

Store the active session in a suitable namespace or server-side
registry, indexed by the civilian or session ID. Ensure that a civilian
cannot accidentally receive two simultaneous sessions.

------------------------------------------------------------------------

## 4. Civilian categories and profile generation

Use three top-level categories:

### 4.1 `wanted`

The identity exists in the wanted database.

Two awareness variants:

-   `knowsWantedStatus = true`: the civilian knows they are wanted.
-   `knowsWantedStatus = false`: the civilian does not know they are
    wanted.

An aware wanted civilian may select an immediate pre-dialogue reaction.
If the person does not take that branch, the interaction continues
normally and their later responses are selected from the aware-wanted
dialogue set.

An unaware wanted civilian initially behaves according to their ordinary
personality. Their behaviour may change after the officer reveals the
wanted status.

### 4.2 `clean`

The civilian is not wanted and is not an unregistered offender.

Suggested behavioural variants:

-   Cooperative.
-   Uncooperative.
-   Nervous but cooperative.
-   Confused.
-   Irritated.

Refusing a request should not automatically make a clean civilian a
criminal. A refusal is a behavioural response, not proof of criminal
status.

### 4.3 `unregistered`

The civilian has committed an offence in the scenario but is not present
in the wanted database.

This category is intentionally different from `wanted`:

-   A database lookup should not return a wanted record.
-   The hidden profile can still influence the civilian's behaviour.
-   The civilian may behave cautiously or become unsettled.
-   The officer should not be told that the civilian is an offender
    merely because the profile says so.

### 4.4 Profile generation rules

A recommended generation sequence:

1.  Obtain the civilian's stable identity key.
2.  Check whether the identity exists in the wanted database.
3.  If it exists, set category to `wanted`.
4.  Otherwise, use the scenario's configured probability to decide
    between `clean` and `unregistered`.
5.  For a wanted person, generate `knowsWantedStatus`.
6.  Generate personality and behavioural values.
7.  Apply category-specific constraints.
8.  Create the session.
9.  Run the pre-dialogue decision exactly once.

Do not generate a new profile every time the officer asks a question.
The profile must remain stable for the entire session.

Example skeleton:

``` sqf
TAG_fnc_generateCivilianProfile = {
    params ["_civilian"];

    private _identityKey = _civilian getVariable [
        "TAG_identityKey",
        netId _civilian
    ];

    private _database = missionNamespace getVariable [
        "TAG_wantedDatabase",
        createHashMap
    ];

    private _isWanted = _identityKey in _database;

    private _category = if (_isWanted) then {
        "wanted"
    } else {
        if ((random 1) < 0.10) then {
            "unregistered"
        } else {
            "clean"
        };
    };

    private _knowsWanted = false;

    if (_category isEqualTo "wanted") then {
        _knowsWanted = random 1 < 0.75;
    };

    private _profile = createHashMapFromArray [
        ["identityKey", _identityKey],
        ["category", _category],
        ["knowsWantedStatus", _knowsWanted],
        ["stress", 10 + random 20],
        ["aggression", random 100],
        ["compliance", random 100],
        ["fear", random 100],
        ["personality", "default"],
        ["initialReaction", "none"],
        ["profileCreated", true]
    ];

    _profile
};
```

This is a starting point. In production, use configurable probability
tables and category-specific distributions instead of treating every
value as uniformly random.

------------------------------------------------------------------------

## 5. Pre-dialogue decision

This is a required part of the design.

Immediately after generating the profile, evaluate whether the civilian
selects an immediate reaction **before** showing the first dialogue
line.

Eligible categories:

-   A wanted civilian who knows they are wanted.
-   An unregistered active offender, if the scenario marks that profile
    as eligible.

A clean civilian or an unaware wanted civilian should not enter this
branch merely because a random number was rolled.

Recommended logical structure:

``` sqf
TAG_fnc_evaluateInitialReaction = {
    params ["_profile"];

    private _category = _profile get "category";
    private _knowsWanted = _profile get "knowsWantedStatus";

    private _eligible =
        (_category isEqualTo "unregistered")
        ||
        {
            (_category isEqualTo "wanted")
            && {_knowsWanted}
        };

    if (!_eligible) exitWith {
        "continue_dialogue"
    };

    // Use a configurable, abstract scenario probability.
    // Return a state identifier; keep movement/AI implementation elsewhere.
    if ((random 1) < 0.20) then {
        "pre_dialogue_flight"
    } else {
        "continue_dialogue"
    };
};
```

The example probability is only a placeholder. It should be adjusted
through configuration and tested in gameplay.

If the result is `pre_dialogue_flight`:

-   Set the interaction state accordingly.
-   Do not display the initial dialogue.
-   Notify the presentation layer that the encounter has changed.
-   End or suspend the dialogue session according to the mission design.

The movement or AI response should be implemented in a separate
behaviour adapter. Keep it outside the dialogue engine.

------------------------------------------------------------------------

## 6. State machine

Use named state identifiers rather than deeply nested `if` statements.

Suggested states:

  -----------------------------------------------------------------------
  State                               Meaning
  ----------------------------------- -----------------------------------
  `created`                           Session has just been created

  `pre_dialogue_check`                Initial reaction is being evaluated

  `pre_dialogue_flight`               Civilian selected an immediate
                                      flight response

  `initial_contact`                   First dialogue node is active

  `awaiting_identity`                 Officer requested identity
                                      information

  `identity_provided`                 Civilian provided identity
                                      information

  `database_check`                    Officer is checking available
                                      records

  `wanted_revealed`                   Officer has discovered a wanted
                                      record

  `cooperative`                       Civilian is cooperating

  `uncooperative`                     Civilian is refusing or delaying
                                      cooperation

  `compliant`                         Civilian has agreed to comply

  `flight`                            Abstract flight state

  `hostile_escalation`                Abstract hostile escalation state

  `ended`                             Interaction is complete
  -----------------------------------------------------------------------

### 6.1 Transition examples

``` text
created
  -> pre_dialogue_check

pre_dialogue_check
  -> pre_dialogue_flight
  -> initial_contact

initial_contact
  -> cooperative
  -> uncooperative
  -> awaiting_identity

awaiting_identity
  -> identity_provided
  -> uncooperative

identity_provided
  -> database_check

database_check
  -> wanted_revealed
  -> cooperative
  -> ended

wanted_revealed
  -> compliant
  -> flight
  -> hostile_escalation
```

The table is a conceptual starting point. The final transition list
should explicitly define which actions are allowed from each state.

### 6.2 Transition function

Create one function responsible for validating and applying state
changes.

``` sqf
TAG_fnc_setInteractionState = {
    params ["_session", "_newState"];

    if !(_session getOrDefault ["active", false]) exitWith {
        false
    };

    private _oldState = _session get "state";

    // TODO: validate _newState against the transition table.
    _session set ["previousState", _oldState];
    _session set ["state", _newState];

    true
};
```

Do not allow every dialogue function to modify session state
independently. Route transitions through this function so logging,
validation, and multiplayer synchronization remain consistent.

------------------------------------------------------------------------

## 7. Behaviour decisions and weighted randomness

Avoid independent random rolls on every dialogue line. That creates
inconsistent characters.

Instead:

-   Generate personality values once.
-   Preserve them for the session.
-   Update stress or other values after meaningful events.
-   Use the current values to select among valid responses.
-   Make each decision only once per relevant state transition.

For example, a civilian who has already agreed to cooperate should not
randomly switch to an unrelated response simply because the officer
opened the dialogue menu again.

A generic weighted-selection helper can be used for dialogue variants:

``` sqf
TAG_fnc_selectWeightedEntry = {
    params ["_entries"];

    private _total = 0;

    {
        _total = _total + (_x select 1);
    } forEach _entries;

    if (_total <= 0) exitWith {""};

    private _roll = random _total;
    private _accumulator = 0;
    private _result = "";

    {
        _accumulator = _accumulator + (_x select 1);

        if (_roll <= _accumulator) exitWith {
            _result = _x select 0;
        };
    } forEach _entries;

    _result
};
```

Example input:

``` sqf
[
    ["calm_response_01", 50],
    ["calm_response_02", 30],
    ["calm_response_03", 20]
]
```

Keep the weights in dialogue data, not scattered throughout the code.

------------------------------------------------------------------------

## 8. Vehicle-agnostic architecture

The core interaction functions should accept a civilian unit, not a
vehicle object.

Recommended separation:

``` text
PoliceInteraction
    |
    +--> Profile generation
    +--> State machine
    +--> Dialogue engine
    +--> Database access
    |
    +--> Context adapter
            |
            +--> On foot
            |
            +--> In vehicle
```

The context adapter may provide information such as:

-   Is the civilian currently in a vehicle?
-   Which vehicle is associated with the civilian?
-   Is the civilian the driver or a passenger?
-   Which presentation options make sense in this context?

The dialogue engine should not contain separate copies of every question
for pedestrians and vehicle occupants. Use shared dialogue nodes with
optional context tags.

Example:

``` sqf
private _context = createHashMapFromArray [
    ["isInVehicle", vehicle _civilian != _civilian],
    ["vehicle", vehicle _civilian],
    ["role", "unknown"]
];
```

Vehicle-specific actions should be exposed through an adapter interface.
Do not make the profile generator or dialogue selector responsible for
vehicle control.

------------------------------------------------------------------------

## 9. Dialogue system without hundreds of config classes

### 9.1 Recommended approach

Use **one reusable dialogue interface** and store dialogue content as
data.

Do not create a separate `CfgDialogs`, `RscTitles`, or UI class for
every question or answer.

Recommended layers:

1.  **Dialogue data:** node IDs, text, conditions, and available
    choices.
2.  **Dialogue engine:** checks conditions and selects the next node.
3.  **Presentation layer:** displays the current NPC line and officer
    choices.
4.  **Action layer:** executes the selected police action and requests a
    state transition.

A single reusable UI can display any number of dialogue nodes.

### 9.2 Dialogue data example

``` sqf
TAG_dialogueData = createHashMapFromArray [
    [
        "initial_greeting",
        createHashMapFromArray [
            ["speaker", "civilian"],
            ["lines", [
                "Good afternoon, officer.",
                "Hello. Can I help you?"
            ]],
            ["choices", [
                "ask_reason",
                "request_identification",
                "end_conversation"
            ]]
        ]
    ],
    [
        "ask_reason",
        createHashMapFromArray [
            ["speaker", "civilian"],
            ["lines", [
                "Is there a problem?",
                "What seems to be the issue?"
            ]],
            ["choices", [
                "explain_reason",
                "request_identification"
            ]]
        ]
    ]
];
```

The engine should select a line from the node's `lines` array and show
only choices valid for the current session.

### 9.3 Conditional dialogue entries

Use metadata rather than writing conditions into every UI definition.

Example conceptual entry:

``` sqf
[
    "wanted_status_response",
    createHashMapFromArray [
        ["requiredState", "wanted_revealed"],
        ["requiredCategory", "wanted"],
        ["speaker", "civilian"],
        ["lines", [
            "There must be some kind of mistake.",
            "I don't understand. What are you talking about?"
        ]]
    ]
]
```

The dialogue engine checks the metadata against the session. The UI only
receives the lines and choices that are currently available.

Do not expose hidden profile fields to the client merely to evaluate
dialogue conditions. In multiplayer, evaluate hidden conditions on the
server and send only the approved dialogue result.

### 9.4 Where should the dialogue UI live?

There are three practical options:

  -----------------------------------------------------------------------
  Option                  Advantages              Disadvantages
  ----------------------- ----------------------- -----------------------
  ACE interaction menu    Native to ACE, quick to Not ideal for long
                          prototype               conversations

  `systemChat` /          Very easy, no custom UI Limited presentation
  `hintSilent`            required                

  One generic custom      Full control over text  Requires one reusable
  display                 and choices             UI definition
  -----------------------------------------------------------------------

**Recommended solution: hybrid.**

-   Use ACE interactions for initiating a stop and selecting broad
    police actions.
-   Use one generic custom dialogue display for conversations.
-   Store all dialogue content in SQF data files.
-   Use `systemChat` or another lightweight presentation method during
    early prototyping.

ACE should be an interaction entry point, not the dialogue database.

### 9.5 Dynamic UI implementation

For a custom display, create one reusable display class in the UI
configuration. Create or update its controls dynamically using
`ctrlCreate` and `ctrlSetText`.

The display should contain generic elements:

-   NPC name or unknown identity label.
-   Current speaker.
-   Dialogue text.
-   A list of available response buttons.
-   Optional interaction status.

The same controls are reused for every dialogue node. When the node
changes, update the text and rebuild the available choices.

This means one UI definition can support hundreds of questions and
responses. The number of dialogue nodes should not determine the number
of UI config classes.

------------------------------------------------------------------------

## 10. ACE interactions

ACE3 is a good fit for initiating and managing broad interaction
actions.

Use the ACE interaction system to expose actions such as:

-   Initiate interaction / request stop.
-   Ask for identification.
-   Check identity in the database.
-   Check vehicle registration.
-   Continue conversation.
-   End interaction.

Register generic actions once. Their conditions should check whether the
selected target is valid and whether the officer has an active session
with that target.

Do not register a new ACE action for every dialogue sentence. Dialogue
choices belong in the dialogue UI or dialogue data.

### 10.1 ACE action registration concept

The exact ACE API and parameters should be verified against the ACE3
version used by the mod. A typical structure is:

``` sqf
[
    "TAG_PoliceRoot",
    "Police Interaction",
    "",
    {},
    {
        // Show only for a valid target and when the action is available.
        true
    }
] call ace_interact_menu_fnc_createAction;
```

Then register the action on the appropriate object type using the ACE
interaction-menu registration functions.

Keep the action callback short. It should call a mod function, for
example:

``` sqf
[_player, _target] call TAG_fnc_requestStop;
```

The callback should not contain the entire interaction algorithm.

For a vehicle, resolve the relevant unit first. The adapter decides
whether the target is the driver, a passenger, or a pedestrian.

------------------------------------------------------------------------

## 11. Event handlers and CBA event handling

Use event handlers for lifecycle events, not as a replacement for the
state machine.

Recommended responsibilities:

  -----------------------------------------------------------------------
  Mechanism                           Responsibility
  ----------------------------------- -----------------------------------
  Mission initialization              Build databases and register
                                      functions

  ACE interaction callback            Start or continue an interaction

  CBA custom event                    Communicate between system modules

  `GetInMan` / `GetOutMan`            Update vehicle context if needed

  `Killed`                            End or invalidate an active session

  `Deleted`                           Clean up references to deleted
                                      units

  `EachFrame` / scheduled loop        Avoid unless continuous monitoring
                                      is genuinely required
  -----------------------------------------------------------------------

### 11.1 Custom CBA events

Use namespaced event names:

``` sqf
["TAG_police_interactionStarted", {
    params ["_sessionId", "_officer", "_civilian"];
    // Presentation, logging, or other module notification.
}] call CBA_fnc_addEventHandler;
```

Trigger the event from the session creation function:

``` sqf
[
    "TAG_police_interactionStarted",
    [_sessionId, _officer, _civilian]
] call CBA_fnc_localEvent;
```

Use local events for same-machine communication. For multiplayer, use an
explicit server/client network design and the appropriate
remote-execution configuration. Do not assume a local CBA event
automatically synchronizes between machines.

### 11.2 Unit lifecycle cleanup

When a civilian is killed or deleted:

-   Mark the session inactive.
-   Remove the active session registry entry.
-   Close or invalidate the dialogue UI for the officer.
-   Prevent future dialogue callbacks from using the deleted unit.

Register the relevant engine event handlers once per unit, or use a
centralized unit-initialization function. Avoid adding duplicate
handlers every time an interaction starts.

------------------------------------------------------------------------

## 12. Database checks and information disclosure

The officer should not know whether a civilian is wanted before a valid
check.

Possible checks:

1.  Identity check.
2.  Vehicle registration check.
3.  Additional record check, if supported by the mission.

A successful check should update the officer's `knownFacts`, not reveal
the entire hidden profile.

Example:

``` sqf
TAG_fnc_checkWantedRecord = {
    params ["_session"];

    private _profile = _session get "profile";
    private _identityKey = _profile get "identityKey";

    private _database = missionNamespace getVariable [
        "TAG_wantedDatabase",
        createHashMap
    ];

    private _found = _identityKey in _database;

    private _knownFacts = _session get "knownFacts";

    _knownFacts set ["identityChecked", true];
    _knownFacts set ["wantedRecordFound", _found];

    if (_found) then {
        _knownFacts set [
            "wantedRecord",
            _database get _identityKey
        ];

        [_session, "wanted_revealed"] call TAG_fnc_setInteractionState;
    };

    _found
};
```

In multiplayer, perform the actual lookup on the server. Return only the
information the officer is permitted to see.

A clean result should mean only that no matching wanted record was
found. It must not reveal whether the person belongs to the hidden
`unregistered` category.

------------------------------------------------------------------------

## 13. Multiplayer authority and locality

For a multiplayer mod, use the server as the authority for:

-   Wanted database contents.
-   Profile generation.
-   Random decisions.
-   Current interaction state.
-   Database lookups.
-   Session cleanup.

The client should request an action. The server validates the request,
updates the session, and sends the appropriate result to the relevant
client.

Do not trust a client-provided category, wanted status, or random
result.

Keep AI-specific commands on the machine that owns the AI unit. If the
server does not own the unit, route the AI command to its owner using a
controlled remote-execution function.

Use `CfgRemoteExec` to whitelist only the functions that genuinely need
remote execution. Avoid unrestricted remote execution.

For a single-player prototype, the same function boundaries can be used
without the network layer. This makes later multiplayer support easier.

------------------------------------------------------------------------

## 14. Suggested file structure

``` text
tag_police/
|
+-- config.cpp
|
+-- functions/
|   +-- fn_init.sqf
|   +-- fn_buildWantedDatabase.sqf
|   |
|   +-- profile/
|   |   +-- fn_generateCivilianProfile.sqf
|   |   +-- fn_generatePersonality.sqf
|   |
|   +-- interaction/
|   |   +-- fn_requestStop.sqf
|   |   +-- fn_createSession.sqf
|   |   +-- fn_setInteractionState.sqf
|   |   +-- fn_endInteraction.sqf
|   |
|   +-- behaviour/
|   |   +-- fn_evaluateInitialReaction.sqf
|   |   +-- fn_selectResponse.sqf
|   |   +-- fn_updateStress.sqf
|   |
|   +-- dialogue/
|   |   +-- fn_loadDialogueData.sqf
|   |   +-- fn_getDialogueNode.sqf
|   |   +-- fn_selectDialogueLine.sqf
|   |   +-- fn_getAvailableChoices.sqf
|   |   +-- fn_handleDialogueChoice.sqf
|   |
|   +-- database/
|   |   +-- fn_checkIdentity.sqf
|   |   +-- fn_checkRegistration.sqf
|   |
|   +-- adapters/
|       +-- fn_getInteractionContext.sqf
|       +-- fn_handleOnFootContext.sqf
|       +-- fn_handleVehicleContext.sqf
|
+-- data/
|   +-- wantedRecords.sqf
|   +-- dialogue/
|       +-- initialContact.sqf
|       +-- identityCheck.sqf
|       +-- wantedResponses.sqf
|       +-- cleanResponses.sqf
|       +-- unregisteredResponses.sqf
|
+-- ui/
    +-- RscPoliceDialogue.hpp
```

This is a suggested layout, not a requirement to create every file
immediately. Start with a smaller prototype and split functions as the
implementation grows.

------------------------------------------------------------------------

## 15. Function registration

Use `CfgFunctions` to register SQF functions. This is a small, stable
configuration layer; it is not a dialogue configuration system.

Example:

``` cpp
class CfgFunctions
{
    class TAG
    {
        class Police
        {
            file = "\tag_police\functions";

            class init { postInit = 1; };

            class buildWantedDatabase {};

            class generateCivilianProfile {};
            class generatePersonality {};

            class requestStop {};
            class createSession {};
            class setInteractionState {};
            class endInteraction {};

            class evaluateInitialReaction {};
            class selectResponse {};
            class updateStress {};

            class loadDialogueData {};
            class getDialogueNode {};
            class selectDialogueLine {};
            class getAvailableChoices {};
            class handleDialogueChoice {};

            class checkIdentity {};
            class checkRegistration {};

            class getInteractionContext {};
            class handleOnFootContext {};
            class handleVehicleContext {};
        };
    };
};
```

The `file` path must match the actual addon folder and project layout.
Adjust the prefix to the mod's real tag.

The `postInit` function should initialize the database and register
global event handlers. Do not generate civilian profiles from
`postInit`.

------------------------------------------------------------------------

## 16. Stop request: complete entry point

The stop request is the single entry point into the dynamic interaction.

Its responsibilities:

1.  Validate the officer and civilian.
2.  Resolve the actual civilian unit if the selected target is a
    vehicle.
3.  Check whether the civilian already has an active session.
4.  Ask the server to create the profile.
5.  Create and register the session.
6.  Evaluate the pre-dialogue reaction.
7.  If the result is an immediate reaction, change state and invoke the
    appropriate behaviour adapter.
8.  Otherwise, set the initial dialogue node and open the dialogue
    presentation.

Conceptual skeleton:

``` sqf
TAG_fnc_requestStop = {
    params ["_officer", "_civilian"];

    if (isNull _officer || {isNull _civilian}) exitWith {
        false
    };

    // Resolve the actual unit before this point if the selected
    // interaction target was a vehicle.

    // In multiplayer, forward the request to the server and validate it there.
    if (!isServer) exitWith {
        [_officer, _civilian] remoteExecCall [
            "TAG_fnc_requestStopServer",
            2
        ];
        true
    };

    [_officer, _civilian] call TAG_fnc_requestStopServer
};
```

The server-side implementation should create the profile and session,
then evaluate the initial reaction. Keep the server function separate
from the client UI function.

Do not let the client create or overwrite hidden profile data.

------------------------------------------------------------------------

## 17. Dialogue flow example

The following is an example of a short, branching conversation. The
dialogue text is data, while the choices call semantic actions.

``` text
INITIAL CONTACT
    Civilian: "Good afternoon, officer. Can I help you?"

    Officer choices:
        - Explain the reason for the stop
        - Request identification
        - Ask a general question
        - End interaction

REQUEST IDENTIFICATION
    Civilian response depends on the current profile:
        - Cooperative response
        - Nervous response
        - Uncooperative response

    Officer choices:
        - Perform identity check
        - Ask why the civilian is refusing
        - Return to previous topic
        - End interaction

IDENTITY CHECK
    Server checks the wanted database.

    If a wanted record is found:
        - Reveal the permitted record information
        - Move to wanted_revealed
        - Select a response from the relevant dialogue set

    If no wanted record is found:
        - Tell the officer that no wanted record was found
        - Do not reveal the hidden unregistered category
        - Continue the interaction
```

A conversation should not be a fixed linear script. Each node should
expose only the choices valid for the current state.

------------------------------------------------------------------------

## 18. English dialogue content

Keep the initial lines short. Use multiple alternatives for the same
semantic response.

### Initial greeting --- civilian

-   "Good afternoon, officer."
-   "Hello. Can I help you?"
-   "Yes, officer? Is there a problem?"
-   "What's going on?"

### Request for identification --- officer

-   "May I see your identification, please?"
-   "Could you provide your driver's license?"
-   "I'd like to verify your identity."
-   "Do you have any identification with you?"

### Cooperative response --- civilian

-   "Sure. Just a second."
-   "Of course. Here you go."
-   "No problem, officer."
-   "Let me get that for you."

### Uncooperative response --- civilian

-   "Why do you need my ID?"
-   "Am I required to show you that?"
-   "I haven't done anything wrong."
-   "What's this all about?"

### Unaware wanted person --- after the record is revealed

-   "What? There must be some kind of mistake."
-   "I'm wanted? That can't be right."
-   "I don't understand. What are you talking about?"
-   "Wait, you're saying there's a warrant for me?"

### Compliant response --- civilian

-   "Alright, officer. I'll cooperate."
-   "Okay. I understand."
-   "I won't cause any trouble."
-   "Just tell me what you need."

These lines should be assigned to semantic dialogue nodes. Do not
hardcode a particular line into a state transition.

------------------------------------------------------------------------

## 19. Testing plan

Test the system in stages.

### Stage 1 --- Profile generation

-   Confirm wanted identities are detected from the prebuilt database.
-   Confirm non-wanted identities can become clean or unregistered.
-   Confirm awareness is generated only for wanted profiles.
-   Confirm the profile is generated once per interaction.
-   Confirm a second interaction creates a new session according to the
    intended mission rules.

### Stage 2 --- Pre-dialogue decision

-   Confirm an eligible aware wanted profile can select the pre-dialogue
    branch.
-   Confirm an eligible unregistered profile can select the pre-dialogue
    branch.
-   Confirm clean and unaware wanted profiles do not enter that branch.
-   Confirm the first dialogue is not displayed when the pre-dialogue
    branch is selected.

### Stage 3 --- State machine

-   Test every permitted transition.
-   Attempt invalid transitions and confirm they are rejected.
-   Confirm reopening the dialogue does not reroll a decision.
-   Confirm ending a session prevents further actions from changing it.

### Stage 4 --- Dialogue

-   Confirm only valid choices are displayed.
-   Confirm line variants are selected from the correct node.
-   Confirm the same node can be reused by multiple profile categories.
-   Confirm hidden profile data is not sent to the UI.

### Stage 5 --- Context adapters

-   Test a civilian on foot.
-   Test a civilian in a vehicle.
-   Test a driver and passenger separately.
-   Confirm the core profile and dialogue functions do not depend on
    vehicle context.

### Stage 6 --- Multiplayer

-   Confirm the server owns profile generation and database checks.
-   Confirm two officers cannot unintentionally create conflicting
    sessions for the same civilian.
-   Confirm only the relevant officer receives private interaction
    information.
-   Confirm unit deletion and death clean up sessions correctly.
-   Confirm AI commands execute on the machine that owns the unit.

------------------------------------------------------------------------

## 20. Recommended implementation order

Do not implement the entire system at once. Use this order:

1.  **Wanted database:** load a small set of test records during mission
    initialization.
2.  **Profile generator:** create the three categories and awareness
    flag.
3.  **Session manager:** create, store, and end interaction sessions.
4.  **Pre-dialogue decision:** implement the immediate branch before any
    dialogue is shown.
5.  **State machine:** define and validate state transitions.
6.  **Text-only dialogue prototype:** use `systemChat` or a simple
    temporary presentation.
7.  **Dialogue data engine:** load nodes and select valid choices.
8.  **ACE entry points:** register generic police actions.
9.  **Reusable dialogue UI:** implement one display and dynamically
    update its controls.
10. **Vehicle adapters:** add the on-foot and vehicle context handling.
11. **Multiplayer authority:** move hidden data and decisions to the
    server and validate remote requests.
12. **Testing and balancing:** tune probabilities and add more dialogue
    packs.

------------------------------------------------------------------------

## 21. Final architecture recommendation

The recommended combination is:

-   **SQF functions:** core logic and reusable operations.
-   **HashMaps:** civilian profiles, interaction sessions, and dialogue
    nodes.
-   **State machine:** legal interaction progression.
-   **CBA events:** communication between modules on the same machine.
-   **ACE interaction menu:** entry points and broad police actions.
-   **One reusable custom UI:** actual conversations and dynamic
    response choices.
-   **Engine event handlers:** unit lifecycle and context changes.
-   **Server-authoritative logic:** multiplayer consistency and
    protection of hidden information.

Most importantly, do not build a separate config class or script for
every possible question. Build a small dialogue engine that reads data,
checks the current session, and displays the valid next choices.

That approach makes it possible to expand the system from a few initial
interactions to hundreds of dialogue nodes without changing the
underlying architecture.
