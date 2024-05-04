api_version = "1.12.0.0"
--config--

--use /botscore [player index] to view botscore
--use /stopbotscore to stop botscore messages

-- Minimum admin level required to execute /command. (-1 for all players)
PERMISSION_LEVEL = 2

--setting to false will print to the chat
--setting to true will print to the halo console
print_to_halo_console=true

--end config--
admin_botscore={}
last_score={}
score_before={}
function OnScriptLoad()
    
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
	register_callback(cb['EVENT_JOIN'], "OnPlayerConnect")
	register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_TICK'], "OnTick")
    
    register_callback(cb['EVENT_SNAP'], "OnSnap")
    
 
	for i=1,16,1 do
		admin_botscore[i]=-1
	end
    
    for i=1,16,1 do
		last_score[i]=0
	end
    
     for i=1,16,1 do
		score_before[i]=0
	 end
	
end



function OnScriptUnload()
   
end

function OnSnap(PlayerIndex,SnapScore)
    sayToAdmins(get_var(PlayerIndex,"$name").." snapped "..SnapScore)
end

function OnPlayerLeave(PlayerIndex)
    pi=tonumber(PlayerIndex)
    admin_botscore[pi]=-1
    last_score[pi]=0
    score_before[pi]=0
    
    for i=1,16,1 do
        if (admin_botscore[i]==pi) then
            admin_botscore[i]=-1
        end
    end

end

function OnPlayerConnect(PlayerIndex)
    pi=tonumber(PlayerIndex)
    admin_botscore[pi]=-1
    last_score[pi]=0
    score_before[pi]=0
    
     for i=1,16,1 do
        if (admin_botscore[i]==pi) then
            admin_botscore[i]=-1
        end
    end
end

function OnTick()
        --code responsible for monitoring with /botscore
        for i=1,16,1 do
            if (admin_botscore[i]~=-1) then
                if (player_present(i)) then
                    if tonumber(get_var(i, "$lvl")) >= PERMISSION_LEVEL then
                        if (player_present(admin_botscore[i])) then
                                local name=get_var(admin_botscore[i],"$name")
                                local botscore=get_var(admin_botscore[i],"$botscore")
                                if (print_to_halo_console==true) then
                                    for j=1,25,1 do
                                        rprint(i,' ')
                                    end
                                    rprint(i,name..": "..botscore)
                                else
                                    say(i,name..": "..botscore)
                                end
                        end
                    end
                end
            end
        end
        --code responsible for notifcations
        for i=1,16,1 do
            if (player_present(i)) then
                    local botscore=tonumber(get_var(i,"$botscore"))
                    score_before[i]=last_score[i]
                    for j=39,0,-1 do
                        if (botscore>j*500) then
                            last_score[i]=j*500
                            break;
                        end
                    end
                    
                    if (last_score[i]>score_before[i]) then
                            local name=get_var(i,"$name")
                            local botscore=get_var(i,"$botscore")
                            sayToAdmins(name.." exceeded "..last_score[i].." botscore ("..botscore..")")
                    end
            end
        end
end

function OnServerCommand(PlayerIndex, Command)
   
        
        local t = tokenizestring(Command)
        if t[1] ~= nil then
            if string.lower(t[1]) == "botscore" then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= PERMISSION_LEVEL then
                    --print('botscore')
                    if (t[2]~=nil) then
                        if (tonumber(t[2])>=1 and tonumber(t[2])<=16) then
                            show_bot_index=tonumber(t[2])
                            if (player_present(show_bot_index)) then
                                pi=tonumber(PlayerIndex)
                                admin_botscore[pi]=show_bot_index
                            else
                                say(PlayerIndex,"Player index not present")
                            end
                        end
                    end
                    return false
                end
            end
        end
        
        if t[1] ~= nil then
            if string.lower(t[1]) == "stopbotscore" then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= PERMISSION_LEVEL then
                    pi=tonumber(PlayerIndex)
                    if (admin_botscore[pi]~=-1) then
                        admin_botscore[pi]=-1  
                    end
                    return false
                end
            end
        end
end


function sayToAdmins(Message)
    for i=1,16,1 do
        if tonumber(get_var(i, "$lvl")) >= PERMISSION_LEVEL then
            say(i,Message)
        end
    end
end




function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = { };
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
