#include "defineRes.hpp"

#define RADIAL_SLOT_W QUOTE(0.16 * safezoneH * safezoneH / safezoneW)
#define RADIAL_SLOT_H QUOTE(0.07 * safezoneH)

#define RADIAL_SLOT_01_X QUOTE(safezoneX + (safezoneW - 0.52 * safezoneH * safezoneH / safezoneW) / 2 + 0.18 * safezoneH * safezoneH / safezoneW)
#define RADIAL_SLOT_01_Y QUOTE(safezoneY + (safezoneH - 0.52 * safezoneH) / 2 + 0.02 * safezoneH)
#define RADIAL_SLOT_02_X QUOTE(safezoneX + (safezoneW - 0.52 * safezoneH * safezoneH / safezoneW) / 2 + 0.34 * safezoneH * safezoneH / safezoneW)
#define RADIAL_SLOT_02_Y QUOTE(safezoneY + (safezoneH - 0.52 * safezoneH) / 2 + 0.095 * safezoneH)
#define RADIAL_SLOT_03_X QUOTE(safezoneX + (safezoneW - 0.52 * safezoneH * safezoneH / safezoneW) / 2 + 0.35 * safezoneH * safezoneH / safezoneW)
#define RADIAL_SLOT_03_Y QUOTE(safezoneY + (safezoneH - 0.52 * safezoneH) / 2 + 0.22 * safezoneH)
#define RADIAL_SLOT_04_X QUOTE(safezoneX + (safezoneW - 0.52 * safezoneH * safezoneH / safezoneW) / 2 + 0.34 * safezoneH * safezoneH / safezoneW)
#define RADIAL_SLOT_04_Y QUOTE(safezoneY + (safezoneH - 0.52 * safezoneH) / 2 + 0.35 * safezoneH)
#define RADIAL_SLOT_05_X QUOTE(safezoneX + (safezoneW - 0.52 * safezoneH * safezoneH / safezoneW) / 2 + 0.18 * safezoneH * safezoneH / safezoneW)
#define RADIAL_SLOT_05_Y QUOTE(safezoneY + (safezoneH - 0.52 * safezoneH) / 2 + 0.43 * safezoneH)
#define RADIAL_SLOT_06_X QUOTE(safezoneX + (safezoneW - 0.52 * safezoneH * safezoneH / safezoneW) / 2 + 0.02 * safezoneH * safezoneH / safezoneW)
#define RADIAL_SLOT_06_Y QUOTE(safezoneY + (safezoneH - 0.52 * safezoneH) / 2 + 0.35 * safezoneH)
#define RADIAL_SLOT_07_X QUOTE(safezoneX + (safezoneW - 0.52 * safezoneH * safezoneH / safezoneW) / 2 + 0.01 * safezoneH * safezoneH / safezoneW)
#define RADIAL_SLOT_07_Y QUOTE(safezoneY + (safezoneH - 0.52 * safezoneH) / 2 + 0.22 * safezoneH)
#define RADIAL_SLOT_08_X QUOTE(safezoneX + (safezoneW - 0.52 * safezoneH * safezoneH / safezoneW) / 2 + 0.02 * safezoneH * safezoneH / safezoneW)
#define RADIAL_SLOT_08_Y QUOTE(safezoneY + (safezoneH - 0.52 * safezoneH) / 2 + 0.095 * safezoneH)

class GVAR(RadialText) {
    deletable = 0;
    fade = 0;
    access = 0;
    type = 0;
    idc = -1;
    style = 2;
    x = 0;
    y = 0;
    w = 0;
    h = 0;
    colorBackground[] = {0.05, 0.08, 0.11, 0.92};
    colorText[] = {0.94, 0.97, 1, 1};
    colorShadow[] = {0, 0, 0, 0.8};
    shadow = 1;
    font = "RobotoCondensedBold";
    sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.95)";
    text = "";
    lineSpacing = 1;
};

class GVAR(RadialButton): GVAR(RadialText) {
    type = 11;
    style = 48;
    color[] = {1, 1, 1, 1};
    colorActive[] = {1, 1, 1, 1};
    colorDisabled[] = {1, 1, 1, 0.5};
    colorFocused[] = {1, 1, 1, 1};
    default = 0;
    soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter", 0.09, 1};
    soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush", 0.09, 1};
    soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick", 0.09, 1};
    soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape", 0.09, 1};
    onMouseButtonClick = QUOTE(_this call FUNC(selectRadialWeapon));
};

class GVAR(radialMenu) {
    idd = IDD_RADIAL_MENU;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = QUOTE(_this call FUNC(onRadialMenuLoad));

    class controlsBackground {
        class SlotBackground01: GVAR(RadialText) {
            idc = IDC_RADIAL_FALLBACK_01;
            x = RADIAL_SLOT_01_X;
            y = RADIAL_SLOT_01_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
            text = "";
        };

        class SlotBackground02: GVAR(RadialText) {
            idc = IDC_RADIAL_FALLBACK_02;
            x = RADIAL_SLOT_02_X;
            y = RADIAL_SLOT_02_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
            text = "";
        };

        class SlotBackground03: GVAR(RadialText) {
            idc = IDC_RADIAL_FALLBACK_03;
            x = RADIAL_SLOT_03_X;
            y = RADIAL_SLOT_03_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
            text = "";
        };

        class SlotBackground04: GVAR(RadialText) {
            idc = IDC_RADIAL_FALLBACK_04;
            x = RADIAL_SLOT_04_X;
            y = RADIAL_SLOT_04_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
            text = "";
        };

