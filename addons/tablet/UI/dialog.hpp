#include "defineRes.hpp"
#include "baseControls.hpp"

#define TABLET_W QUOTE(0.84 * safezoneW)
#define TABLET_H QUOTE(0.84 * safezoneH)
#define TABLET_X QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2)
#define TABLET_Y QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2)

#define SCREEN_X QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.008 * safezoneW)
#define SCREEN_Y QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.008 * safezoneH)
#define SCREEN_W QUOTE(0.824 * safezoneW)
#define SCREEN_H QUOTE(0.824 * safezoneH)

#define LEFT_W QUOTE(0.824 * safezoneW * 0.36)
#define RIGHT_X QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.008 * safezoneW + 0.824 * safezoneW * 0.375)
#define RIGHT_W QUOTE(0.824 * safezoneW * 0.625)

class GVAR(dialog) {
    idd = IDD_TABLET_DIALOG;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = QUOTE(call FUNC(onDialogLoad));
    onUnload = QUOTE(call FUNC(onDialogUnload));

    class controlsBackground {
        // Outer Rugged Tablet Bezel
        class TabletBezel: GVAR(RscText) {
            idc = -1;
            x = TABLET_X;
            y = TABLET_Y;
            w = TABLET_W;
            h = TABLET_H;
            colorBackground[] = {0.08, 0.09, 0.12, 0.98};
        };

        // Inner Screen Canvas
        class TabletScreen: GVAR(RscText) {
            idc = -1;
            x = SCREEN_X;
            y = SCREEN_Y;
            w = SCREEN_W;
            h = SCREEN_H;
            colorBackground[] = {0.04, 0.06, 0.09, 1};
        };

        // Top Header Bar
        class HeaderBar: GVAR(RscText) {
            idc = -1;
            x = SCREEN_X;
            y = SCREEN_Y;
            w = SCREEN_W;
            h = QUOTE(0.048 * safezoneH);
            colorBackground[] = {0.06, 0.14, 0.26, 1};
        };

        // Left Pane Background
        class LeftPaneBg: GVAR(RscText) {
            idc = -1;
            x = SCREEN_X;
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.008 * safezoneH + 0.092 * safezoneH);
            w = LEFT_W;
            h = QUOTE(0.824 * safezoneH - 0.13 * safezoneH);
            colorBackground[] = {0.05, 0.07, 0.10, 0.8};
        };

