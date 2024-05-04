api_version = "1.12.0.0"
--config
teleports_per_life=2
teleports_per_game=500

--end config

teleports={{121.26,-182.88,6.68},{114.68,-129.18,1.45},{62.42,-178.38,4.35},{62.06,-155.40,5.96},{46.63,-151.09,4.24},{65.11,-120.67,0.15},{98.12,-110.29,4.27},{103.93,-108.83,1.74},{96.57,-91.43,4.91},{68.64,-94.76,1.75},{23.30,-108.55,2.39},{68.33,-60.58,3.71},{69.91,-88.07,5.67},{19.49,-60.83,4.08}}
teleportCounter={}
teleportLifeCounter={}
player_weapon={}
player_flashlight_count={}
function OnScriptLoad()
    math.randomseed(os.time())
    register_callback(cb["EVENT_TICK"],"OnTick")
    register_callback(cb['EVENT_WEAPON_PICKUP'],"OnWeaponPickup")
	register_callback(cb['EVENT_WEAPON_DROP'],"OnWeaponDrop")
    register_callback(cb['EVENT_JOIN'],"OnJoin")
    register_callback(cb['EVENT_DIE'], "OnPlayerDeath")
    for i=1,16,1 do
		teleportCounter[i]=0
		teleportLifeCounter[i]=0
		player_weapon[i]=0
        player_flashlight_count[i]=0
	end
end

function OnPlayerDeath(PlayerIndex)
pi=tonumber(PlayerIndex)
teleportLifeCounter[pi]=0
player_weapon[pi]=0
player_flashlight_count[pi]=0
end

function OnJoin(PlayerIndex)
        pi=tonumber(PlayerIndex)
        
        player_weapon[pi]=0
		teleportCounter[pi]=0
		teleportLifeCounter[pi]=0
		timer(5000,"sayToPlayer",PlayerIndex,"Use the flashlight 2x to teleport to a random location")
   			timer(5000,"sayToPlayer",PlayerIndex,"Usa la linterna 2x para teletransportarte al azar")
		timer(10000,"sayToPlayer",PlayerIndex,"Teleport to the top of the map from inside the base")
 			timer(10000,"sayToPlayer",PlayerIndex,"Teletransportarse a la parte superior del mapa en la base")
		timer(15000,"sayToPlayer",PlayerIndex,"Crouch in the banshee for turbo boost")
  			timer(15000,"sayToPlayer",PlayerIndex,"Agacharse en la banshee para turbo")
 		 timer(20000,"sayToPlayer",PlayerIndex,"1 point per kill, 25 points per flag, 500 to win")
  			timer(20000,"sayToPlayer",PlayerIndex,"1 punto por muerte, 25 puntos por bandera, 500 para ganar")
        timer(25000,"sayToPlayer",PlayerIndex,"No turbo with the flag")
  			timer(25000,"sayToPlayer",PlayerIndex,"No turbo con la bandera")
        timer(30000,"sayToPlayer",PlayerIndex,"Your first 3 frag grenades are tank shells")
  			timer(30000,"sayToPlayer",PlayerIndex,"Tus primeras 3 granadas de fragmentacion son proyectiles de tanque")
end


function OnWeaponDrop(PlayerIndex,Index)
pi=tonumber(PlayerIndex)
if(Index=="3") then
	player_weapon[pi]=0
end

end

function OnWeaponPickup(PlayerIndex,Index,Type)
pi=tonumber(PlayerIndex)
if(Index=="3") then
	player_weapon[pi]=1
end
end

function OnTick()
    for i=1,16,1 do
        if(player_alive(i)) then
                local player = get_dynamic_player(i)
                if (read_bit(player + 0x208,4)==1) then
                    player_flashlight_count[i]=player_flashlight_count[i]+1
                end
                if (player_flashlight_count[i]==2) then
                    local vehicle=read_dword(player + 0x11C)
                    if (vehicle ~= 0xFFFFFFFF) then
                        say(i,"You can't teleport in a vehicle!")
                    else
                        if (player_weapon[i]==1) then
                            say(i,"You can't teleport with the flag!")
                        else
                            if (teleportLifeCounter[i]<teleports_per_life and teleportCounter[i]<teleports_per_game) then
                            local r = math.random(1,#teleports)
                            local x = teleports[r][1]
                            local y = teleports[r][2]
                            local z = teleports[r][3]
                            local player_obj_id = read_dword(get_player(i) + 0x34)
                            TeleportPlayer(player_obj_id,x,y,z)
                            teleportCounter[i]=teleportCounter[i]+1
                            teleportLifeCounter[i]=teleportLifeCounter[i]+1
                            execute_command("say "..i.." '("..teleportLifeCounter[i].."/"..teleports_per_life..") teleports used this life and ("..teleportCounter[i].."/"..teleports_per_game..") this game")
                            else 
                                execute_command("say "..i.." '("..teleportLifeCounter[i].."/"..teleports_per_life..") teleports used this life and ("..teleportCounter[i].."/"..teleports_per_game..") this game")
                            end
                        end
                    end
                    player_flashlight_count[i]=0
                end
        end
    end
end

function TeleportPlayer(player, x, y, z)
    local player_object = get_object_memory(player)
    if get_object_memory(player) ~= 0 then
        write_vector3d(player_object + 0x5C, x, y, z + 0.2)
    end
end

function sayToPlayer(pi,mess)
	pi=tonumber(pi)
	execute_command("say "..pi.." '"..mess.."'")
end
