# Tasks & Development Progress

## Phase 1 — Spike Strips (`spikes` component)

- [x] **Create `spikes` addon structure**
  - [x] Follow `extras/blank` template with `$PBOPREFIX$`, `script_component.hpp`, `CfgEventHandlers.hpp`, `config.cpp`
  - [x] Create `addons/spikes/data/` folder for assets (`kolczatki.p3d`, `tekstura_black_co.png`, `tekstura_black.rvmat`)
  - [x] Add English and Polish localizations in `stringtable.xml`
- [x] **Configure spike strip classes**
  - [x] Inventory item `kolmip_spikes_spikeStrip` in `CfgWeapons` (`ItemCore` / `CBA_MiscItem_ItemInfo`)
  - [x] Ground weapon holder `kolmip_spikes_spikeStripItem` in `CfgVehicles` (`Item_Base_F`)
  - [x] Deployed world object `kolmip_spikes_spikeStripDeployed` in `CfgVehicles` (`ThingX`) referencing `kolczatki.p3d` and materials
- [x] **Deployment mechanisms**
  - [x] ACE self-interaction under `["ACE_SelfActions", "ACE_Equipment"]`
  - [x] Persistent scroll action menu via `CBA_fnc_addPlayerAction`
  - [x] Configurable CBA keybinding (default: `Ctrl + K`) under mod controls
- [x] **Retrieval / Pickup mechanisms**
  - [x] ACE interaction on deployed spike strip (`["ACE_MainActions"]`)
  - [x] Scroll action menu on deployed spike strip
  - [x] Safe inventory return / ground drop fallback and server cleanup
- [x] **Vehicle detection & Wheel puncturing**
  - [x] Server-authoritative monitoring PFH for vehicle collision detection
  - [x] Zero-latency local client driver PFH for instant puncture reaction
  - [x] Universal wheel hitpoint detection across vanilla and modded vehicles via `getAllHitPointsDamage`
- [x] **CBA Settings**
  - [x] `kolmip_spikes_enableSpikes` (Enable/disable system)
  - [x] `kolmip_spikes_reusableAfterHit` (Configurable reusability after hit)
  - [x] `kolmip_spikes_punctureAllWheels` (All wheels vs front/random wheels)
- [x] **Asset verification & In-game testing**
  - [x] Place `kolczatki.p3d`, `tekstura_black_co.paa`, and `tekstura_black.rvmat` into `addons/spikes/data/` (user asset step)
  - [x] Verify in-game visual model placement and wheel popping in dedicated MP environment
- [x] **fixes**
  - [x] change `tekstura_black_co.png` to `tekstura_black_co.paa` in config definitions
  - [x] fix stringtables to use `<Project name="KOLMIP">` and standard `STR_KOLMIP_{Component}_{Key}` IDs (passes `python tools/stringtable_validator.py`)
  - [x] remove duplicate ACE action from `CfgVehicles.hpp` so retrieve spike strip action appears only once in ACE interaction menu

---

## Phase 1 - fix
 - [x] only wheel on spike should brake, rest stay ok, of course when all wheels are on spikes destroy all

---

## Phase 2 — Secondary Weapon Selection

- [ ] Design a radial or other intuitive quick-selection menu for the sidearm, taser, and police baton, without opening the inventory.
- [ ] Support equipment stored in the player's backpack and prevent unintended item or weapon loss during switching.
- [ ] Maintain multiplayer compatibility and compatibility with other weapon-related mods where reasonably possible.

---

## Phase 3 — Police Database and Tablet

- [x] Create new addon named database, it will work as backend. backend working on server. database should be table or few tables connected in the future, i think in mission namespace. to prevent lags on network traffic, database should be only in full form on server, and clients should have acces to eventhandlers to search, add delete. you know like in mysql with php.
  - [x] Created `database` component using `$PBOPREFIX$`, `script_component.hpp`, `CfgEventHandlers.hpp`, `config.cpp`, `stringtable.xml`
  - [x] Initialized server-side database storage in `missionNamespace` (`GVAR(tables)`) with modular table support (`persons`, `vehicles`)
  - [x] Server-authoritative CRUD functions (`fnc_createTableServer`, `fnc_getTableServer`, `fnc_setRecordServer`, `fnc_getRecordServer`, `fnc_deleteRecordServer`, `fnc_queryServer`)
  - [x] CBA Settings (`QGVAR(debug)` for RPT logging, `QGVAR(maxSearchResults)` slider)
- [x] Define database structure and networking architecture
  - [x] Server event handlers for remote queries (`QGVAR(queryServer)`), gets (`QGVAR(getRecordServer)`), saves (`QGVAR(saveRecordServer)`), and deletes (`QGVAR(deleteRecordServer)`)
  - [x] Client asynchronous request tracking (`fnc_sendRequest`, `fnc_handleResponse`) with client response events via `CBA_fnc_targetEvent`
  - [x] Client-facing async API functions (`fnc_query`, `fnc_getRecord`, `fnc_saveRecord`, `fnc_deleteRecord`) with immediate fallback for local server/SP execution
  - [x] Global notification event `QGVAR(recordChanged)` on record insertion/update/deletion
- [x] Implement person registry structure
  - [x] Standard person record schema (`id`, `firstName`, `lastName`, `fullName`, `isPlayer`, `uid`, `face`, `speaker`, `isPolice`, `isWanted`, `wantedReason`, `drivingLicense`, `gunLicense`, `criminalRecord`, `vehicles`, `notes`, `netId`)
  - [x] Extract identity and populate records from in-game units (`fnc_createPersonData`, `fnc_createPersonFromUnit`)
  - [x] On-demand unit registration (`fnc_registerUnit`) with global unit tracking variable (`QGVAR(personId)`)
  - [x] Query, search, and update functions (`fnc_getPerson`, `fnc_getPersonByUnit`, `fnc_searchPersons`, `fnc_savePerson`, `fnc_deletePerson`, `fnc_addCrime`, `fnc_setWantedStatus`)

