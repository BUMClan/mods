-- Medic by H� Shaft for SAPP
 
-- Allows you to setup a call for a medic (player request to be healed), and a limit per game that each player can call for medic
-- Players type "Medic" in chat, 6 seconds later they are healed if they are alive and injured.
-- Each time players call for a medic, they are told how many medic calls they have remaining, and if they have reached the limit (hp_limit below)
-- all players are notified: "H� Shaft called for a MEDIC" - which helps other players to know they can type medic too.
 
-- Note: the delay of 6 seconds is intentional to prevent the shield recharge beep from continuing/getting stuck, and to prevent players using it in the middle of a battle
 
hp_limit = 5  -- Number of times a player can call MEDIC during the current game.
 
-- sapp api version
api_version = "1.8.0.0"
 
-- don't edit --
hp_player = {}
game_started = false
 
function OnScriptLoad()
        register_callback(cb['EVENT_GAME_START'],"OnNewGame")
        register_callback(cb['EVENT_GAME_END'],"OnGameEnd")
        register_callback(cb['EVENT_JOIN'],"OnPlayerJoin")
        register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
end
 
function OnScriptUnload() end
 
function OnPlayerJoin(PlayerIndex)
        if player_present(PlayerIndex) then
                hp_player[PlayerIndex] = 0     
        end
end
 
function OnNewGame()
        game_started = true
        for i = 1,16 do
                if player_present(i) then
                        hp_player[i] = 0
                end
        end
end
 
function OnGameEnd()
        game_started = false
        hp_player = {}
end
 
function OnPlayerChat(PlayerIndex, Message)
        local response = nil
        local name = get_var(PlayerIndex,"$name")
        local Message = string.lower(Message)
       
                if (Message == "dr") or (Message == "dr?")then
                        response = false
                        if hp_player[PlayerIndex] < hp_limit then
                                if game_started then
                                        if player_alive(PlayerIndex) then
                                                local obj_health = tonumber(get_var(PlayerIndex, "$hp"))
                                                if obj_health < 1 then
                                                        hp_player[PlayerIndex] = hp_player[PlayerIndex] + 1
                                                        timer(7000, "ApplyHP", PlayerIndex)
                                                        say(PlayerIndex, "" ..name.. " You will be healed in 7 seconds. You have " .. hp_limit - hp_player[PlayerIndex] .. " Dr calls remaining.")
                                                        say_all(string.format("%s called for a Dr. ", tostring(name)))                                                      
                                                elseif obj_health == 1 then
                                                        say(PlayerIndex, "You are already at full health! Dr cancelled.")
                                                end
       
                                        end    
                                end
                        else
                                say(PlayerIndex, "You have reached the limit of " .. hp_limit .. " Dr calls per game.")     
                        end
                end
       
        return response
end
 
function ApplyHP(PlayerIndex)
        if player_present(PlayerIndex) then
                if game_started then
                        if player_alive(PlayerIndex) then
                                local name = get_var(PlayerIndex,"$name")
                                local player_object = get_dynamic_player(PlayerIndex)
                                local obj_health = tonumber(get_var(PlayerIndex, "$hp"))
                                if obj_health < 1 then
                                        write_float(player_object + 0xE0, 1)
                                        say(PlayerIndex, "" ..name.. " You were healed!")                                                                                    
                                else
                                        say(PlayerIndex, "You are already at full health! Dr cancelled.")
                                end
                        else
                                say(PlayerIndex, "You are dead, a healthpack won't help you. Dr cancelled.")
                        end
                end    
        end    
        return false
end
 
-- Created by H� Shaft
-- Visit http://halorace.org/forum/index.php