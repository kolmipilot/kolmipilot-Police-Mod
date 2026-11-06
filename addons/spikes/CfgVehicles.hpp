class CfgVehicles {
    class Item_Base_F;
    class ThingX;

    class GVAR(spikeStripItem): Item_Base_F {
        scope = 2;
        scopeCurator = 2;
        displayName = CSTRING(SpikeStrip_DisplayName);
        author = AUTHOR;
        vehicleClass = "Items";
        editorCategory = "EdCat_Equipment";
        editorSubcategory = "EdSubcat_InventoryItems";
        class TransportItems {
            class GVAR(spikeStrip) {
                name = QGVAR(spikeStrip);
                count = 1;
            };
        };
    };

    class GVAR(spikeStripDeployed): ThingX {
        author = AUTHOR;
        scope = 2;
        scopeCurator = 2;
        displayName = CSTRING(SpikeStripDeployed_DisplayName);
        model = "\z\kolmip\addons\spikes\data\kolczatki.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionsTextures[] = {"\z\kolmip\addons\spikes\data\tekstura_black_co.paa"};
        hiddenSelectionsMaterials[] = {"\z\kolmip\addons\spikes\data\tekstura_black.rvmat"};
        icon = "iconObject_circle";
        destrType = "DestructNo";
        mapSize = 2;
        cost = 0;
        accuracy = 0.2;
        editorCategory = "EdCat_Things";
        editorSubcategory = "EdSubcat_Default";
    };

    class kolmip_spike_strip: GVAR(spikeStripDeployed) {
        scope = 1;
        scopeCurator = 0;
    };
};
