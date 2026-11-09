class CfgVehicles {
    class Item_Base_F;

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
};