        class SlotBackground05: GVAR(RadialText) {
            idc = IDC_RADIAL_FALLBACK_05;
            x = RADIAL_SLOT_05_X;
            y = RADIAL_SLOT_05_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
            text = "";
        };

        class SlotBackground06: GVAR(RadialText) {
            idc = IDC_RADIAL_FALLBACK_06;
            x = RADIAL_SLOT_06_X;
            y = RADIAL_SLOT_06_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
            text = "";
        };

        class SlotBackground07: GVAR(RadialText) {
            idc = IDC_RADIAL_FALLBACK_07;
            x = RADIAL_SLOT_07_X;
            y = RADIAL_SLOT_07_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
            text = "";
        };

        class SlotBackground08: GVAR(RadialText) {
            idc = IDC_RADIAL_FALLBACK_08;
            x = RADIAL_SLOT_08_X;
            y = RADIAL_SLOT_08_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
            text = "";
        };

        class CenterHub: GVAR(RadialText) {
            idc = IDC_RADIAL_CENTER;
            x = QUOTE(safezoneX + (safezoneW - 0.52 * safezoneH * safezoneH / safezoneW) / 2 + (0.52 * safezoneH * safezoneH / safezoneW - 0.14 * safezoneH * safezoneH / safezoneW) / 2);
            y = QUOTE(safezoneY + (safezoneH - 0.52 * safezoneH) / 2 + 0.195 * safezoneH);
            w = QUOTE(0.14 * safezoneH * safezoneH / safezoneW);
            h = QUOTE(0.07 * safezoneH);
            colorBackground[] = {0.08, 0.19, 0.29, 0.96};
            text = "0\nCARRIED";
        };
    };

    class controls {
        class EquipmentSlot01: GVAR(RadialButton) {
            idc = IDC_RADIAL_SLOT_01;
            x = RADIAL_SLOT_01_X;
            y = RADIAL_SLOT_01_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
        };

        class EquipmentSlot02: GVAR(RadialButton) {
            idc = IDC_RADIAL_SLOT_02;
            x = RADIAL_SLOT_02_X;
            y = RADIAL_SLOT_02_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
        };

        class EquipmentSlot03: GVAR(RadialButton) {
            idc = IDC_RADIAL_SLOT_03;
            x = RADIAL_SLOT_03_X;
            y = RADIAL_SLOT_03_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
        };

        class EquipmentSlot04: GVAR(RadialButton) {
            idc = IDC_RADIAL_SLOT_04;
            x = RADIAL_SLOT_04_X;
            y = RADIAL_SLOT_04_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
        };

        class EquipmentSlot05: GVAR(RadialButton) {
            idc = IDC_RADIAL_SLOT_05;
            x = RADIAL_SLOT_05_X;
            y = RADIAL_SLOT_05_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
        };

        class EquipmentSlot06: GVAR(RadialButton) {
            idc = IDC_RADIAL_SLOT_06;
            x = RADIAL_SLOT_06_X;
            y = RADIAL_SLOT_06_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
        };

        class EquipmentSlot07: GVAR(RadialButton) {
            idc = IDC_RADIAL_SLOT_07;
            x = RADIAL_SLOT_07_X;
            y = RADIAL_SLOT_07_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
        };

        class EquipmentSlot08: GVAR(RadialButton) {
            idc = IDC_RADIAL_SLOT_08;
            x = RADIAL_SLOT_08_X;
            y = RADIAL_SLOT_08_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
        };

        class EmptyNotice: GVAR(RadialText) {
            idc = IDC_RADIAL_EMPTY;
            x = RADIAL_SLOT_01_X;
            y = RADIAL_SLOT_01_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
            text = "";
        };

        class OverflowNotice: GVAR(RadialText) {
            idc = IDC_RADIAL_OVERFLOW;
            x = RADIAL_SLOT_08_X;
            y = RADIAL_SLOT_08_Y;
            w = RADIAL_SLOT_W;
            h = RADIAL_SLOT_H;
            text = "";
        };

        class PreviewNotice: GVAR(RadialText) {
            style = 2;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {0.78, 0.84, 0.89, 1};
            font = "RobotoCondensed";
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.72)";
            x = QUOTE(safezoneX + (safezoneW - 0.52 * safezoneH * safezoneH / safezoneW) / 2 - 0.10 * safezoneH * safezoneH / safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.52 * safezoneH) / 2 + 0.502 * safezoneH);
            w = QUOTE(0.52 * safezoneH * safezoneH / safezoneW + 0.20 * safezoneH * safezoneH / safezoneW);
            h = QUOTE(0.016 * safezoneH);
            text = CSTRING(Radial_ClickToEquip);
        };
    };
};

#undef RADIAL_SLOT_W
#undef RADIAL_SLOT_H
#undef RADIAL_SLOT_01_X
#undef RADIAL_SLOT_01_Y
#undef RADIAL_SLOT_02_X
#undef RADIAL_SLOT_02_Y
#undef RADIAL_SLOT_03_X
#undef RADIAL_SLOT_03_Y
#undef RADIAL_SLOT_04_X
#undef RADIAL_SLOT_04_Y
#undef RADIAL_SLOT_05_X
#undef RADIAL_SLOT_05_Y
#undef RADIAL_SLOT_06_X
#undef RADIAL_SLOT_06_Y
#undef RADIAL_SLOT_07_X
#undef RADIAL_SLOT_07_Y
#undef RADIAL_SLOT_08_X
#undef RADIAL_SLOT_08_Y
