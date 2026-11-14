class CfgVehicles {
    // Deklarujemy zdrowe klasy bazowe silnika do bezpiecznego dziedziczenia
    class ThingX;

    // --- Klasy naprawiane przez ThingX (zablokowane obiekty) ---
    #define FIX_VEHICLE(KLASA) class KLASA: ThingX { scope = 0; scopeCurator = 0; scopeArsenal = 0; displayName = ""; model = ""; };

    FIX_VEHICLE(AnimationSources)
    FIX_VEHICLE(BLK)
    //FIX_VEHICLE(B_LegStrapBag_base_F)
    //FIX_VEHICLE(B_Messenger_Base_F)
    FIX_VEHICLE(Bar)
    FIX_VEHICLE(Bump)
    FIX_VEHICLE(Bump1)
    FIX_VEHICLE(CHR)
    FIX_VEHICLE(CIV)
    FIX_VEHICLE(COP)
    //FIX_VEHICLE(C_Uniform_Scientist_01_formal_F)
    FIX_VEHICLE(Caution)
    FIX_VEHICLE(Chrome)
    FIX_VEHICLE(Chrome1)
    //FIX_VEHICLE(ContainerSupply)
    FIX_VEHICLE(Copadd)
    FIX_VEHICLE(Diffuser)
    FIX_VEHICLE(Diffuser1)
    FIX_VEHICLE(EventHandlers)
    FIX_VEHICLE(Extra)
    FIX_VEHICLE(Extra1)
    FIX_VEHICLE(Extra2)
    FIX_VEHICLE(HitBody)
    FIX_VEHICLE(HitEngine)
    FIX_VEHICLE(HitFuel)
    FIX_VEHICLE(HitGlass1)
    FIX_VEHICLE(HitGlass2)
    FIX_VEHICLE(HitGlass3)
    FIX_VEHICLE(HitGlass4)
    FIX_VEHICLE(HitGlass5)
    FIX_VEHICLE(HitGlass6)
    FIX_VEHICLE(HitLF2Wheel)
    FIX_VEHICLE(HitLFWheel)
    FIX_VEHICLE(HitPoints)
    FIX_VEHICLE(HitRF2Wheel)
    FIX_VEHICLE(HitRFWheel)
    FIX_VEHICLE(HoodA)
    FIX_VEHICLE(HoodB)
    FIX_VEHICLE(ItemCore)
    FIX_VEHICLE(ItemInfo)
    FIX_VEHICLE(LMTD)
    FIX_VEHICLE(Mirrors)
    FIX_VEHICLE(Mirrors1)
    FIX_VEHICLE(PBar2)
    FIX_VEHICLE(PBar3)
    FIX_VEHICLE(PLTN)
    FIX_VEHICLE(PRadar)
    FIX_VEHICLE(PSpoiler2)
    FIX_VEHICLE(PSpotlight)
    FIX_VEHICLE(PSpotlight2)
    FIX_VEHICLE(PStark)
    FIX_VEHICLE(PUnm)
    FIX_VEHICLE(Pbar)
    FIX_VEHICLE(Radar)
    //FIX_VEHICLE(ReammoBox)
    FIX_VEHICLE(SpotLight)
    FIX_VEHICLE(Top)
    FIX_VEHICLE(Top1)
    FIX_VEHICLE(TopLightbar)
    FIX_VEHICLE(UNM)
    FIX_VEHICLE(Unmadd)
    FIX_VEHICLE(VestItem)
    FIX_VEHICLE(bodyshell2)
    FIX_VEHICLE(nomerf)
    FIX_VEHICLE(pstroke)
    FIX_VEHICLE(rearlights_1)
    FIX_VEHICLE(rearlights_2)
    FIX_VEHICLE(spoilerR)
    FIX_VEHICLE(toplight)

    // --- Klasy naprawiane przez dziedziczenie lotnicze/piechoty (by zachować strukturę) ---
    //class EC135GNlu: Helicopter_Base_F {};
    //class EM_Police_EC635: Helicopter_Base_F {};
    //class I_Heli_light_03_unarmed_F: Helicopter_Base_F {};
    //class EM_Police_Civic: B_Soldier_base_F {};

    class Car;
    class Car_F: Car {
        class HitPoints {};
    };
    class d3s_civic_17_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_civic_17_COP: d3s_civic_17_base {
        weapons[] = {
            "d3s_airhorn_fcb_priority_300",
            "d3s_airhorn_fcb_priority2_300",
            "d3s_airhorn_fcb_priority3_300",
            "d3s_airhorn_fcb_priority4_300",
            "d3s_airhorn_fcb_priority5_300",
            "d3s_airhorn_fcb_priority6_300",
            "d3s_airhorn_fcb_priority7_300",
            "d3s_airhorn_fcb_priority8_300",
            "d3s_airhorn_fcb_priority9_300",
            "d3s_airhorn_fcb_priority10_300",
            "d3s_airhorn_fcb_priority11_300",
            "d3s_airhorn_fcb_priority12_300",
            "d3s_airhorn_fcb_priority13_300"
        };
    };
    class d3s_charger_15_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_crown_98_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_explorer_13_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_tahoe_08_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_f86_15_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_f90_18_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_fseries_15_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_raptor_17_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_savana_05_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_taurus_10_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_malibu_18_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_insurgent_gtaV_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
};
