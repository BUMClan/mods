multiDNS = "yes"

DNS_1 = "s1.master.hosthpc.com"
DNS_2 = "halo.macgamingmods.com"

DNSswitch = 0

function applyDNS()
	if DNSswitch == 1 then
	execute_command_sequence("DNS \"" .. DNS_1 .. "\";sv_public 1")
	DNSswitch = 2
	return true
	end
	if DNSswitch == 2 then
	execute_command_sequence("DNS \"" .. DNS_2 .. "\";sv_public 1")
	DNSswitch = 1
	return true
	end
	if DNSswitch == 0 then
	return false
	end
	return false
end

api_version = "1.9.0.0"
function OnScriptLoad()
	if multiDNS == "yes" then
	DNSswitch = 1
	timer(40000,"applyDNS")
	else
	execute_command("dns " .. DNS_2)
	end
end
