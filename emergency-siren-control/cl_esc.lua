local CONTROLS = {
    TOGGLE = {"", 80 --[[INPUT_VEH_CIN_CAM]]},
    ENABLE = {"Enable siren", 80 --[[INPUT_VEH_CIN_CAM]]},
    DISABLE = {"Disable siren", 80 --[[INPUT_VEH_CIN_CAM]]},
    LIGHTS = {"Disable emergency lights", 86 --[[INPUT_VEH_HORN]]},
}

Citizen.CreateThread(function()
    -- LOCAL OPTIMIZATION
    local Wait = Wait
    local GetVehiclePedIsUsing = GetVehiclePedIsUsing
    local PlayerPedId = PlayerPedId
    local IsVehicleSirenOn = IsVehicleSirenOn
    local DisableControlAction = DisableControlAction
    local IsDisabledControlJustPressed = IsDisabledControlJustPressed
    local DecorExistOn = DecorExistOn
    local DecorGetBool = DecorGetBool
    local DecorSetBool = DecorSetBool
    local PlaySoundFrontend = PlaySoundFrontend
    -- END LOCAL OPTIMIZATION

    AddTextEntry("ESC_ENABLE", CONTROLS['ENABLE'][1])
    AddTextEntry("ESC_DISABLE", CONTROLS['DISABLE'][1])
    AddTextEntry("ESC_LIGHTS", CONTROLS['LIGHTS'][1])

    DecorRegister("esc_siren_enabled", 2)
    DecorRegisterLock()
    while true do
        Wait(0)
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        if veh then
            if IsVehicleSirenOn(veh) then
                DisableControlAction(0, CONTROLS['TOGGLE'][2], true)
                SetInstructionalButton("ESC_LIGHTS", CONTROLS['LIGHTS'][2], true)
                if DecorExistOn(veh, "esc_siren_enabled") and DecorGetBool(veh, "esc_siren_enabled") then
                    SetInstructionalButton("ESC_ENABLE", CONTROLS['ENABLE'][2], false)
                    SetInstructionalButton("ESC_DISABLE", CONTROLS['DISABLE'][2], true)
                    if IsDisabledControlJustPressed(0, CONTROLS['TOGGLE'][2]) then
                        DecorSetBool(veh, "esc_siren_enabled", false)
                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                    end
                else
                    SetInstructionalButton("ESC_ENABLE", CONTROLS['ENABLE'][2], true)
                    SetInstructionalButton("ESC_DISABLE", CONTROLS['DISABLE'][2], false)
                    if IsDisabledControlJustPressed(0, CONTROLS['TOGGLE'][2]) then
                        DecorSetBool(veh, "esc_siren_enabled", true)
                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                    end
                end
            else
                SetInstructionalButton("ESC_ENABLE", CONTROLS['ENABLE'][2], false)
                SetInstructionalButton("ESC_DISABLE", CONTROLS['DISABLE'][2], false)
                SetInstructionalButton("ESC_LIGHTS", CONTROLS['LIGHTS'][2], false)
            end
        end
    end
end)

Citizen.CreateThread(function()
    -- LOCAL OPTIMIZATION
    local EnumerateVehicles = EnumerateVehicles
    local DecorExistOn = DecorExistOn
    local DecorGetBool = DecorGetBool
    local DisableVehicleImpactExplosionActivation = DisableVehicleImpactExplosionActivation
    local Wait = Wait
    -- END LOCAL OPTIMIZATION
    while true do
        Wait(0)
        local _c = 0
        for veh in EnumerateVehicles() do
            if DecorExistOn(veh, "esc_siren_enabled") and DecorGetBool(veh, "esc_siren_enabled") then
                DisableVehicleImpactExplosionActivation(veh, false)
            else
                DisableVehicleImpactExplosionActivation(veh, true)
            end
            _c = (_c + 1) % 10
            if _c == 0 then
                Wait(0)
            end
        end
    end
end)
