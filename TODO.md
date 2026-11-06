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
 - [] only wheel on spike should brake, rest stay ok, of course when all wheels are on spikes destroy all

## Phase 2 — Secondary Weapon Selection

- [ ] Design radial or quick-selection menu for sidearms, tasers, and batons
- [ ] Implement inventory swap without item loss
- [ ] Maintain compatibility with backpack storage and weapon mods

---

## Phase 3 — Police Database & Tablet

- [ ] Define database structure and networking architecture
- [ ] Implement person & vehicle registry
- [ ] Create tablet UI and ACE interactions
