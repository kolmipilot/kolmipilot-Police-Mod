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

Implemented explicit, server-side vehicle registration on the existing database backend. Vehicle records are stored in memory for the mission; no automatic registration or generated plates are included.

- [x] Define vehicle records with a unique internal vehicle identifier, registration plate, owner link to a person record, vehicle type/class, registration and wanted status/reason, and relevant notes.
- [x] Implement vehicle create, search, read, update, and delete through the existing database API and server handlers.
- [x] Add an Eden/Zeus module to register synchronized vehicles and assign or edit their plate, optional existing-person owner, wanted status/reason, and notes.
- [x] Allow a synchronized AI/person object to be registered and assigned as vehicle owner without manually entering a UID.
- [x] Validate plate format and uniqueness server-side, validate owner links, and keep a person's owned-vehicle list consistent when vehicle ownership, plates, or records change.
- [x] Ensure module registration runs server-side and does not automatically register every vehicle in the mission.
- [x] Add vehicle search and record views to the tablet, including lookup by plate, owner, vehicle details, and wanted/registration status.
- [ ] Verify manual registration, plate uniqueness/validation, owner links, tablet lookup, and multiplayer synchronization.

This phase provides manual, mission-maker-assigned plates and vehicle records. Automatic plate generation and encounter-based vehicle registration belong to the dynamic interaction phase.

## Phase 5 — Minimal Eden/Zeus Person Configuration

Implemented only the requested innocent/wanted registration choice. Civilian behavior, suspected status, and encounter-driven registration are intentionally deferred.

- [x] Add Eden and Zeus options to leave a person unconfigured or explicitly register them as innocent or wanted.
- [x] Apply configuration server-side to AI and player units and expose registered records to the tablet and vehicle-owner lookup.
- [x] Keep the Wanted tab limited to records explicitly marked wanted; innocent records remain outside that list.
- [x] Keep unconfigured units out of the database; no civilian behavior effects or automatic registration are implemented.
- [x] Fix the wanted-status modal layout so the toggle, reason field, and action buttons do not overlap.
- [x] Add an optional warrant-reason field to the Eden person attribute and Zeus person module.
- [x] Verify module placement/configuration in Eden and runtime behavior through Zeus in multiplayer.
- [ ] Fix overlaping windows, change warranty, add wyrok

## Phase 6 — Dynamic Police Interactions and Encounter-Based Records, Simple Implementation

- [x] Add ACE person interactions for ID, driving-license, and purpose checks; display responses and record results with ACE structured text.
- [x] Register a person on explicit interaction only when encounter registration is enabled; retrieve existing records for registered units.
- [x] Add ACE vehicle interactions for plate checks and display results with ACE structured text.
- [x] Register checked vehicles only when encounter registration is enabled and link the current driver as owner when available.
- [x] Generate a unique plate for dynamically registered vehicles while preserving existing/manual/Ivory plates.
- [x] Keep encounter requests authorized and validate stop and wanted-AI actions on the server before dispatching actions to the AI's local machine.
- [x] Add a configurable keybind and scroll-menu action to stop the nearest person or vehicle in front; play `gestureFreeze` when the officer is on foot.
- [x] Register the stopped person, or the vehicle and its driver, during the takedown when encounter registration is enabled.
- [x] Add ACE interactions to release a stopped person or vehicle.
- [x] Add a simple wanted-AI reaction: ignore the officer, flee, or change to OPFOR and attack when armed.
- [x] In Eden and multiplayer, verify the vanilla `addAction` takedown entry appears in the scroll menu on foot and from a patrol vehicle, and follows the player when entering, exiting, or respawning.
- [x] Test the maximum takedown distance settings: defaults are 20 m on foot and 100 m from a patrol vehicle; confirm targets inside the configured distance can be selected and targets beyond it cannot.
- [x] Verify takedown selects only people on foot or occupied vehicles with a person driving, never animals, empty vehicles, or vehicles with no person driver.
- [x] Verify takedown silently registers an encountered person and, for occupied vehicles, a plate and driver owner when encounter registration is enabled; confirm officers can then use ACE interactions/tablet checks and release a stopped person or vehicle.
- [x] Verify the keybind still works and that takedown itself displays no identity, plate, or stop-target information.
- [x] Verify wanted-AI reactions and Ivory/manual/generated plate behavior in Eden and multiplayer runtime tests.

## Phase 7 - radial equipment menu

- [x] Create ui / gui radial menu element
- [x] Wait for my acceptaion
- [x] Dynamically load carried primary and secondary weapons into the radial menu.
- [x] Add a configurable CBA keybind to open the radial menu
- [x] Wait for accept
- [x] Swap the equipped handgun or primary weapon with a selected carried weapon while preserving weapon state.
- [ ] Verify primary weapon switching and state preservation in-game.
- [x] Final acceptation
- [ ] Replace radial-menu text labels with user-provided equipment icons

## Phase 8 - Dynamicaly advanced civilian innocent / wanted interaction system

### Phase 1 - Create new addon named something about civilian interactions

- [ ] Move alredy ready basic interaction system from phase 6. Checking plates by ace interaction menu should stay in tablet.
- [ ] Create on yourself, or let me do it to create functions handling, getting out, attacking cops, do on yourself running away script, with random chance after some time unit will surender, or start fighting with function mentioned aboce.

### Phase 2 - Implement DynamicInteractionSystem.md

- [ ] Make functions, alghortims and other needed stuff to implement full system specifacted in `DynamicInteractionSystem.md`

## Phase 9 - Add dynamicly generated muissios

## Phase 10 - Add crowd spawning modules

## Phase 11 - Write documenatation

## Phase 12 - Create MAP

TODO phases 3, 4, and 6 split the database/tablet, vehicle-registration, and interaction work described in Specification Phase 3. TODO phase 5 covers the Eden/Zeus configuration described in Specification Phase 4; the vehicle-specific registration module is planned in phase 4 so manual registration can precede dynamic encounters.
