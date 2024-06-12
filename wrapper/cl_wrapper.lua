
Wrapper = {
    resname = GetCurrentResourceName(),
    blip = {},
    cam = {},
    zone = {},
    cars = {},
    object = {},
    ServerCallbacks = {},
    Items = {}
}

-- RESETS

AddEventHandler("onResourceStop", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    TriggerEvent(Wrapper.resname.."Wrapper:Reset")
end)
  

RegisterNetEvent(Wrapper.resname.."Wrapper:Reset",function()
    for k,v in pairs(Wrapper.object) do 
        DeleteObject(v)
    end
    for k,v in pairs(Wrapper.blip) do
        RemoveBlip(v)
    end
end)

function Wrapper:LoadModel(object) -- Load Model
    print(object)
    local hash = GetHashKey(tostring(object))
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
        print(hash)
        Wait(1000)
    end
end


function Wrapper:Target(id,label,pos,event,label2,event2) -- QBTarget target create
    if Config.Settings.Target == "QB" then 
        local sizex = 1
        local sizey = 1
        exports["qb-target"]:AddBoxZone(id, pos, sizex, sizey, {
            name = id,
            heading = "90.0",
            minZ = pos - 5,
            maxZ = pos + 5
        }, {
            options = {
                {
                    type = "client",
                    event = event,
                    icon = "fas fa-button",
                    label = label,
                },
                {
                    type = "client",
                    event = event2,
                    icon = "fas fa-button",
                    label = label2,
                },
            },
            distance = 1.5
        })
    end
    if Config.Settings.Target == "OX" then
        Wrapper.zone[id] = exports["ox_target"]:addBoxZone({ -- -1183.28, -884.06, 13.75
        coords = vec3(pos.x,pos.y,pos.z),
        size = vec3(1.0, 1.0, 1.0),
        rotation = 45,
        debug = false,
        options = {
            {
                name = id,
                event = event,
                icon = "fa-solid fa-cube",
                label = label,
            },
            {
                name = id,
                event = event2,
                icon = "fa-solid fa-cube",
                label = label2,
            },
        }
    })
    end
    if Config.Settings.Target == "ST" then 
        TriggerEvent('bbv-spinthebottle:sttarget',id,label,pos,event,label2,event2)
    end
end

RegisterNetEvent('bbv-spinthebottle:sttarget',function(id,label,pos,event,label2,event2)
    local WaitTime = 3000
    while true do 
        Wait(WaitTime)
        local mypos = GetEntityCoords(PlayerPedId())
        local dist = #(pos - mypos)
        if dist < 1.5 then 
            WaitTime = 0
            Wrapper:Draw3DText(pos,'[E]' .. label .. '[Z]' .. label2 ,4,0.05,0.05)
            if IsControlJustReleased(0,46) then
                TriggerEvent(event)
            end
            if IsControlJustReleased(0,20) then
                TriggerEvent(event2)
                break
            end
        else
            WaitTime = 3000
        end
    end
end)

function Wrapper:Draw3DText(pos,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, pos.x,pos.y,pos.z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255)		-- You can change the text color here
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(pos.x,pos.y,pos.z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function Wrapper:TargetRemove(sendid) -- Remove QBTarget target
    if Config.Settings.Target == "QB" then 
        exports["qb-target"]:RemoveZone(sendid)
    end 
    if Config.Settings.Target == "OX" then 
        exports["ox_target"]:removeZone(Wrapper.zone[sendid])
    end
    if Config.Settings.Target == "BT" then 
        exports["bt-taget"]:RemoveZone(sendid)
    end
    return
end

function Wrapper:Notify(txt,tp,time) -- QBCore notify
    QBCore.Functions.Notify(txt, tp, time)
end

function Wrapper:CreateObject(id,prop,coords,network,misson) -- Create object / prop
    RequestModel(prop)
    while not HasModelLoaded(prop) do
      Wait(0)
    end
    Wrapper.object[id] = CreateObject(GetHashKey(prop), coords , network or false,misson or false)
    SetEntityHeading(Wrapper.object[id], coords.w)
    FreezeEntityPosition(Wrapper.object[id], true)
    SetEntityAsMissionEntity(Wrapper.object[id], true, true)
    return Wrapper.object[id]
end
