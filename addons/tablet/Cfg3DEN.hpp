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
                };
            };
        };
    };
};