### Police Tablet UI

- [x] Create a separate `tablet` addon for the police tablet item and its user interface; keep database storage and operations in the `database` addon.
- [ ] Restrict tablet functionality and database requests/updates to server-authorized police officers; the server now stores police assignments privately, but requester verification still relies on client-supplied CBA server-event fields and needs secure sender validation.
- [x] Add a person search and record view using the existing asynchronous database API; request and synchronize only the data needed by the UI.
- [x] Provide a wanted-persons view and allow officers to search by available identity information.
- [x] Allow authorized officers to add and edit roleplay information, notes, license status, wanted status, and criminal or violation history for already registered persons.
- [x] Provide clear loading, empty, and error states for asynchronous searches and saves.
- [ ] Verify tablet access, search, and person-record updates in single-player and dedicated multiplayer, including authorized clients joining mid-mission without receiving the full database.

Do not automatically register unconfigured units in this phase. Tablet edits apply to existing person records; mission-maker registration and encounter-based registration are handled in later phases.

### Tablet v2

- [x] Add an Eden Editor unit checkbox for police status; the server maintains the authorization list.
- [x] Point the inventory and ACE action icons to `addons/tablet/data/tablet_icon_ca.paa`.
- [x] Add the custom icon asset at `addons/tablet/data/tablet_icon_ca.paa` (user-provided PAA).
- [x] Fix the reported tablet UI callback parsing errors and missing control configuration fields from the Arma RPT. The diagnostic excerpt below is retained as historical context.
- [ ] Make sure everthing will work in multiplayer therotical code check
- [ ] Make sure evertyhing works in multiplaeyr dedicated server in practice

## Phase 4 — Vehicle Database and Manual Registration

The database addon already initializes a generic `vehicles` table, but the completed TODO work does not yet define a vehicle-specific record schema, registration flow, or vehicle search API. Build on the existing database backend rather than duplicating it.

- [ ] Define vehicle records with a unique internal vehicle identifier, registration plate, owner link to a person record, vehicle type/class, registration and wanted status/reason, and relevant notes.
- [ ] Implement server-authoritative vehicle create, search, read, update, and delete operations using the existing database API and networking patterns.
- [ ] Add an Eden/Zeus module to explicitly register a placed vehicle and manually assign or edit its registration plate and owner; support linking to an existing registered person.
- [ ] Validate plate format and uniqueness server-side, validate owner links, and keep a person's owned-vehicle list consistent with the vehicle record.
- [ ] Ensure Eden/Zeus module changes are synchronized by the server and do not automatically register every vehicle in the mission.
- [ ] Add vehicle search and record views to the tablet, including lookup by plate, owner, vehicle details, and wanted/registration status.
- [ ] Verify manual registration, plate uniqueness/validation, owner links, tablet lookup, and multiplayer synchronization.

This phase provides manual, mission-maker-assigned plates and vehicle records. Automatic plate generation and encounter-based vehicle registration belong to the dynamic interaction phase.

## Phase 5 — Eden Editor and Zeus Person Configuration

- [ ] Add Eden Editor and Zeus modules for mission makers to designate police officers and configure police authorization.
- [ ] Add module options for configuring civilian identity/behavior (including innocent, suspected, and wanted states) and explicitly selecting units for database registration.
- [ ] Apply module configuration consistently to AI and player units where supported; enforce police authorization server-side.
- [ ] Register explicitly configured units without requiring a player interaction, and make their person records available to the tablet and vehicle-owner lookup.
- [ ] Ensure unconfigured units are not registered automatically and module configuration does not create unnecessary database or network work.
- [ ] Verify module placement/configuration in Eden and runtime behavior through Zeus in multiplayer.

## Phase 6 — Dynamic Police Interactions and Encounter-Based Records

- [ ] Implement police interactions with civilians on foot and in vehicles, including stopping, inspection, and identity/badge presentation as specified.
- [ ] Support initiating conversations or inspections and retrieving or presenting the relevant identity/badge information.
- [ ] On first eligible encounter, register the unit only when the configured registration rules allow it; retrieve existing records for already registered units.
- [ ] Add configurable civilian behavior types and randomized behavior/dialogue, including cooperative, uncooperative, fleeing, and hostile cases.
- [ ] Add ACE interactions on vehicles and suitable ACE self-interactions to check nearby vehicles on foot and vehicles ahead of or behind the officer's vehicle when checking from inside a vehicle; show results as ACE structured text, not hints.
- [ ] Allow officers to check the assigned plate, registration, owner, and wanted status during vehicle interactions.
- [ ] Support encounter-based vehicle registration when allowed by mission configuration, linking the vehicle to its owner or assigned identity.
- [ ] Generate a unique plate when a vehicle is first registered dynamically, while preserving manually assigned plates and preventing collisions.
- [ ] Keep networked interactions and database changes server-authoritative, multiplayer-safe, and limited to the data required by participants.
- [ ] Verify registration rules, interaction outcomes, generated/manual plate handling, vehicle checks, and synchronization in a dedicated multiplayer environment.

TODO phases 3, 4, and 6 split the database/tablet, vehicle-registration, and interaction work described in Specification Phase 3. TODO phase 5 covers the Eden/Zeus configuration described in Specification Phase 4; the vehicle-specific registration module is planned in phase 4 so manual registration can precede dynamic encounters.
