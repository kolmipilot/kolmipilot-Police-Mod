# Police Mod — Project Specification

## 1. Project Overview

**Police Mod** is a multiplayer-compatible police roleplay framework for Arma 3.

The goal of the project is to provide interconnected systems that allow players to create and participate in police roleplay scenarios without requiring extensive mission-specific scripting.

The mod should provide police equipment, interactions, civilian behavior, vehicle identification, police records and configurable gameplay systems.

It is intended to work as a flexible police sandbox that mission makers can adapt to different scenarios and playstyles.

The project depends on:

- [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057)
- [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997)

## 2. Design Goals

- **Modular architecture:** Features should be independent where possible.
- **Multiplayer compatibility:** All gameplay systems must work correctly in multiplayer.
- **Performance:** Systems should have minimal impact on mission performance.
- **Mission maker flexibility:** Eden Editor and Zeus should provide configuration options.
- **ACE3 integration:** Use ACE interactions and other ACE3 systems where appropriate.
- **Accessibility:** Equipment and actions should be accessible through intuitive interactions, keybinds and UI.
- **Extensibility:** The architecture should support future features without major rewrites.

## 3. Reference Mods

The following mods serve as soft dependecies.

- [X26 Taser](https://steamcommunity.com/workshop/filedetails/?id=2515852876)
- [Less Lethal Shotgun](https://steamcommunity.com/sharedfiles/filedetails/?id=3490780581)
- [CQB Interactions](https://steamcommunity.com/sharedfiles/filedetails/?id=3335065609)
- [Improved Melee System](https://steamcommunity.com/workshop/filedetails/?id=2291129343)

These projects are supported but not required.

## 4. Planned Features and Development Priorities

### Phase 1 — Spike Strips

Implement deployable spike strips as an inventory item.

Requirements:

- Spike strips should be carried in a backpack or inventory.
- Players should be able to deploy and retrieve them as world objects.
- Deployment should be accessible through ACE self-interaction, the scroll action menu or a dedicated keybind.
- Deployed spike strips must be usable by other players in multiplayer.
- Handle placement, removal and cleanup of deployed objects.
- Handle triggers or other method of destroying wheels/tires of cars.

### Phase 2 — Secondary Weapon Selection

Implement a system for quickly changing the player's secondary weapon without opening the inventory.

Planned equipment:

- Standard sidearm.
- Taser.
- Police baton.

Requirements:

- Preferably provide a dedicated ui radial selection menu.
- Allow switching between available secondary equipment without opening the inventory.
- Support equipment stored in the player's backpack.
- If a radial menu is not technically feasible, use another intuitive interaction method.
- Switching must not cause unintended equipment loss.
- Maintain compatibility with multiplayer and other weapon-related mods where reasonably possible.

### Phase 3 — Police Database and Tablet

Implement a police database accessible through an inventory tablet item.

The tablet should provide a central interface for accessing information about registered civilians, players and vehicles.

#### 3.1. Database Records

The database should support records for AI civilians and human players.

Possible person record fields:

- First name.
- Last name.
- arma / ace identity information, where available.
- Face identification, if technically possible.
- Criminal and violation history.
- Police officer status.
- Suspect or wanted status.
- Additional roleplay information.
- owned cars, gun license, driving license

#### 3.2. Database Architecture

The database should use `missionNamespace` as its primary storage mechanism.

- The server should be authoritative and maintain the actual database state.
- Clients should receive only the data necessary for their interactions and UI.
- Synchronize database changes rather than repeatedly transmitting the entire database.
- Use targeted network updates where possible.
- Handle joining players and database synchronization appropriately.
- Avoid unnecessary network traffic to minimize lag and desynchronization.

The implementation should prioritize server-side authority and efficient synchronization.

#### 3.3. Civilian Interactions

Players should be able to interact with civilians and initiate police encounters.

The system should support:

- Stopping civilians walking on foot.
- Stopping civilians travelling in vehicles.
- Initiating conversations or inspections.
- Showing id, or police badge.
- Creating a database record when an eligible civilian is first interacted with.
- Retrieving existing records when interacting with registered units.

AI civilians should have configurable behavior and randomized dialogue.

Possible behavior types:

- Cooperative and innocent.
- Uncooperative but non-hostile.
- Suspected criminal attempting to escape.
- Hostile criminal who may attack the player.
- Other configurable behavior types.

Behavior should be selected according to mission configuration and randomized where appropriate.

Not every civilian should automatically become a database entry.

Only civilians configured by the mission maker or civilians encountered through player interaction should be registered to prevent lags.

#### 3.4. Vehicle Registration and License Plate Checks

Arma 3 does not provide a conventional license plate system suitable for this mechanic.

Police Mod should implement its own vehicle identification system.

Requirements:

- Vehicles should be associated with their owners or assigned identities.
- Vehicles should have unique identifiers that function as license plates.
- Players should be able to check vehicle information through ACE interactions or the action menu.
- Vehicle information should be accessible through the police tablet.
- Vehicles may be marked as wanted or associated with suspicious activity.
- The database should allow officers to search for vehicles and check their registration status.
- To check tables, person can do it by ace interaction on the car, or ace self-ionterzction to check closest car from the fornt, or closest car from the fornt or from the back if the player is in the vehicle.
- Interaction should not use hint, but ace structured text.

Support both AI-owned vehicles and vehicles associated with human players.

#### 3.5. Police Tablet Interface

The tablet should act as the main interface for police database functionality.

Planned sections:

- Person search.
- Person records.
- Criminal and violation history.
- Wanted persons.
- Vehicle search.
- Vehicle registration.
- Wanted vehicles.
- Additional police tools in the future.

Access to the tablet should be restricted to authorized police officers.

### Phase 4 — Eden Editor and Zeus Configuration

Implement configuration modules that allow mission makers to control Police Mod functionality.

#### 4.1. Police Officer Assignment

Mission makers should be able to designate AI units and players as police officers.

Requirements:

- Provide a module for assigning police officer status.
- Support synchronization with AI units and player units.
- Authorized officers should gain access to the police tablet and police-only functionality.
- Unauthorized players should not gain access simply by obtaining or stealing a tablet.

Police authorization must be validated by the system, not determined only by possession of an inventory item.

#### 4.2. Civilian and Criminal Configuration

Provide a module for assigning civilian behavior and identity settings.

Mission makers should be able to configure AI civilians and players as:

- Innocent civilians.
- Suspected criminals.
- Wanted criminals.
- Other supported behavior types.

Allow mission makers to define which units are registered in the database and how they behave during police interactions.

#### 4.3. Registration Rules

The database should not automatically register every AI unit in the mission.

Registration should happen only when:

- A unit has been explicitly configured through a module.
- A player initiates an interaction that requires the unit to be registered.

This should prevent unnecessary database entries and reduce performance overhead.

## 5. Future Features

The following features are potential future additions and are not required for the initial release.

### 5.1. Police Vehicle Systems

- Configurable vehicle radios.
- Scripted police sirens rather than relying exclusively on vehicle models.
- Automatic trunk contents depending on the police vehicle type.
- Additional police vehicle equipment and interactions.

### 5.2. Arrest and Detention Systems

- Police arrest functionality.
- Configurable detention facilities.
- Jail and prisoner management.
- Integration with existing ACE3 restraint and interaction systems.

### 5.3. Random Mission Generator

Implement a system that generates randomized civilian incidents and criminal activities.

Possible events:

- Fights and disturbances.
- Shootings.
- Vehicle and property thefts.
- Drug dealing.
- Suspicious activity.
- Other randomized police incidents.

Requirements:

- Generate incidents dynamically during missions.
- Allow mission makers to configure available incident types and their frequency.
- Support different outcomes depending on civilian behavior and player intervention.
- Integrate with the police database and civilian systems where appropriate.
- Support multiplayer synchronization.

### 5.4. Economy and Additional Items

Future gameplay systems may introduce additional items and resources required for the sandbox.

Examples:

- Money and cash.
- Drugs and contraband.
- Additional illegal goods.
- Evidence and other police-related items.

These items should integrate with the inventory, civilian behavior, random mission generator and police database systems where appropriate.

### 5.5. Extended Police Database

- More detailed criminal records.
- Additional vehicle information.
- Search history.
- More advanced identity and evidence systems.
- Additional police tools.

## 6. Technical Requirements

### 6.1. Multiplayer Compatibility

Multiplayer support is a core requirement.

- All features must work in dedicated server environments.
- Networked interactions must be synchronized correctly.
- Locality must be handled properly for AI units and vehicles.
- Database changes must remain consistent across clients.
- Police authorization must be validated server-side where necessary.
- Clients must not be able to grant themselves unauthorized permissions.

### 6.2. Performance

Performance should be considered throughout development.

- Ensure correct fucntion, methods, event handler calling on server, client, global, jip.
- Avoid unnecessary permanent loops.
- Avoid repeatedly scanning all mission units and vehicles.
- Prefer event-driven systems where possible.
- Register only relevant units and vehicles.
- Use efficient data structures for database records.
- Avoid unnecessary network traffic.
- Synchronize only required data and changes.
- Ensure UI and interaction systems do not create excessive background processing.

### 6.3. Framework Architecture

Police Mod should be developed as a modular framework.

- Individual features should be separated into logical components.
- Shared systems should be reusable by multiple features.
- Features should communicate through clearly defined interfaces.
- Configuration should be centralized where appropriate.
- New features should be possible without rewriting existing systems.
- External dependencies should be used through their intended APIs.

ACE3 and CBA should be treated as framework dependencies, not copied or reimplemented inside Police Mod.

## 7. Development Scope

The initial development focus should be on establishing the core framework and implementing the planned features in priority order.

The project should not attempt to implement every possible police roleplay mechanic immediately.

Each feature should be implemented, tested and validated independently before being integrated with other systems.

Future features should extend the existing architecture rather than introduce isolated implementations that duplicate existing functionality.

## 8. General Project Direction

Police Mod is intended to become a flexible police roleplay sandbox for Arma 3.

It should provide mission makers and players with tools to create their own police scenarios, civilian encounters, criminal activities and law enforcement gameplay.

The long-term goal is not simply to add police equipment, but to provide an interconnected framework in which equipment, interactions, identities, vehicles, records, AI behavior, random incidents and additional gameplay systems work together.
