-- Block or Replace Object Creation by H® Shaft for SAPP
 
-- This script will:
-- Help you with replacing one object with another, or blocking it from being created
-- You could disable a weapon with execute_command("disable_object weapons\\plasma_cannon\\plasma_cannon") or in events using disable_object, BUT,
-- why not replace it with a weapon/vehicle/equipment you want?
 
-- Shown at the bottom (approx line 117) is a list of object types and tag names you can use in the OnObjectSpawn function (approx line 48)
 
-- sapp api version
api_version = "1.8.0.0"
-- do not edit --
game_started = false
 
function OnScriptLoad()
        register_callback(cb['EVENT_GAME_START'],"OnNewGame")
        register_callback(cb['EVENT_GAME_END'],"OnGameEnd")
        register_callback(cb['EVENT_SPAWN'],"OnPlayerSpawn")
        register_callback(cb['EVENT_OBJECT_SPAWN'],"OnObjectSpawn")
end
 
function OnScriptUnload() end
 
function OnNewGame()
        game_started = true
end    
       
function OnGameEnd()
        game_started = false
end
 
function OnPlayerSpawn(PlayerIndex)
        if game_started then   
                -- set grenade counts as they are set above
                if player_alive(PlayerIndex) == true then
                        local player_object = get_dynamic_player(PlayerIndex)
                        -- do stuff with biped or teams, etc
                end
        end    
end    
 
-- note: calls to this function must provide both arguments of obj_type & obj_name separated by comma
function get_tag_info(obj_type, obj_name)
        local tag_id = lookup_tag(obj_type, obj_name)
        return tag_id ~= 0 and read_dword(tag_id + 0xC) or nil
end    
       
function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
        if game_started then -- we only want to replace/block items if there is a game running
       
                -- Note: you cannot replace one object type for another, they must be the same "type."
                -- obj_types: vehi = vehicle, weap = weapon, bipd = biped, eqip = Equipment, proj = Projectiles
                -- obj_names: example: "weapons\\plasma grenade\\plasma grenade" is the obj_name (tag name) for the plasma grenade     
               
        
               
 
 
                -- mouse wrote this line
              --  if MapID == get_tag_info("weap", "weapons\\assault rifle\\assault rifle") then
             --           return true, get_tag_info("weap", "weapons\\sniper rifle\\sniper rifle")
             --   end    

                 -- mouse wrote this line
                if MapID == get_tag_info("weap", "weapons\\assault rifle\\assault rifle") then
                        return true, get_tag_info("weap", "weapons\\sniper rifle\\sniper rifle")
                end    

		 if MapID == get_tag_info("weap", "weapons\\flamethrower\\flamethrower") then
                        return true, get_tag_info("weap", "weapons\\rocket launcher\\rocket launcher")
                end   
 
                -- mouse wrote this line
               -- if MapID == get_tag_info("eqip", "powerups\\over shield") then
               --         return true, get_tag_info("eqip", "powerups\\health pack")
               -- end    
               
   
              
               
 
                -- end --
                return game_started
        end
end    
-- --------------------------- OBJECT TYPES AND TAG NAMES ---------------------------------------
-- Legend: | "OBJECT TYPE", "TAG NAME" -- COMMON NAME OR DESCRIPTION  Usage: ("Object Type", "Tag Name")
 
-- BIPD: Biped Object Types and Tag Names for tags available in stock 'Multiplayer' maps
        -- "bipd", "characters\\cyborg\\cyborg" -- Cyborg  (solo/campaign biped - green)
        -- "bipd", "characters\\cyborg_mp\\cyborg_mp" -- Multiplayer Cyborg -- NOTE!! If you block this biped, players won't spawn!            
 
-- EQIP: Equipment Object Types and Tag Names for tags available in stock 'Multiplayer' maps
        -- "eqip", "powerups\\active camouflage" -- Active Camouflage
        -- "eqip", "powerups\\health pack" -- Health Pack
        -- "eqip", "powerups\\over shield" -- Overshield
        -- "eqip", "weapons\\frag grenade\\frag grenade" -- Frag Grenade
        -- "eqip", "weapons\\plasma grenade\\plasma grenade" -- Plasma Grenade
       
