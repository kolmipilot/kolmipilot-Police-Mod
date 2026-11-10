class Cfg3DEN {
    class Object {
        class AttributeCategories {
            class kolmip_attributes {
                displayName = CSTRING(Eden_AttributeCategory);
                collapsed = 1;

                class Attributes {
                    class kolmip_isPolice {
                        displayName = CSTRING(Eden_IsPolice_DisplayName);
                        tooltip = CSTRING(Eden_IsPolice_Description);
                        property = "kolmip_isPolice";
                        control = "Checkbox";
                        expression = QUOTE(if (isServer) then {[ARR_2(_this,_value)] call EFUNC(common,setPolice)});
                        defaultValue = "(false)";
                        condition = "objectBrain";
                        typeName = "BOOL";
                    };

                    class kolmip_personStatus {
                        displayName = CSTRING(Eden_PersonStatus_DisplayName);
                        tooltip = CSTRING(Eden_PersonStatus_Description);
                        property = "kolmip_personStatus";
                        control = "Combo";
                        expression = QUOTE([ARR_2(_this,_value)] call EFUNC(database,setConfiguredPersonStatus));
                        defaultValue = "0";
                        condition = "objectBrain";
                        typeName = "NUMBER";
                        class Values {
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

                    class kolmip_wantedReason {
                        displayName = CSTRING(Eden_WantedReason_DisplayName);
                        tooltip = CSTRING(Eden_WantedReason_Description);
                        property = "kolmip_wantedReason";
                        control = "Edit";
                        expression = QUOTE([ARR_2(_this,_value)] call EFUNC(database,setConfiguredPersonWantedReason));
                        defaultValue = "";
                        condition = "objectBrain";
                        typeName = "STRING";
                    };
                };
            };
        };
    };
};
