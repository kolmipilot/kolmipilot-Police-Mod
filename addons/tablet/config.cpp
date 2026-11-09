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
            "kolmip_common",
            "kolmip_database",
            "cba_xeh",
            "cba_keybinding",
            "cba_settings",
            "cba_events",
            "ace_interact_menu"
        };
        units[] = {
            QGVAR(policeTabletItem)
        };
        weapons[] = {
            QGVAR(policeTablet)
        };
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "Cfg3DEN.hpp"
#include "CfgWeapons.hpp"
#include "CfgVehicles.hpp"
#include "UI\dialog.hpp"