-- WEAP: Weapon Object Types and Tag Names for tags available in stock 'Multiplayer' maps      
        -- "weap", "weapons\\assault rifle\\assault rifle" -- Assault Rifle
        -- "weap", "weapons\\ball\\ball" -- Oddball or Skull
        -- "weap", "weapons\\flag\\flag" -- Flag
        -- "weap", "weapons\\flamethrower\\flamethrower" -- Flamethrower
        -- "weap", "weapons\\needler\\mp_needler" -- Needler
        -- "weap", "weapons\\pistol\\pistol" -- Pistol
        -- "weap", "weapons\\plasma pistol\\plasma pistol" -- Plasma Pistol
        -- "weap", "weapons\\plasma rifle\\plasma rifle" -- Plasma Rifle
        -- "weap", "weapons\\plasma_cannon\\plasma_cannon" -- Fuel Rod Gun/Plasma Cannon
        -- "weap", "weapons\\rocket launcher\\rocket launcher" -- Rocket Launcher
        -- "weap", "weapons\\shotgun\\shotgun" -- Shotgun
        -- "weap", "weapons\\sniper rifle\\sniper rifle" -- Sniper Rifle
       
-- VEHI: Vehicle Object Types and Tag Names for tags available in stock 'Multiplayer' maps
        -- "vehi", "vehicles\\banshee\\banshee_mp" -- Banshee
        -- "vehi", "vehicles\\c gun turret\\c gun turret_mp" -- Covenant Turret
        -- "vehi", "vehicles\\ghost\\ghost_mp" -- Ghost
        -- "vehi", "vehicles\\rwarthog\\rwarthog" -- Rocket Warthog
        -- "vehi", "vehicles\\scorpion\\scorpion_mp" -- Scorpion
        -- "vehi", "vehicles\\warthog\\mp_warthog" -- Warthog
       
-- PROJ: Projectile Object Types and Tag Names for tags available in stock 'Multiplayer' maps
-- Note: All projectiles except for Frag and Plasma grenades are created 'client side', and will not sync visually: players will see the original projectile, not a replacement
 
        -- "proj", "vehicles\\banshee\\banshee bolt" -- Banshee Bolt
        -- "proj", "vehicles\\banshee\\mp_banshee fuel rod" -- Banshee Fuel Rod
        -- "proj", "vehicles\\c gun turret\\mp gun turret" -- Covenant Turret Bolt
        -- "proj", "vehicles\\ghost\\ghost bolt" -- Ghost Bolt
        -- "proj", "vehicles\\scorpion\\bullet" -- Scorpion Bullet
        -- "proj", "vehicles\\scorpion\\tank shell" -- Scorpion Shell
        -- "proj", "vehicles\\warthog\\bullet" -- Warthog Bullet
        -- "proj", "weapons\\assault rifle\\bullet" -- Assault Rifle Bullet
        -- "proj", "weapons\\flamethrower\\flame" -- Flamethrower Flame
        -- "proj", "weapons\\frag grenade\\frag grenade" -- Frag Grenade Projectile
        -- "proj", "weapons\\needler\\mp_needle" -- Needler Needle
        -- "proj", "weapons\\pistol\\bullet" -- Pistol Bullet
        -- "proj", "weapons\\plasma grenade\\plasma grenade" -- Plasma Grenade Projectile
        -- "proj", "weapons\\plasma pistol\\bolt" -- Plasma Pistol Bolt
        -- "proj", "weapons\\plasma rifle\\bolt" -- Plasma Rifle Bolt
        -- "proj", "weapons\\plasma rifle\\charged bolt" -- Plasma Pistol Charged Bolt
        -- "proj", "weapons\\plasma_cannon\\plasma_cannon" -- Fuel Rod Projectile
        -- "proj", "weapons\\rocket launcher\\rocket" -- Rocket Launcher Rocket
        -- "proj", "weapons\\shotgun\\pellet" -- Shotgun Pellet
        -- "proj", "weapons\\sniper rifle\\sniper bullet" -- Sniper Rifle Bullet
       
-- Note 2: Frag and Plasma grenade projectiles have a ZERO velocity     property, if you attempt replacement of them with a pistol bullet, the grenade projectile will land at your feet
 
-- Created by H® Shaft
-- Visit http://halorace.org/forum/index.php