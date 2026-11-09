class CfgFactionClasses {
    class kolmip {
        displayName = CSTRING(Modules_Category);
        side = 7;
        priority = 2;
    };
};

class CfgVehicles {
    class Item_Base_F;
    class Logic;
    class Module_F: Logic {
        class ModuleDescription;
    };

    class GVAR(policeTabletItem): Item_Base_F {
        scope = 2;
        scopeCurator = 2;
        displayName = CSTRING(PoliceTablet_DisplayName);
        author = AUTHOR;
        vehicleClass = "Items";
        editorCategory = "EdCat_Equipment";
        editorSubcategory = "EdSubcat_InventoryItems";
        class TransportItems {
            class GVAR(policeTablet) {
                name = QGVAR(policeTablet);
                count = 1;
            };
        };
    };

    class GVAR(moduleRegisterVehicle): Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = CSTRING(Module_RegisterVehicle);
        category = "kolmip";
        function = QFUNC(moduleRegisterVehicle);
        isGlobal = 1;
        isTriggerActivated = 1;
        class Arguments {
            class Plate {
                displayName = CSTRING(Module_VehiclePlate);
                description = CSTRING(Module_VehiclePlate_Description);
                typeName = "STRING";
                defaultValue = "";
            };
            class OwnerId {
                displayName = CSTRING(Module_VehicleOwner);
                description = CSTRING(Module_VehicleOwner_Description);
                typeName = "STRING";
                defaultValue = "";
            };
            class IsWanted {
                displayName = CSTRING(Module_VehicleWanted);
                description = CSTRING(Module_VehicleWanted_Description);
                typeName = "BOOL";
                defaultValue = 0;
            };
            class WantedReason {
                displayName = CSTRING(Module_VehicleWantedReason);
                typeName = "STRING";
                defaultValue = "";
            };
            class Notes {
                displayName = CSTRING(Module_VehicleNotes);
                typeName = "STRING";
                defaultValue = "";
            };
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(Module_RegisterVehicle_Description);
            sync[] = {"AnyVehicle", "AnyPerson"};
        };
    };

    class GVAR(moduleConfigurePerson): Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = CSTRING(Module_ConfigurePerson);
        category = "kolmip";
        function = QFUNC(moduleConfigurePerson);
        isGlobal = 1;
        isTriggerActivated = 1;
        class Arguments {
            class Status {
                displayName = CSTRING(Eden_PersonStatus_DisplayName);
                typeName = "NUMBER";
                defaultValue = 0;
                class values {
                    class NotConfigured {
                        name = CSTRING(Eden_PersonStatus_NotConfigured);
                        value = 0;
                    };
                    class Innocent {
                        name = CSTRING(Eden_PersonStatus_Innocent);
                        value = 1;
                    };
                    class Wanted {
                        name = CSTRING(Eden_PersonStatus_Wanted);
                        value = 2;
                    };
                };
            };
            class WantedReason {
                displayName = CSTRING(Eden_WantedReason_DisplayName);
                description = CSTRING(Eden_WantedReason_Description);
                typeName = "STRING";
                defaultValue = "";
            };
        };
        class ModuleDescription: ModuleDescription {
            description = CSTRING(Module_ConfigurePerson_Description);
            sync[] = {"AnyPerson"};
        };
    };
};
