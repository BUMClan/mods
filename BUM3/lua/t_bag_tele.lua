api_version = "1.12.0.0"
teleports={{121.26,-182.88,6.68},{114.68,-129.18,1.45},{62.42,-178.38,4.35},{62.06,-155.40,5.96},{46.63,-151.09,4.24},{65.11,-120.67,0.15},{98.12,-110.29,4.27},{103.93,-108.83,1.74},{96.57,-91.43,4.91},{68.64,-94.76,1.75},{23.30,-108.55,2.39},{68.33,-60.58,3.71},{69.91,-88.07,5.67},{19.49,-60.83,4.08}}
bodies={}
tick_counter=0
crouch={}
prev_crouch={}
function OnScriptLoad()
    register_callback(cb['EVENT_DIE'], 'OnPlayerDeath')
    register_callback(cb['EVENT_TICK'], 'OnTick')
end

function OnTick()
    
    for i=1,16,1 do
        if (player_present(i) and player_alive(i)) then
            
            local player=get_dynamic_player(i)
            --print(read_bit(player + 0x208,0)) --is 1 when crouch key is held down
            crouch[i]=read_bit(player + 0x208,0)
            local obj_x_coord = read_float(player + 0x5C)
            local obj_y_coord = read_float(player + 0x60)
            local obj_z_coord = read_float(player + 0x64)
            for k,v in ipairs(bodies) do
                if (isPointInsideSphere(obj_x_coord, obj_y_coord, obj_z_coord, v[1], v[2], v[3], 1.5)) then
                    --print(tick_counter..','..bodies[k][7])
                    if (crouch[i]~=prev_crouch[i]) then
                        bodies[k][7]=bodies[k][7]+1
                    end
                    if (bodies[k][7]>=4 and bodies[k][6]==false) then
                        say_all(get_var(i,"$name")..' is t-bagging '..bodies[k][5])
                        say(i,get_var(i,"$name")..' You were teleported and healed!')
                        write_float(player + 0xE0,1)
                        
                        local r = math.random(1,#teleports)
                        local x = teleports[r][1]
                        local y = teleports[r][2]
                        local z = teleports[r][3]
                        local player_obj_id = read_dword(get_player(i) + 0x34)
                        TeleportPlayer(player_obj_id,x,y,z)
                        
                        
                        bodies[k][6]=true
                    end
                end
            end
            prev_crouch[i]=crouch[i]
        end
    end
    
    
    tick_counter=tick_counter+1
    if (tick_counter>=30) then
        tick_counter=0
        tmp_bodies={}
        for i, v in ipairs(bodies) do
      
            bodies[i][4]=bodies[i][4]+1
            if (v[4]<=30 and v[6]==false) then
                table.insert(tmp_bodies,v)
            end
            --print(bodies[i][4])
        end
        bodies=tmp_bodies
        
    end
end

function OnPlayerDeath(PlayerIndex, KillerIndex)
    local killer=tonumber(KillerIndex)
    local victim=tonumber(PlayerIndex)
    local player=get_dynamic_player(victim)
    if (player_alive(victim) and player~=0) then
        local obj_x_coord = read_float(player + 0x5C)
        local obj_y_coord = read_float(player + 0x60)
        local obj_z_coord = read_float(player + 0x64)
        --print(obj_x_coord..','..obj_y_coord..','..obj_z_coord)
        --bodies disappear after 30 seconds, 900 ticks
        table.insert(bodies,{obj_x_coord,obj_y_coord,obj_z_coord,0,get_var(victim,"$name"),false,0})
    end
end

function isPointInsideSphere(pointX, pointY, pointZ, sphereCenterX, sphereCenterY, sphereCenterZ, sphereRadius)
    local distance = math.sqrt((pointX - sphereCenterX)^2 + (pointY - sphereCenterY)^2 + (pointZ - sphereCenterZ)^2)
    return distance < sphereRadius
end

function TeleportPlayer(player, x, y, z)
    local player_object = get_object_memory(player)
    if get_object_memory(player) ~= 0 then
        write_vector3d(player_object + 0x5C, x, y, z + 0.2)
    end
end
