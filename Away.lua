-- Awayer
-- EDITED A LOT OF BUGS by bofh
-- script passed on as legacy to n!ghtf0x™ 


-- Allows a users to set away mode with an message
-- Message can be Optional with/without an default message
-- Message can be forced without default message
-- Sends a message that user is away if pm is recived
-- Away user can be listed
-- Return user on back command or chat in main
-- Users can update there away message
-- Informs how long user been away upon return
-- Sends rightclick to userlist and hubtab

tConfig = {
	Bot = SetMan.GetString(21), -- Bots name
	SaveToFile = true, -- Save Away table to a file
	File = "Away.msg", -- The file to save to
	ForceMsg = false, -- User must enter an away message, UseDefaultMsg can not be true if this is
	UseDefaultMsg = true, -- Use DefaultMsg if user don't enter a message
	DefaultMsg = "Will be back soon ....", -- The default msg
	SilentUpdate = false, -- Set to false if script should tell all that user updated his/hers message
	Menu = "Go Away !", -- Name of the RightClick menu
	HubOwner = "Mr.Reese",
	GetAways = { -- What profiles are allowed to list the away users
		[0] = true, --Owner
		[1] = true, -- Master
		[2] = true, -- Op
		[3] = true, -- Vip
		[4] = true, -- Reg
		[-1] = false, -- Unreg
	},
	UserProfiles = {
	[0] = "Owner",
	[1] = "Master",
	[2] = "Operator",
	[3] = "VIP",
	[4] = "Reg",
	[-1] = "Unreg",
	}
}

Path = Core.GetPtokaXPath().."scripts/"

function OnStartup()
	if tConfig.SaveToFile then
		local file = io.open(Path..tConfig.File)
		if file then
			file:close()
		else
			local file = io.open(Path..tConfig.File,"w+")
			file:write("Away = {\n}")
			file:close()
		end
		LoadFromFile(Path..tConfig.File)
	else
		Away = {}
	end
	if tConfig.ForceMsg and tConfig.UseDefaultMsg then
		GoOff = math.random(1,2)
		Off = { "ForceMsg","UseDefaultMsg"}
		tConfig[(Off[GoOff])] = false
		Msg = "<" ..tConfig.Bot.. "> ForceMsg and UseDefaultMsg is both true in Awayer's Config. Only one of thoose can be on. " ..Off[GoOff].. " was randomly choose to be disabled."
		if Core.GetUser(tConfig.HubOwner) then
			Core.SendToNick(tConfig.HubOwner,Msg.." Please fix this error as soon as posible.")
		else
			Core.SendToOps(Msg.." Please inform the the HubOwner about this as as soon as posible.")
		end
	end
end

function UserConnected(user)
	Core.GetUserData(user,12)
	if user.bUserCommand then
		RightClick(user)
	end
end

RegConnected = UserConnected
OpConnected = UserConnected

function RightClick(user)
	local tRC = {
		["away"] = {"Go Away","%[line:Message]"},
		["back"] = {"Return from away",""},
		["getaways"] = {"List away users",""},
		["updateaway"] = {"Updated your away message","%[line:Message]"},
	}
	for cmd,cd in pairs(tRC) do
		Core.SendToUser(user,"$UserCommand 1 3 DA-iiCT MAiN HuB\\"..tConfig.Menu.."\\"..cd[1].." $<%[mynick]> !"..cmd.." " ..cd[2].."&#124;|")
	end
end