        // Right Pane Background
        class RightPaneBg: GVAR(RscText) {
            idc = -1;
            x = RIGHT_X;
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.008 * safezoneH + 0.092 * safezoneH);
            w = RIGHT_W;
            h = QUOTE(0.824 * safezoneH - 0.13 * safezoneH);
            colorBackground[] = {0.05, 0.07, 0.10, 0.8};
        };

        // Bottom Status Bar Background
        class BottomBarBg: GVAR(RscText) {
            idc = -1;
            x = SCREEN_X;
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.008 * safezoneH + 0.824 * safezoneH - 0.035 * safezoneH);
            w = SCREEN_W;
            h = QUOTE(0.035 * safezoneH);
            colorBackground[] = {0.03, 0.04, 0.06, 1};
        };
    };

    class controls {
        // --- Header Controls ---
        class HeaderTitle: GVAR(RscText) {
            idc = IDC_TABLET_HEADER_TITLE;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.018 * safezoneW);
            y = SCREEN_Y;
            w = QUOTE(0.40 * safezoneW);
            h = QUOTE(0.048 * safezoneH);
            text = CSTRING(Header_Title);
            font = "RobotoCondensedBold";
            SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.15)";
            colorText[] = {0.95, 0.95, 0.95, 1};
        };

        class HeaderOfficer: GVAR(RscText) {
            idc = IDC_TABLET_HEADER_OFFICER;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.428 * safezoneW);
            y = SCREEN_Y;
            w = QUOTE(0.35 * safezoneW);
            h = QUOTE(0.048 * safezoneH);
            text = "";
            style = 1; // ST_RIGHT
            SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.85)";
            colorText[] = {0.75, 0.85, 0.95, 1};
        };

        class BtnClose: GVAR(RscButton) {
            idc = IDC_TABLET_BTN_CLOSE;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.008 * safezoneW + 0.824 * safezoneW - 0.035 * safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.014 * safezoneH);
            w = QUOTE(0.028 * safezoneW);
            h = QUOTE(0.036 * safezoneH);
            text = "X";
            font = "RobotoCondensedBold";
            colorBackground[] = {0.6, 0.15, 0.15, 1};
            colorBackgroundActive[] = {0.8, 0.2, 0.2, 1};
            colorFocused[] = {0.8, 0.2, 0.2, 1};
            onButtonClick = "closeDialog 0;";
        };

        // --- Tab Navigation ---
        class TabPersons: GVAR(RscButton) {
            idc = IDC_TABLET_TAB_PERSONS;
            x = SCREEN_X;
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.008 * safezoneH + 0.052 * safezoneH);
            w = QUOTE(0.12 * safezoneW);
            h = QUOTE(0.036 * safezoneH);
            text = CSTRING(Tab_Persons);
            font = "RobotoCondensedBold";
            colorBackground[] = {0.15, 0.35, 0.60, 1};
            onButtonClick = QUOTE([0] call FUNC(setTab));
        };

        class TabWanted: GVAR(RscButton) {
            idc = IDC_TABLET_TAB_WANTED;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.008 * safezoneW + 0.125 * safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.008 * safezoneH + 0.052 * safezoneH);
            w = QUOTE(0.12 * safezoneW);
            h = QUOTE(0.036 * safezoneH);
            text = CSTRING(Tab_Wanted);
            font = "RobotoCondensedBold";
            colorBackground[] = {0.10, 0.18, 0.28, 1};
            onButtonClick = QUOTE([1] call FUNC(setTab));
        };

        class TabVehicles: GVAR(RscButton) {
            idc = IDC_TABLET_TAB_VEHICLES;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.008 * safezoneW + 0.250 * safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.008 * safezoneH + 0.052 * safezoneH);
            w = QUOTE(0.12 * safezoneW);
            h = QUOTE(0.036 * safezoneH);
            text = CSTRING(Tab_Vehicles);
            font = "RobotoCondensedBold";
            colorBackground[] = {0.10, 0.18, 0.28, 1};
            onButtonClick = QUOTE([2] call FUNC(setTab));
        };

        // --- Left Pane Controls (Search & List) ---
        class SearchInput: GVAR(RscEdit) {
            idc = IDC_TABLET_SEARCH_INPUT;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.013 * safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.106 * safezoneH);
            w = QUOTE(0.824 * safezoneW * 0.36 - 0.092 * safezoneW);
            h = QUOTE(0.034 * safezoneH);
            colorBackground[] = {0.08, 0.11, 0.16, 1};
        };

        class BtnSearch: GVAR(RscButton) {
            idc = IDC_TABLET_BTN_SEARCH;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.008 * safezoneW + 0.824 * safezoneW * 0.36 - 0.084 * safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.106 * safezoneH);
            w = QUOTE(0.040 * safezoneW);
            h = QUOTE(0.034 * safezoneH);
            text = CSTRING(Btn_Search);
            font = "RobotoCondensedBold";
            colorBackground[] = {0.18, 0.40, 0.65, 1};
            onButtonClick = QUOTE(call FUNC(searchPersons));
        };

        class BtnClear: GVAR(RscButton) {
            idc = IDC_TABLET_BTN_CLEAR;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.008 * safezoneW + 0.824 * safezoneW * 0.36 - 0.042 * safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.106 * safezoneH);
            w = QUOTE(0.037 * safezoneW);
            h = QUOTE(0.034 * safezoneH);
            text = CSTRING(Btn_Clear);
            colorBackground[] = {0.20, 0.22, 0.26, 1};
            onButtonClick = QUOTE(call FUNC(clearSearch));
        };

        class FilterWantedBtn: GVAR(RscButton) {
            idc = IDC_TABLET_FILTER_WANTED;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.013 * safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.144 * safezoneH);
            w = QUOTE(0.824 * safezoneW * 0.36 - 0.010 * safezoneW);
            h = QUOTE(0.026 * safezoneH);
            text = CSTRING(Filter_ShowAll);
            SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
            colorBackground[] = {0.12, 0.15, 0.20, 1};
            onButtonClick = QUOTE(call FUNC(toggleWantedFilter));
        };

        class ListPersons: GVAR(RscListBox) {
            idc = IDC_TABLET_LIST_PERSONS;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.013 * safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.174 * safezoneH);
            w = QUOTE(0.824 * safezoneW * 0.36 - 0.010 * safezoneW);
            h = QUOTE(0.824 * safezoneH - 0.332 * safezoneH);
            onLBSelChanged = QUOTE(if (GVAR(currentTab) == 2) then {call FUNC(onVehicleListSelect)} else {call FUNC(onPersonsListSelect)});
        };

        class ResultsCount: GVAR(RscText) {
            idc = IDC_TABLET_RESULTS_COUNT;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.013 * safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.008 * safezoneH + 0.824 * safezoneH - 0.065 * safezoneH);
            w = QUOTE(0.824 * safezoneW * 0.36 - 0.010 * safezoneW);
            h = QUOTE(0.026 * safezoneH);
            text = "";
            SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
            colorText[] = {0.6, 0.7, 0.8, 1};
        };

        // --- Right Pane Controls (Record View) ---
        class EmptyNotice: GVAR(RscStructuredText) {
            idc = IDC_TABLET_RECORD_EMPTY_NOTICE;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.008 * safezoneW + 0.824 * safezoneW * 0.375 + 0.02 * safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.25 * safezoneH);
            w = QUOTE(0.824 * safezoneW * 0.625 - 0.04 * safezoneW);
            h = QUOTE(0.20 * safezoneH);
            text = "";
        };

        class RecordControlsGroup: GVAR(RscControlsGroup) {
            idc = IDC_TABLET_RECORD_GROUP;
            x = RIGHT_X;
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.008 * safezoneH + 0.092 * safezoneH);
            w = RIGHT_W;
            h = QUOTE(0.824 * safezoneH - 0.13 * safezoneH);

            class Controls {
                // Header Name
                class RecordName: GVAR(RscText) {
                    idc = IDC_TABLET_RECORD_NAME;
                    x = QUOTE(0.010 * safezoneW);
                    y = QUOTE(0.008 * safezoneH);
                    w = QUOTE(0.48 * safezoneW);
                    h = QUOTE(0.040 * safezoneH);
                    text = "";
                    font = "RobotoCondensedBold";
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.3)";
                    colorText[] = {0.95, 0.95, 0.95, 1};
                };

                // Subtitle (ID, AI/Player, UID)
                class RecordSubtitle: GVAR(RscText) {
                    idc = IDC_TABLET_RECORD_SUBTITLE;
                    x = QUOTE(0.010 * safezoneW);
                    y = QUOTE(0.048 * safezoneH);
                    w = QUOTE(0.48 * safezoneW);
                    h = QUOTE(0.024 * safezoneH);
                    text = "";
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
                    colorText[] = {0.65, 0.75, 0.85, 1};
                };

                // Wanted Banner
                class RecordWantedBadge: GVAR(RscStructuredText) {
                    idc = IDC_TABLET_RECORD_WANTED_BADGE;
                    x = QUOTE(0.010 * safezoneW);
                    y = QUOTE(0.076 * safezoneH);
                    w = QUOTE(0.48 * safezoneW);
                    h = QUOTE(0.038 * safezoneH);
                    text = "";
                };

                // Licenses Row
                class LicDriveLabel: GVAR(RscText) {
                    idc = IDC_TABLET_RECORD_LIC_DRIVE;
                    x = QUOTE(0.010 * safezoneW);
                    y = QUOTE(0.120 * safezoneH);
                    w = QUOTE(0.160 * safezoneW);
                    h = QUOTE(0.028 * safezoneH);
                    text = "";
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.85)";
                };

                class BtnToggleDrive: GVAR(RscButton) {
                    idc = IDC_TABLET_BTN_TOGGLE_DRIVE;
                    x = QUOTE(0.175 * safezoneW);
                    y = QUOTE(0.120 * safezoneH);
                    w = QUOTE(0.065 * safezoneW);
                    h = QUOTE(0.028 * safezoneH);
                    text = CSTRING(Btn_ToggleLicense);
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
                    colorBackground[] = {0.18, 0.28, 0.40, 1};
                    onButtonClick = QUOTE([ctrlIDC (_this select 0)] call FUNC(toggleLicense));
                };

                class LicGunLabel: GVAR(RscText) {
                    idc = IDC_TABLET_RECORD_LIC_GUN;
                    x = QUOTE(0.250 * safezoneW);
                    y = QUOTE(0.120 * safezoneH);
                    w = QUOTE(0.160 * safezoneW);
                    h = QUOTE(0.028 * safezoneH);
                    text = "";
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.85)";
                };

                class BtnToggleGun: GVAR(RscButton) {
                    idc = IDC_TABLET_BTN_TOGGLE_GUN;
                    x = QUOTE(0.415 * safezoneW);
                    y = QUOTE(0.120 * safezoneH);
                    w = QUOTE(0.065 * safezoneW);
                    h = QUOTE(0.028 * safezoneH);
                    text = CSTRING(Btn_ToggleLicense);
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
                    colorBackground[] = {0.18, 0.28, 0.40, 1};
                    onButtonClick = QUOTE([ctrlIDC (_this select 0)] call FUNC(toggleLicense));
                };

                // Vehicles list text
                class RecordVehicles: GVAR(RscText) {
                    idc = IDC_TABLET_RECORD_VEHICLES;
                    x = QUOTE(0.010 * safezoneW);
                    y = QUOTE(0.154 * safezoneH);
                    w = QUOTE(0.48 * safezoneW);
                    h = QUOTE(0.024 * safezoneH);
                    text = "";
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
                    colorText[] = {0.7, 0.8, 0.9, 1};
                };

                // Notes Header & Edit
                class NotesHeader: GVAR(RscText) {
                    idc = -1;
                    x = QUOTE(0.010 * safezoneW);
                    y = QUOTE(0.184 * safezoneH);
                    w = QUOTE(0.25 * safezoneW);
                    h = QUOTE(0.024 * safezoneH);
                    text = CSTRING(Header_Notes);
                    font = "RobotoCondensedBold";
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.85)";
                    colorText[] = {0.85, 0.85, 0.85, 1};
                };

                class BtnSaveNotes: GVAR(RscButton) {
                    idc = IDC_TABLET_BTN_SAVE_NOTES;
                    x = QUOTE(0.405 * safezoneW);
                    y = QUOTE(0.182 * safezoneH);
                    w = QUOTE(0.080 * safezoneW);
                    h = QUOTE(0.026 * safezoneH);
                    text = CSTRING(Btn_SaveNotes);
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
                    colorBackground[] = {0.15, 0.45, 0.25, 1};
                    colorBackgroundActive[] = {0.20, 0.60, 0.35, 1};
                    onButtonClick = QUOTE(call FUNC(saveNotes));
                };

                class RecordNotes: GVAR(RscEditMulti) {
                    idc = IDC_TABLET_RECORD_NOTES;
                    x = QUOTE(0.010 * safezoneW);
                    y = QUOTE(0.212 * safezoneH);
                    w = QUOTE(0.48 * safezoneW);
                    h = QUOTE(0.080 * safezoneH);
                    colorBackground[] = {0.08, 0.10, 0.14, 0.9};
                };

                // Criminal History Header
                class CrimesHeader: GVAR(RscText) {
                    idc = -1;
                    x = QUOTE(0.010 * safezoneW);
                    y = QUOTE(0.300 * safezoneH);
                    w = QUOTE(0.25 * safezoneW);
                    h = QUOTE(0.024 * safezoneH);
                    text = CSTRING(Header_CriminalRecord);
                    font = "RobotoCondensedBold";
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.85)";
                    colorText[] = {0.85, 0.85, 0.85, 1};
                };

                class CrimesList: GVAR(RscListBox) {
                    idc = IDC_TABLET_RECORD_CRIMES_LIST;
                    x = QUOTE(0.010 * safezoneW);
                    y = QUOTE(0.328 * safezoneH);
                    w = QUOTE(0.48 * safezoneW);
                    h = QUOTE(0.250 * safezoneH);
                };

                // Action Buttons Row
                class BtnAddCrime: GVAR(RscButton) {
                    idc = IDC_TABLET_BTN_ADD_CRIME;
                    x = QUOTE(0.010 * safezoneW);
                    y = QUOTE(0.586 * safezoneH);
                    w = QUOTE(0.100 * safezoneW);
                    h = QUOTE(0.034 * safezoneH);
                    text = CSTRING(Btn_AddCrime);
                    font = "RobotoCondensedBold";
                    colorBackground[] = {0.55, 0.20, 0.20, 1};
                    colorBackgroundActive[] = {0.70, 0.25, 0.25, 1};
                    onButtonClick = QUOTE(call FUNC(openCrimeModal));
                };

                class BtnEditWanted: GVAR(RscButton) {
                    idc = IDC_TABLET_BTN_EDIT_WANTED;
                    x = QUOTE(0.118 * safezoneW);
                    y = QUOTE(0.586 * safezoneH);
                    w = QUOTE(0.120 * safezoneW);
                    h = QUOTE(0.034 * safezoneH);
                    text = CSTRING(Btn_EditWanted);
                    font = "RobotoCondensedBold";
                    colorBackground[] = {0.20, 0.38, 0.60, 1};
                    colorBackgroundActive[] = {0.25, 0.48, 0.75, 1};
                    onButtonClick = QUOTE(call FUNC(openWantedModal));
                };

                class BtnRefreshRecord: GVAR(RscButton) {
                    idc = IDC_TABLET_BTN_REFRESH;
                    x = QUOTE(0.246 * safezoneW);
                    y = QUOTE(0.586 * safezoneH);
                    w = QUOTE(0.080 * safezoneW);
                    h = QUOTE(0.034 * safezoneH);
                    text = CSTRING(Btn_Refresh);
                    colorBackground[] = {0.18, 0.22, 0.28, 1};
                    onButtonClick = QUOTE(call FUNC(refreshCurrentRecord));
                };
            };
        };

        // --- Vehicles Tab ---
        class VehiclesGroup: GVAR(RscControlsGroup) {
            idc = IDC_TABLET_VEHICLES_GROUP;
            x = RIGHT_X;
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.008 * safezoneH + 0.092 * safezoneH);
            w = RIGHT_W;
            h = QUOTE(0.824 * safezoneH - 0.13 * safezoneH);

            class Controls {
                class VehicleEmptyNotice: GVAR(RscStructuredText) {
                    idc = IDC_TABLET_VEHICLE_EMPTY_NOTICE;
                    x = QUOTE(0.02 * safezoneW);
                    y = QUOTE(0.20 * safezoneH);
                    w = QUOTE(0.57 * safezoneW);
                    h = QUOTE(0.10 * safezoneH);
                    text = CSTRING(Vehicle_SelectRecord);
                };

                class VehicleName: GVAR(RscText) {
                    idc = IDC_TABLET_VEHICLE_NAME;
                    x = QUOTE(0.02 * safezoneW);
                    y = QUOTE(0.014 * safezoneH);
                    w = QUOTE(0.56 * safezoneW);
                    h = QUOTE(0.042 * safezoneH);
                    text = "";
                    font = "RobotoCondensedBold";
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.3)";
                    colorText[] = {0.95, 0.95, 0.95, 1};
                };

                class VehiclePlate: GVAR(RscText) {
                    idc = IDC_TABLET_VEHICLE_PLATE;
                    x = QUOTE(0.02 * safezoneW);
                    y = QUOTE(0.070 * safezoneH);
                    w = QUOTE(0.56 * safezoneW);
                    h = QUOTE(0.030 * safezoneH);
                    text = "";
                };

                class VehicleOwner: GVAR(RscText) {
                    idc = IDC_TABLET_VEHICLE_OWNER;
                    x = QUOTE(0.02 * safezoneW);
                    y = QUOTE(0.108 * safezoneH);
                    w = QUOTE(0.56 * safezoneW);
                    h = QUOTE(0.030 * safezoneH);
                    text = "";
                };

                class VehicleClass: GVAR(RscText) {
                    idc = IDC_TABLET_VEHICLE_CLASS;
                    x = QUOTE(0.02 * safezoneW);
                    y = QUOTE(0.146 * safezoneH);
                    w = QUOTE(0.56 * safezoneW);
                    h = QUOTE(0.030 * safezoneH);
                    text = "";
                };

                class VehicleStatus: GVAR(RscText) {
                    idc = IDC_TABLET_VEHICLE_STATUS;
                    x = QUOTE(0.02 * safezoneW);
                    y = QUOTE(0.184 * safezoneH);
                    w = QUOTE(0.56 * safezoneW);
                    h = QUOTE(0.030 * safezoneH);
                    text = "";
                };

                class VehicleWantedReason: GVAR(RscStructuredText) {
                    idc = IDC_TABLET_VEHICLE_WANTED_REASON;
                    x = QUOTE(0.02 * safezoneW);
                    y = QUOTE(0.228 * safezoneH);
                    w = QUOTE(0.56 * safezoneW);
                    h = QUOTE(0.070 * safezoneH);
                    text = "";
                };

                class VehicleNotes: GVAR(RscStructuredText) {
                    idc = IDC_TABLET_VEHICLE_NOTES;
                    x = QUOTE(0.02 * safezoneW);
                    y = QUOTE(0.310 * safezoneH);
                    w = QUOTE(0.56 * safezoneW);
                    h = QUOTE(0.20 * safezoneH);
                    text = "";
                };
            };
        };

        // --- Bottom Status Bar ---
        class StatusBar: GVAR(RscText) {
            idc = IDC_TABLET_STATUS_BAR;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.018 * safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.008 * safezoneH + 0.824 * safezoneH - 0.032 * safezoneH);
            w = QUOTE(0.824 * safezoneW - 0.060 * safezoneW);
            h = QUOTE(0.028 * safezoneH);
            text = CSTRING(Status_Ready);
            SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.85)";
            colorText[] = {0.7, 0.8, 0.9, 1};
        };

        class ActivitySpinner: GVAR(RscText) {
            idc = IDC_TABLET_SPINNER;
            x = QUOTE(safezoneX + (safezoneW - 0.84 * safezoneW) / 2 + 0.008 * safezoneW + 0.824 * safezoneW - 0.045 * safezoneW);
            y = QUOTE(safezoneY + (safezoneH - 0.84 * safezoneH) / 2 + 0.008 * safezoneH + 0.824 * safezoneH - 0.032 * safezoneH);
            w = QUOTE(0.035 * safezoneW);
            h = QUOTE(0.028 * safezoneH);
            text = "";
            style = 1; // ST_RIGHT
            SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.85)";
            colorText[] = {1, 0.8, 0.2, 1};
        };

        // --- Modal Overlays ---
        // Modal: Add Crime
        class ModalCrimeBg: GVAR(RscText) {
            idc = IDC_TABLET_MODAL_CRIME_BG;
            x = TABLET_X;
            y = TABLET_Y;
            w = TABLET_W;
            h = TABLET_H;
            colorBackground[] = {0, 0, 0, 0.7};
        };

        class ModalCrimeGroup: GVAR(RscControlsGroup) {
            idc = IDC_TABLET_MODAL_CRIME_GROUP;
            x = QUOTE(safezoneX + (safezoneW - 0.36 * safezoneW) / 2);
            y = QUOTE(safezoneY + (safezoneH - 0.40 * safezoneH) / 2);
            w = QUOTE(0.36 * safezoneW);
            h = QUOTE(0.40 * safezoneH);

            class Controls {
                class CardBg: GVAR(RscText) {
                    idc = -1;
                    x = 0;
                    y = 0;
                    w = QUOTE(0.36 * safezoneW);
                    h = QUOTE(0.40 * safezoneH);
                    colorBackground[] = {0.09, 0.12, 0.16, 0.99};
                };

                class CardHeader: GVAR(RscText) {
                    idc = -1;
                    x = 0;
                    y = 0;
                    w = QUOTE(0.36 * safezoneW);
                    h = QUOTE(0.040 * safezoneH);
                    text = CSTRING(Modal_Crime_Title);
                    font = "RobotoCondensedBold";
                    colorBackground[] = {0.55, 0.20, 0.20, 1};
                    colorText[] = {1, 1, 1, 1};
                };

                class TitleLabel: GVAR(RscText) {
                    idc = -1;
                    x = QUOTE(0.015 * safezoneW);
                    y = QUOTE(0.050 * safezoneH);
                    w = QUOTE(0.33 * safezoneW);
                    h = QUOTE(0.022 * safezoneH);
                    text = CSTRING(Modal_Crime_Charge);
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
                    colorText[] = {0.8, 0.85, 0.9, 1};
                };

                class TitleInput: GVAR(RscEdit) {
                    idc = IDC_TABLET_MODAL_CRIME_TITLE;
                    x = QUOTE(0.015 * safezoneW);
                    y = QUOTE(0.075 * safezoneH);
                    w = QUOTE(0.33 * safezoneW);
                    h = QUOTE(0.034 * safezoneH);
                };

                class SevLabel: GVAR(RscText) {
                    idc = -1;
                    x = QUOTE(0.015 * safezoneW);
                    y = QUOTE(0.118 * safezoneH);
                    w = QUOTE(0.33 * safezoneW);
                    h = QUOTE(0.022 * safezoneH);
                    text = CSTRING(Modal_Crime_Severity);
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
                    colorText[] = {0.8, 0.85, 0.9, 1};
                };

                class SevCombo: GVAR(RscCombo) {
                    idc = IDC_TABLET_MODAL_CRIME_SEV;
                    x = QUOTE(0.015 * safezoneW);
                    y = QUOTE(0.143 * safezoneH);
                    w = QUOTE(0.33 * safezoneW);
                    h = QUOTE(0.034 * safezoneH);
                };

                class NotesLabel: GVAR(RscText) {
                    idc = -1;
                    x = QUOTE(0.015 * safezoneW);
                    y = QUOTE(0.188 * safezoneH);
                    w = QUOTE(0.33 * safezoneW);
                    h = QUOTE(0.022 * safezoneH);
                    text = CSTRING(Modal_Crime_Notes);
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
                    colorText[] = {0.8, 0.85, 0.9, 1};
                };

                class NotesInput: GVAR(RscEditMulti) {
                    idc = IDC_TABLET_MODAL_CRIME_NOTES;
                    x = QUOTE(0.015 * safezoneW);
                    y = QUOTE(0.213 * safezoneH);
                    w = QUOTE(0.33 * safezoneW);
                    h = QUOTE(0.120 * safezoneH);
                };

                class BtnSubmitCrime: GVAR(RscButton) {
                    idc = IDC_TABLET_MODAL_CRIME_SUBMIT;
                    x = QUOTE(0.015 * safezoneW);
                    y = QUOTE(0.350 * safezoneH);
                    w = QUOTE(0.155 * safezoneW);
                    h = QUOTE(0.036 * safezoneH);
                    text = CSTRING(Btn_SubmitCharge);
                    font = "RobotoCondensedBold";
                    colorBackground[] = {0.55, 0.20, 0.20, 1};
                    colorBackgroundActive[] = {0.70, 0.25, 0.25, 1};
                    onButtonClick = QUOTE(call FUNC(submitCrimeModal));
                };

                class BtnCancelCrime: GVAR(RscButton) {
                    idc = IDC_TABLET_MODAL_CRIME_CANCEL;
                    x = QUOTE(0.190 * safezoneW);
                    y = QUOTE(0.350 * safezoneH);
                    w = QUOTE(0.155 * safezoneW);
                    h = QUOTE(0.036 * safezoneH);
                    text = CSTRING(Btn_Cancel);
                    colorBackground[] = {0.20, 0.24, 0.30, 1};
                    onButtonClick = QUOTE(call FUNC(closeCrimeModal));
                };
            };
        };

        // Modal: Edit Wanted Status
        class ModalWantedBg: GVAR(RscText) {
            idc = IDC_TABLET_MODAL_WANTED_BG;
            x = TABLET_X;
            y = TABLET_Y;
            w = TABLET_W;
            h = TABLET_H;
            colorBackground[] = {0, 0, 0, 0.7};
        };

        class ModalWantedGroup: GVAR(RscControlsGroup) {
            idc = IDC_TABLET_MODAL_WANTED_GROUP;
            x = QUOTE(safezoneX + (safezoneW - 0.34 * safezoneW) / 2);
            y = QUOTE(safezoneY + (safezoneH - 0.38 * safezoneH) / 2);
            w = QUOTE(0.34 * safezoneW);
            h = QUOTE(0.38 * safezoneH);

            class Controls {
                class CardBg: GVAR(RscText) {
                    idc = -1;
                    x = 0;
                    y = 0;
                    w = QUOTE(0.34 * safezoneW);
                    h = QUOTE(0.38 * safezoneH);
                    colorBackground[] = {0.09, 0.12, 0.16, 0.99};
                };

                class CardHeader: GVAR(RscText) {
                    idc = -1;
                    x = 0;
                    y = 0;
                    w = QUOTE(0.34 * safezoneW);
                    h = QUOTE(0.040 * safezoneH);
                    text = CSTRING(Modal_Wanted_Title);
                    font = "RobotoCondensedBold";
                    colorBackground[] = {0.18, 0.35, 0.60, 1};
                    colorText[] = {1, 1, 1, 1};
                };

                class WantedToggleBtn: GVAR(RscButton) {
                    idc = IDC_TABLET_MODAL_WANTED_CHECK;
                    x = QUOTE(0.015 * safezoneW);
                    y = QUOTE(0.060 * safezoneH);
                    w = QUOTE(0.310 * safezoneW);
                    h = QUOTE(0.036 * safezoneH);
                    text = "";
                    font = "RobotoCondensedBold";
                    onButtonClick = QUOTE(call FUNC(toggleModalWantedState));
                };

                class ReasonLabel: GVAR(RscText) {
                    idc = -1;
                    x = QUOTE(0.015 * safezoneW);
                    y = QUOTE(0.112 * safezoneH);
                    w = QUOTE(0.310 * safezoneW);
                    h = QUOTE(0.022 * safezoneH);
                    text = CSTRING(Modal_Wanted_Reason);
                    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
                    colorText[] = {0.8, 0.85, 0.9, 1};
                };

                class ReasonInput: GVAR(RscEditMulti) {
                    idc = IDC_TABLET_MODAL_WANTED_REASON;
                    x = QUOTE(0.015 * safezoneW);
                    y = QUOTE(0.142 * safezoneH);
                    w = QUOTE(0.310 * safezoneW);
                    h = QUOTE(0.120 * safezoneH);
                };

                class BtnSubmitWanted: GVAR(RscButton) {
                    idc = IDC_TABLET_MODAL_WANTED_SUBMIT;
                    x = QUOTE(0.015 * safezoneW);
                    y = QUOTE(0.292 * safezoneH);
                    w = QUOTE(0.145 * safezoneW);
                    h = QUOTE(0.036 * safezoneH);
                    text = CSTRING(Btn_SaveWarrant);
                    font = "RobotoCondensedBold";
                    colorBackground[] = {0.18, 0.45, 0.28, 1};
                    colorBackgroundActive[] = {0.22, 0.60, 0.35, 1};
                    onButtonClick = QUOTE(call FUNC(submitWantedModal));
                };

                class BtnCancelWanted: GVAR(RscButton) {
                    idc = IDC_TABLET_MODAL_WANTED_CANCEL;
                    x = QUOTE(0.180 * safezoneW);
                    y = QUOTE(0.292 * safezoneH);
                    w = QUOTE(0.145 * safezoneW);
                    h = QUOTE(0.036 * safezoneH);
                    text = CSTRING(Btn_Cancel);
                    colorBackground[] = {0.20, 0.24, 0.30, 1};
                    onButtonClick = QUOTE(call FUNC(closeWantedModal));
                };
            };
        };
    };
};
