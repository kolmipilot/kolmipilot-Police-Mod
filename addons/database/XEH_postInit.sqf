#include "script_component.hpp"

if (isServer) then {
    call FUNC(initServer);
};

if (hasInterface) then {
    call FUNC(initClient);
};
