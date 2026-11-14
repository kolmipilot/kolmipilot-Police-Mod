class CfgWeapons {
    class ItemCore;

    #define FIX_WEAPON(KLASA) class KLASA: ItemCore { scope = 2; type = 0; displayName = ""; model = ""; };

    FIX_WEAPON(GunParticles)
    FIX_WEAPON(ItemInfo)
    //FIX_WEAPON(H_HelmetHBK_base_F)
    //FIX_WEAPON(H_HelmetHBK_chops_base_F)
    //FIX_WEAPON(H_HelmetHBK_ear_base_F)
    //FIX_WEAPON(H_HelmetHBK_headset_base_F)
    //FIX_WEAPON(H_PASGT_neckprot_base_F)
    //FIX_WEAPON(V_DeckCrew_brown_F)
    //FIX_WEAPON(V_EOD_base_F)
};
