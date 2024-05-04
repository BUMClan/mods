-- Hit-Scan (Projectile Velocity Modification)
-- SAPP Compatability: 9.8+
-- Script by: Skylace aka Devieth
-- Discord: https://discord.gg/Mxmuxgm
 
api_version = "1.10.0.0"
 
function OnScriptLoad()
    safe_read(true) safe_write(true)
    register_callback(cb['EVENT_GAME_START'], "OnMapLoad")
end
 
function OnMapLoad()
    first = true
    EnableHitscan()
end
 
function OnScriptUnload() end
 
function EnableHitscan()
    local tag_address = read_dword(0x40440000)
    local tag_count = read_dword(0x4044000C)
    timer(180, "print_wait", "\n\n --[[ Hitscan Edits Started. ]]--")
    for i=0,tag_count-1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = string.reverse(string.sub(read_string(tag),1,4))
        if tag_class == "proj" then
            local tag_data = read_dword(tag + 0x14)
            local t = tokenizestring(read_float(tag_data + 0x1e8), ".")
            if string.sub(tag_name,1,4) == "weap" then
                if t[1] == "3" or t[1] == "10" then -- Intiger values of bullet speed.
                    write_float(tag_data + 0x1e8, 40)
                    timer(200, "print_wait", "Edited Slow_proj: '" .. tag_name) -- ARs, shotguns, and pistols.
                elseif t[1] == "33" then
                    write_float(tag_data + 0x1e8, 1000)
                    timer(225, "print_wait", "Edited Fast_proj: '" .. tag_name) -- Snipers (hopefully works with beam rifles on custom maps.)
                else
                    if t[1] == "40" or t[1] == "1000" then
                        timer(250, "print_wait", "Already edited: ".. tag_name) -- If the projectile speed has already been modified.
                    else
                        timer(300, "print_wait", "Cannot be edited: " .. tag_name) -- If the projectile cannot be edited (non-bullet weapons.)
                    end
                end
            elseif string.sub(tag_name,1,4) == "vehi" then
                if t[1] == "10" then -- Tank bullet.
                    write_float(tag_data + 0x1e8, 40)
                    timer(200, "print_wait", "Edited '" .. tag_name .. "' as a low speed projectile.")
                else
                    if t[1] == "40" then
                        timer(275, "print_wait", "Already edited: ".. tag_name)
                    else
                        timer(325, "print_wait", "Cannot be edited: " .. tag_name)
                    end
                end
            end
        end
    end
    timer(350, "print_wait", "--[[ Hitscan Edits Finished. ]]--\n")
end
 
function print_wait(msg) -- Used to slow down the printing otherwize the script loads so fast when starting a server it gets scrambled.
    print(msg)
end
 
function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end