-- Relies on pirate's hlm.lua library which isn't included in the files
-- See: https://opencarnage.net/index.php?/topic/8314-accurate-camera-position-or-camera_track-and-you/#comment-101773

api_version = "1.12.0.0"
tank_shells={}
local hlm
function OnScriptLoad()


    hlm = require "hlm"  --Pirate's math library
    register_callback(cb['EVENT_OBJECT_SPAWN'],"OnObjectSpawn")
    register_callback(cb['EVENT_PRESPAWN'],"OnPreSpawn")
    tank_shells={}
    for i=1,16,1 do
        tank_shells[i]=3
    end
end

function OnPreSpawn(PlayerIndex)
    local i=tonumber(PlayerIndex)
    tank_shells[i]=3
end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    local i=PlayerIndex

    if (player_alive(i) and tank_shells[i]>0) then
        if MapID == get_tag_info("proj", "weapons\\frag grenade\\frag grenade") then
            local m_player=get_player(i)
            local player=get_dynamic_player(i)

            if (m_player~=nil) then
                 local camera = hlm.get_unit_firing_camera(player, {desired_aim=true})
                    --print(camera.translation)
                local camera_x=camera.translation[1]
                local camera_y=camera.translation[2]
                local camera_z=camera.translation[3]
                local player_obj_id=-1
                local player_obj_id = read_dword(m_player + 0x34)

                local m_object=get_object_memory(player_obj_id)


                local unit_x_aim = read_float(m_object + 0x23C) -- Confirmed.
                local unit_y_aim = read_float(m_object + 0x240) -- Confirmed.
                local unit_z_aim = read_float(m_object + 0x244) -- Confirmed.
                local ten_divided_by_3=10/3
                local x_vel=unit_x_aim*ten_divided_by_3
                local y_vel=unit_y_aim*ten_divided_by_3
                local z_vel=unit_z_aim*ten_divided_by_3

                --local tank_shell=spawn_object("proj", "vehicles\\scorpion\\tank shell",camera_x+x_vel, camera_y+y_vel, camera_z+z_vel)
                local tank_shell=spawn_object("proj", "vehicles\\scorpion\\tank shell",camera_x+unit_x_aim, camera_y+unit_y_aim, camera_z+unit_z_aim)

                local tank_shell_obj=get_object_memory(tank_shell)
                if (tank_shell_obj~=0) then

                    write_float(tank_shell_obj + 0x68,x_vel) -- From OS.
                    write_float(tank_shell_obj + 0x6C,y_vel) -- From OS.
                    write_float(tank_shell_obj + 0x70,z_vel)

                    if (player_obj_id~=-1) then
                        write_dword(tank_shell_obj + 0xC4,player_obj_id) --obj_owner_obj_id
                    end
                end
                tank_shells[i]=tank_shells[i]-1
                return false
            end
        end
    end
end

function get_tag_info(obj_type, obj_name)
        local tag_id = lookup_tag(obj_type, obj_name)
        return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end
