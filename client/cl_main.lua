Main = {
    Props = {}
}


RegisterNetEvent('bbv-spinthebottle',function()
    if Main.Spinning then
        Wrapper:Notify("Bottle is already spinning")
        return 
    end
    Main.Spinning = true
    local rot = GetEntityRotation(Main.Props['Bottle'], 2)
    local roll, pitch, yaw = rot.x, rot.y, rot.z
    local number_of_spins = 5 -- Number of complete rotations
    local random_offset = math.random(0, 360) -- Random offset to stop at a random position
    local totalDegrees = 360 * number_of_spins + random_offset -- Total degrees to rotate
    local steps = 200 -- Number of steps for the rotation

    local stepIncrement = totalDegrees / steps -- Increment per step
    local currentYaw = yaw

    for i = 1, steps do
        Citizen.Wait(0) -- Delay between each adjustment

        currentYaw = currentYaw + stepIncrement

        -- Apply the current rotation
        SetEntityRotation(Main.Props['Bottle'], roll, pitch, currentYaw % 360, 2, true)
    end

    -- Ensure the final position is set accurately
    local finalYaw = (yaw + totalDegrees) % 360
    SetEntityRotation(Main.Props['Bottle'], roll, pitch, finalYaw, 2, true)
    Main.Spinning = false
end)

RegisterNetEvent('bbv-placebottle',function()
    if Main.Props["Bottle"] ~= nil then 
        Wrapper:Notify("You already have a bottle placed")
        return 
    end
    
    ExecuteCommand('e pickup')
    Wait(800)
    
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    
    -- Get the forward vector of the ped's heading
    local forwardVector = GetEntityForwardVector(ped)
    
    local distance = 0.5 -- You can adjust this distance as needed
    
    -- Calculate the coordinates in front of the ped
    local forwardPos = vector3(pos.x + forwardVector.x * distance, pos.y + forwardVector.y * distance, pos.z + forwardVector.z * distance)
    
    Main:SpawnProp('Bottle', vector3(forwardPos.x, forwardPos.y, forwardPos.z - 1.1), Config.Settings.Prop)
end)

RegisterNetEvent('bbv-takethebottle',function()
    ExecuteCommand('e pickup')
    Wait(800)
    DeleteObject(Main.Props['Bottle'])
    Main.Props['Bottle'] = nil
    Wrapper:TargetRemove('Bottle')
end)


function Main:SpawnProp(k, pos, model)
    Main:LoadModel(model)
    Main.Props[k] = Wrapper:CreateObject(k, model, pos, true, true)
    SetEntityHeading(Main.Props[k], pos.w)
    FreezeEntityPosition(Main.Props[k], true)
    local rot = GetEntityRotation(Main.Props['Bottle'], 2)
    local roll, pitch, yaw = rot.x, rot.y, rot.z
    SetEntityRotation(Main.Props['Bottle'], roll, 90.0, yaw, 2, true)
    Wrapper:Target(k, 'Spin The Bottle', pos, 'bbv-spinthebottle', "Take The Bottle" ,'bbv-takethebottle')
end

function Main:LoadModel(model)
    if HasModelLoaded(model) then return end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end
