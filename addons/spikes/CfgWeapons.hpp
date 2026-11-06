class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class GVAR(spikeStrip): ACE_ItemCore {
        author = AUTHOR;
        scope = 2;
        displayName = CSTRING(SpikeStrip_DisplayName);
        descriptionShort = CSTRING(SpikeStrip_Description);
        picture = "\z\kolmip\addons\spikes\data\kolczatka.paa";
        model = "\A3\weapons_F\ammo\mag_univ.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionsTextures[] = {"\z\kolmip\addons\spikes\data\tekstura_black_co.paa"};
        hiddenSelectionsMaterials[] = {"\z\kolmip\addons\spikes\data\tekstura_black.rvmat"};
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 40;
        };
    };
};
