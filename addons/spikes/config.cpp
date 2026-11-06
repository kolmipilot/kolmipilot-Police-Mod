#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        author = AUTHOR;
        authors[] = {"kolmipilot"};
        url = ECSTRING(Main,Url);
        name = COMPONENT_NAME;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "kolmip_main",
            "cba_xeh",
            "cba_keybinding",
            "cba_settings",
            "cba_events",
            "ace_interact_menu"
        };
        units[] = {
            QGVAR(spikeStripItem),
            QGVAR(spikeStripDeployed)
        };
        weapons[] = {
            QGVAR(spikeStrip)
        };
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
