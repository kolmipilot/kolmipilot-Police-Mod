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
            "ivory_data"
        };
        units[] = {};
        weapons[] = {};
        VERSION_CONFIG;
        skipWhenMissingDependencies = 1;
    };
};

#include "CfgEventHandlers.hpp"

class CfgFunctions {
    class ivory {
        class vehicle {
            class takedown {
                file = "\z\kolmip\addons\carcompat\functions\fnc_empty.sqf";
            };
        };
    };
};