function ChatArrival(user,data)
	local data = data:sub(1,-2)
	local s,e,cmd = data:find("%b<>%s+%p(%S+)")
	if cmd then
		tCmds = {
			["away"] = function(user,data)
				local s,e,msg = data:find("%b<>%s+%S+%s+(.*)")
				if Away[user.sNick] then
					Core.SendToUser(user,"<" ..tConfig.Bot.. "> You are already away")
				else
					Away[user.sNick] = {}
					Away[user.sNick]["Time"] = os.date("*t") -- Add time to table
					if not msg then -- If we don't have msg
						if tConfig.ForceMsg then -- Check if we must have
							Core.SendToUser(user,"<" ..tConfig.Bot.. "> An away msg is required")
							Away[user.sNick] = nil -- Clear table
							return true
						elseif tConfig.UseDefaultMsg then -- If we don't need msg and script should add it 
							Away[user.sNick]["Msg"] = tConfig.DefaultMsg -- Add default msg to table
							msg = " and left the following message: " ..tConfig.DefaultMsg
						end
					else -- if we got msg
						Away[user.sNick]["Msg"] = msg -- Add msg to table
						msg = " and left the following message: " ..msg
					end
					if tConfig.SaveToFile then
						SaveToFile(Path..tConfig.File,Away,"Away")
					end
							if user.sNick == "Mr.Reese" or user.sNick == "ArchAngel™" then
								Core.SendToAll("<" ..tConfig.Bot.. "> Lord "..user.sNick.. " went away at " ..os.date("%X")..(msg or "!"))
							else
								Core.SendToAll("<" ..tConfig.Bot.. "> "..tConfig.UserProfiles[user.iProfile].." "..user.sNick.. " went away at " ..os.date("%X")..(msg or "!"))
							end
				end
			end,
			["updateaway"] = function(user,data)
				if Away[user.sNick] then
					local s,e,msg = data:find("%b<>%s+%S+%s+(.*)")
					if msg then
						Away[user.sNick]["Msg"] = msg
						if not tConfig.SilentUpdate then
							Core.SendToAll("<" ..tConfig.Bot.. "> "..tConfig.UserProfiles[user.iProfile].." "..user.sNick.. " just updated his/hers awy message to: "..msg)
						end
						if tConfig.SaveToFile then
							SaveToFile(Path..tConfig.File,Away,"Away")
						end
					else
						Core.SendToUser(user,"You need to enter a message to update your away status")
					end
				else
					Core.SendToUser(user,"You are not away")
				end
			end,
			["back"] = function(user,data)
				if Away[user.sNick] then
					Return(user)
				else
					Core.SendToUser(user,"<" ..tConfig.Bot.. "> You are not away")
				end
			end,
			["getaways"] = function(user,data)
				if tConfig.GetAways[user.iProfile] then
					Msg = "\r\n\t" ..string.rep("-",50).. " Away Users " ..string.rep("-",50).."\r\n"
					Msg = Msg.."\tNr\tUser\t\tTime away\t\tMessage\r\n"
					Msg = Msg.."\t"..string.rep("-",121).."\r\n"
					c = 0
					for sNick,_ in pairs(Away) do
						c = c + 1
						Time = TimeConvert(os.time(Away[sNick]["Time"]))
						Msg = Msg.. "\t" ..c..".\t" ..sNick.. "\t\t" ..Time.. "\t" ..(Away[sNick]["Msg"] or "").. "\r\n"
					end
					Msg = Msg.."\r\n\tTotalt users away: "..c
					Core.SendToUser(user,"<" ..tConfig.Bot.. "> "..Msg)
				else
					Core.SendToUser(user,"<" ..tConfig.Bot.. "> This command is offlimit for you")
				end
			end,
		}
		if tCmds[cmd] then
			return tCmds[cmd](user,data),true
		end
	end
	if Away[user.sNick] then
		Return(user)
	end
end

function ToArrival(user,data)
	local data = data:sub(1,-2)
	local s,e,To = data:find("$To:%s+(%S+)")
	if Away[To] then
		if Away[To]["Msg"] then
			msg = ", and left the following message: " ..Away[To]["Msg"]
		end
		Core.SendPmToUser(user,To,"Automated Message: " ..To.." is currently in away mode" ..(msg or "."))
	end
end

function Return(user)
	Time = TimeConvert(os.time(Away[user.sNick]["Time"]))
	Away[user.sNick] = nil
	if tConfig.SaveToFile then
		SaveToFile(Path..tConfig.File,Away,"Away")
	end
	Core.SendToAll("<" ..tConfig.Bot.. "> "..tConfig.UserProfiles[user.iProfile].." "..user.sNick.. " returned at " ..os.date("%X").. " after beeing away for " ..Time)
end

Serialize = function(tTable, sTableName, sTab)
	assert(tTable, "tTable equals nil");
	assert(sTableName, "sTableName equals nil");
	assert(type(tTable) == "table", "tTable must be a table!");
	assert(type(sTableName) == "string", "sTableName must be a string!");
	sTab = sTab or "";
	sTmp = ""
	sTmp = sTmp..sTab..sTableName.." = {\n"
	for key, value in pairs(tTable) do
		local sKey = (type(key) == "string") and string.format("[%q]",key) or string.format("[%d]",key);
		if(type(value) == "table") then
			sTmp = sTmp..Serialize(value, sKey, sTab.."\t");
		else
			local sValue = (type(value) == "string") and string.format("%q",value) or tostring(value);
			sTmp = sTmp..sTab.."\t"..sKey.." = "..sValue
		end
		sTmp = sTmp..",\n"
	end
	sTmp = sTmp..sTab.."}"
	return sTmp
end

SaveToFile = function(file , table , tablename)
	local handle = io.open(file,"w+")
	handle:write(Serialize(table, tablename))
	handle:flush()
	handle:close()
end

LoadFromFile = function(filename)
	local f = io.open(filename)
	if f then
		local r = f:read("*a")
		f:flush()
		f:close()
		local func,err = loadstring(r)
		if func then x,err = pcall(func) end
	end
end

function TimeConvert(time)

	if time then
		local s,x,n = "",0,os.time()
		local tab = {{31556926,"year"},{2592000,"month"},{604800,"week"},
		{86400,"day"},{3600,"hour"},{60,"minute"},{1,"second"}}
		if time > 0 then
			if time < 2145876659 then
				if n > time then
					time = n - time
				elseif n < time then
					time = time - n
				end
				for i,v in ipairs(tab) do
					if time > v[1] then
						x = math.floor(time/v[1])
						if x > 1 then v[2] = v[2].."s" end
						if x > 0 then
							s = s..x.." "..v[2]..", "
							time = time-x*v[1]
						end
					end
				end
				collectgarbage("collect")
				return s:sub(1,-3)
			else
				return "Invalid date or time supplied. [must be pre 12/31/2037]"
			end
		else
			return "Invalid date or time supplied. [must be post 01/01/1970]"
		end
	else
		return "Invalid date or time supplied."
	end
end