local QBCore = exports["qb-core"]:GetCoreObject()

RegisterNetEvent("bf-policesellitems", function()
        QBCore.Functions.TriggerCallback(
            "bf-sellcheckpolice",
            function(result)
                if result then
                    local psellmenu =
                        exports["qb-input"]:ShowInput(
                        {
                            header = "PD Illegal Dealer",
                            submitText = "Sell Items",
                            inputs = {
                                {
                                    text = "Password",
                                    name = "pdillegalpass",
                                    type = "password",
                                    isRequired = true
                                }
                            }
                        }
                    )

                    if psellmenu ~= nil then
                        if psellmenu.pdillegalpass == Config.PDIllegalPassword then
                            TriggerServerEvent("bf-pdsellitemssrv")
                        else
                            QBCore.Functions.Notify("Wrong Password Contact SIGNATURE Government", "error")
                        end
                    end
                else
                    QBCore.Functions.Notify("You Are Not Authorized", "error")
                end
            end
        )
    end
)

local function BlackMoneyHack(success)
    if success then
        QBCore.Functions.TriggerCallback(
            "bf-getcopcount",
            function(copcount)
                local conrate = 0
                if copcount < 4 then
                    conrate = Config.BlackConvRate[copcount]
                else
                    conrate = Config.BlackConvRate[4]
                end
                TriggerEvent("mhacking:hide")
                TriggerServerEvent("bf-convertblack", conrate)
            end
        )
    else
        TriggerEvent("mhacking:hide")
        QBCore.Functions.Notify("Failed Hacking, Learn To Hack", "primary", 3000)
    end
end

RegisterNetEvent("bf-convertblackwh", function()
        QBCore.Functions.TriggerCallback(
            "bf-getcopcount",
            function(copcount)
                local conrate = 0
                if copcount < 4 then
                    conrate = Config.BlackConvRate[copcount]
                else
                    conrate = Config.BlackConvRate[4]
                end
                local bconmenu =
                    exports["qb-input"]:ShowInput(
                    {
                        header = "Conversion Rate " .. tostring(conrate) .. "%",
                        submitText = "Convert Black",
                        inputs = {}
                    }
                )

                if bconmenu ~= nil then
                    TriggerEvent("mhacking:show")
                    TriggerEvent("mhacking:start", 5, 15, BlackMoneyHack)
                end
            end
        )
    end
)

RegisterNetEvent("bf-welcomecarcl", function(plrcar, plate)
   QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, 340.41)
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
        TriggerServerEvent('qb-vehicletuning:server:SaveVehicleProps', QBCore.Functions.GetVehicleProperties(veh))
        SetVehicleColours(veh, 112)
        TriggerServerEvent('qb-mechanicjob:server:SaveVehicleProps', QBCore.Functions.GetVehicleProperties(veh))
end, plrcar, vector3(-277.4, -898.77, 30.41), true)
end)