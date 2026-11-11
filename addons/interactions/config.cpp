#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        author = AUTHOR;
        authors[] = {"kolmipilot"};
        url = ECSTRING(Main,Url);
        name = COMPONENT_NAME;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "kolmip_main"
        };
        units[] = {};
        weapons[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

class CfgVehicles{
    class Man;
    class CAManBase: Man {};
    class Civilian: CAManBase {
        class HitFace {
                armor = 1;
                explosionShielding = 0.1;
                material = -1;
                minimalHit = 0.01;
                name = "face_hub";
                passThrough = 0.8;
                radius = 0.08;
            };
        class HitNeck: HitFace {
                armor = 4;
                explosionShielding = 0.5;
                material = -1;
                minimalHit = 0.01;
                name = "neck";
                passThrough = 0.8;
                radius = 0.1;
            };
        class HitHead: HitNeck {
                armor = 1;
                depends = "HitFace max HitNeck";
                explosionShielding = 0.5;
                material = -1;
                minimalHit = 0.01;
                name = "head";
                passThrough = 0.8;
                radius = 0.2;
            };
        class HitPoints {
            class HitPelvis: HitHead {
                armor = 6;
                depends = "0";
                explosionShielding = 1;
                material = -1;
                minimalHit = 0.01;
                name = "pelvis";
                passThrough = 0.33;
                radius = 0.24;
                visual = "injury_body";
            };
            class HitAbdomen: HitPelvis {
                armor = 6;
                depends = "0";
                explosionShielding = 1;
                material = -1;
                minimalHit = 0.01;
                name = "spine1";
                passThrough = 0.33;
                radius = 0.16;
                visual = "injury_body";
            };
            class HitDiaphragm: HitAbdomen {
                armor = 6;
                depends = "0";
                explosionShielding = 1.5;
                material = -1;
                minimalHit = 0.01;
                name = "spine2";
                passThrough = 0.33;
                radius = 0.18;
                visual = "injury_body";
            };
            class HitChest: HitDiaphragm {
                armor = 6;
                depends = "0";
                explosionShielding = 1.5;
                material = -1;
                minimalHit = 0.01;
                name = "spine3";
                passThrough = 0.33;
                radius = 0.18;
                visual = "injury_body";
            };
            class HitBody: HitChest {
                armor = 1000;
                depends = "HitPelvis max HitAbdomen max HitDiaphragm max HitChest";
                explosionShielding = 1.5;
                material = -1;
                minimalHit = 0.01;
                name = "body";
                passThrough = 1;
                radius = 0;
                visual = "injury_body";
            };
            class HitArms: HitBody {
                armor = 6;
                depends = "0";
                explosionShielding = 0.3;
                material = -1;
                minimalHit = 0.01;
                name = "arms";
                passThrough = 0.9;
                radius = 0.1;
                visual = "injury_hands";
            };
            class HitHands: HitArms {
                armor = 6;
                depends = "HitArms";
                explosionShielding = 0.3;
                material = -1;
                minimalHit = 0.01;
                name = "hands";
                passThrough = 0.9;
                radius = 0.1;
                visual = "injury_hands";
            };
            class HitLeftArm: HitHands {
                armor = 6;
                depends = "HitArms";
                explosionShielding = 0.3;
                material = -1;
                minimalHit = 0.01;
                name = "hand_l";
                passThrough = 0.9;
                radius = 0.08;
                visual = "injury_hands";
            };
            class HitLegs: HitHands {
                armor = 6;
                depends = "0";
                explosionShielding = 0.3;
                material = -1;
                minimalHit = 0.01;
                name = "legs";
                passThrough = 0.9;
                radius = 0.14;
                visual = "injury_legs";
            };
            class HitLeftLeg: HitLegs {
                armor = 6;
                depends = "0";
                explosionShielding = 0.3;
                material = -1;
                minimalHit = 0.01;
                name = "leg_l";
                passThrough = 0.9;
                radius = 0.1;
                visual = "injury_legs";
            };
            class HitRightArm: HitLeftArm {
                armor = 6;
                depends = "HitArms";
                explosionShielding = 0.3;
                material = -1;
                minimalHit = 0.01;
                name = "hand_r";
                passThrough = 0.9;
                radius = 0.08;
                visual = "injury_hands";
            };
            class HitRightLeg: HitLeftLeg {
                armor = 6;
                depends = "0";
                explosionShielding = 0.3;
                material = -1;
                minimalHit = 0.01;
                name = "leg_r";
                passThrough = 0.9;
                radius = 0.1;
                visual = "injury_legs";
            };
            class Incapacitated: HitLegs {
                armor = 1000;
                depends = "(((Total - 0.25) max 0) + ((HitHead - 0.25) max 0) + ((HitBody - 0.25) max 0)) * 2";
                explosionShielding = 1;
                material = -1;
                minimalHit = 0;
                name = "body";
                passThrough = 1;
                radius = 0;
                visual = "";
            };
        };
    };
};
