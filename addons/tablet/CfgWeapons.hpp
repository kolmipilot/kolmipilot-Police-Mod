class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class GVAR(policeTablet): ACE_ItemCore {
        author = AUTHOR;
        scope = 2;
        displayName = CSTRING(PoliceTablet_DisplayName);
        descriptionShort = CSTRING(PoliceTablet_Description);
        picture = "\z\kolmip\addons\tablet\data\tablet_icon_ca.paa";
        model = "\A3\weapons_F\ammo\mag_univ.p3d";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 15;
        };
    };
};
