-- ChatStats

-- Version 4 - An offical version - Edited By Mr.Reese

-- Version 3 changelog can be found at the end of this script

-- Version 4.0
-- Changed: All settings moved to tConfig table
-- Changed: 1/0 is now true/false
-- Changed: Some settings name
-- Added: CheckForFolder
-- Changed: tbl files now in ChatStats folder by default
-- Changed: Some API 2 updates
-- Changed: Code improvement for showing stats
-- Added: Ranking system

-- Version 4.1
-- Added: Rank in login msg, requested by Highlander Back
-- Added: Total in login msg
-- Fixed: Now sends login msg even when rightclick is disabled

-- Version 4.2
-- Fixed Bad SendToUser in UserConnected

tConfig = {
	Bot = SetMan.GetString(21), -- Name of Bot
	SendRC = true, -- Send UserCommands
	rcMenu = "ChatStats", -- Name of Menu
	Monthly = true, -- true/false = on/off
	Total = false,
	Rank = true,
	File = "chatstats.tbl", -- Add Total (char+words+post) in the chatstats, 1 = On  0 = Off
	Sortstats = 5, -- 2=posts / 3 = chars / 4 = words / 5 = Total
	-- Defaults back to posts if Total is disabeld but this is leaved on 5
	IgnoreTable = {
	-- 0=dont ignore/1=ignore
		["-=FakeKiller=-"] = true,
	},
	EnableChatStats = {
		[0] = true, -- Owner
		[1] = true, -- Master
		[2] = true, -- Op
		[3] = true, -- VIP
		[4] = true, -- Reg
		[-1] = false, -- UnReg
	},
	AllowedProfiles = {
		[0] = true, -- Owner
		[1] = false, -- Master
	},
	tRank = {
		["10"] = "Almost Newbie",
		["30"] = "Newbie",
		["60"] = "Almost Chatter",
		["100"] = "Chatter",
		["200"] = "Chatter Pro",
		["350"] = "Super Pro Chatter",
		["500"] = "Uncontrollable Chatter",
		["650"] = "Unstoppable Chatter",
		["800"] = "Godlike Chatter",
		["1000"] = "The Chat L0RD",
	}
}

Chatstats = {}
ChatstatsMonth = {}

---------- Warning! Do Not Edit! -----------
ChatStatsFileMonth = "chatstats - " ..os.date("%y-%m").. ".tbl"
---------- Warning! Do Not Edit! -----------

CheckForFolder = function()
	local wPath = string.gsub(Path,"/","\\")
	if os.execute('dir "'..wPath..'"') ~= 0 then
		os.execute('mkdir "'..wPath..'"')
	end
end

function CheckFile(File)
	local file = io.open(Path..File, "r")
	if file then
		file:close()
	else
		local file = io.open(Path..File, "w+")
		file:write()
		file:close()
	end
end

Path = Core.GetPtokaXPath().."scripts/ChatStats/"
CheckForFolder()

function OnStartup()
	Core.RegBot(tConfig.Bot,"ChatBot v4","",true)
	CheckFile(tConfig.File)
	dofile(Path..tConfig.File)
	if tConfig.Monthly then
		CheckFile(ChatStatsFileMonth)
		dofile(Path..ChatStatsFileMonth)
	end
	if not tConfig.Total then
		tConfig.SortStats = 2
	end
end

function UserConnected(user)
	if tConfig.EnableChatStats[user.iProfile] then
		if Chatstats[string.lower(user.sNick)] then
			Msg =  "Your ChatStats:  You made "..Chatstats[string.lower(user.sNick)]["post"].." posts in main used "..Chatstats[string.lower(user.sNick)]["chars"].." characters, and "..Chatstats[string.lower(user.sNick)]["words"].." words"
			if tConfig.Total then
				Msg = Msg..", with a total of " ..Chatstats[string.lower(user.sNick)]["tot"]
			end
			if tConfig.Rank then
				Msg = Msg..", and your rank is "..Chatstats[string.lower(user.sNick)]["rank"]
			end
			Core.SendToUser(user,"<" ..tConfig.Bot.. "> *****[ " ..Msg.. " ]*****")
		end
		if tConfig.SendRC then
			Core.SendToNick(user.sNick,"$UserCommand 1 3 DA-iiCT MAiN HuB\\"..tConfig.rcMenu.."\\ChatStats$<%[mynick]> !chatstats&#124;")
			if tConfig.Monthly then
				Core.SendToNick(user.sNick,"$UserCommand 1 3 DA-iiCT MAiN HuB\\"..tConfig.rcMenu.."\\ChatStats Year-Month$<%[mynick]> !chatmonth %[line:YY-MM]&#124;")
			end
			Core.SendToNick(user.sNick,"$UserCommand 1 3 DA-iiCT MAiN HuB\\"..tConfig.rcMenu.."\\My ChatStats$<%[mynick]> !mystats&#124;")
			if tConfig.AllowedProfiles[user.iProfile] then
				Core.SendToNick(user.sNick,"$UserCommand 1 3 DA-iiCT MAiN HuB\\"..tConfig.rcMenu.."\\Op menu\\Del Chatter$<%[mynick]> !delchatter %[line:Nick]&#124;")
				Core.SendToNick(user.sNick,"$UserCommand 1 3 DA-iiCT MAiN HuB\\"..tConfig.rcMenu.."\\Op Menu\\Lower Chatter$<%[mynick]> !lowerchatter %[line:Nick] %[line:New posts]&#124;")
				Core.SendToNick(user.sNick,"$UserCommand 1 3 DA-iiCT MAiN HuB\\"..tConfig.rcMenu.."\\Op Menu\\Clear Chat Stats$<%[mynick]> !clearstats&#124;")
			end
			Core.GetUserData(user,11)
			if user.bOperator then
				Core.SendToNick(user.sNick,"$UserCommand 1 3 DA-iiCT MAiN HuB\\"..tConfig.rcMenu.."\\Op Menu\\TopChatters in Main$<%[mynick]> !topchat&#124;")
			end
		end
	end
end

RegConnected = UserConnected
OpConnected = UserConnected

function OnExit()
	if isEmpty(Chatstats) then
	else
		saveTableToFile(Path..tConfig.File, Chatstats, "Chatstats")
		if tConfig.Monthly then
			saveTableToFile(Path..ChatStatsFileMonth, ChatstatsMonth, "ChatstatsMonth")
		end
	end
end

function IsCmd(str)
	return string.sub(str, 1, 1) == "!" or string.sub(str, 1, 1) == "?" or string.sub(str, 1, 1) == "+" or string.sub(str, 1, 1) == "$"
end

function ChatArrival(user, data)
	if tConfig.EnableChatStats[user.iProfile] then
		local s,e,cmd = string.find(data,"%b<>%s+(%S+)")
		if IsCmd(cmd) then
		elseif tConfig.IgnoreTable[string.lower(user.sNick)] then
		else
			local s,e,str = string.find(data, "%b<>%s+(.*)%|")
			updStats(string.lower(user.sNick), str)
		end
	end
	local data = string.sub(data,1, -2)
	local s,e,cmd = string.find(data, "%b<>%s+[%!%+%?](%S+)")
	if cmd then
		cmd = string.lower(cmd)
		local tCmds = {
		["mystats"] = function(user, data)
			if Chatstats[string.lower(user.sNick)] then
				Core.SendToUser(user,"<" ..tConfig.Bot.. "> *****[ Your Chat Stats:  You Made "..Chatstats[string.lower(user.sNick)]["post"].." Posts In Main Used "..Chatstats[string.lower(user.sNick)]["chars"].." Characters, And "..Chatstats[string.lower(user.sNick)]["words"].." Words ]*****")
			else
				Core.SendToUser(user,"<" ..tConfig.Bot.. "> *** No chat statics found!") 
			end
		end,
		["chatstats"] = function(user, data)
			Topic = "Current Top Chatters"
			Msg = Stats(Topic)
			Core.SendPmToUser(user,tConfig.Bot,Msg)
		end,
		["chatmonth"] = function(user,data)
			if tConfig.Monthly then
				local _,_,Y,M = string.find(data,"%b<>%s+%S+%s+(%d%d)%-(%d%d)")
				if Y and M then
					Topic = "Current Top Chatters of Month"
					Msg = Stats(Topic,Y,M)
					Core.SendPmToUser(user,tConfig.Bot,Msg)
				else
					Core.SendToUser(user,"<" ..tConfig.Bot.. "> Syntax: !chatmonth YY-MM i.e 07-02 for feb, 07")
				end
			else
				Core.SendToUser(user,"<" ..tConfig.Bot.. "> This function is disabled")
			end
		end,
		["topchat"] = function(user, data)
			Core.GetUserData(user,11)
			if user.bOperator then
				Topic = "Current Top Chatters"
				Msg = Stats(Topic)
				Core.SendToAll("<" ..tConfig.Bot.. "> " ..Msg)
			end
		end,
		["lowerchatter"] = function(user, data)
			if tConfig.AllowedProfiles[user.iProfile] then
				local s,e,name,chat = string.find(data, "%b<>%s+%S+%s+(%S+)%s+(%d+)")
				if name and chat then
					name = string.lower(name)
					if Chatstats[name] then
						chat = tonumber(chat)
						if Chatstats[name]["post"] <= chat then
							Core.SendToUser(user,"<" ..tConfig.Bot.. "> *** You can not raise the stats!")
						else
							local OldChat = Chatstats[name]["post"]
							Chatstats[name]["post"] = chat
							if tConfig.Rank then
								for posts,rank in pairs(tConfig.tRank) do
									-- Ugly fix, but if lowered bellow rank system, rank is removed
									if Chatstats[name]["post"] < tonumber(posts) then
										Chatstats[name]["rank"] = ""
										break
									-- Change rank
									elseif Chatstats[name]["post"] >= tonumber(posts) then
										Chatstats[name]["rank"] = rank
									end
								end
							end
							Core.SendToOps("<"..tConfig.Bot.. "> *** Chatstats posts for " ..name.. " has been lowered to " ..chat.. " from " ..OldChat.. " by " ..string.lower(user.sNick))
							saveTableToFile(Path..tConfig.File, Chatstats, "Chatstats")
						end
					else
						Core.SendToUser(user,"<" ..tConfig.Bot.. "> *** " ..name.. " is not in chatstats")
					end
				else
					Core.SendToUser(user,"<" ..tConfig.Bot.. "> *** Usage: !lowerchatter <name> <new posts>")
				end
			end
		end,
		["delchatter"] = function(user, data)
			if tConfig.AllowedProfiles[user.iProfile] then
				local s,e,name = string.find(data, "%b<>%s+%S+%s+(%S+)" )
				if name then
					if Chatstats[name] then
						Chatstats[name] = nil
						Core.SendToOps("<"..tConfig.Bot.. "> Chatstats from user "..name.." are now removed!")
						saveTableToFile(Path..tConfig.File, Chatstats, "Chatstats")
					else
						Core.SendToUser(user,"<" ..tConfig.Bot.. "> *** Chatstats from user "..name.." not found!")
					end
				else
					Core.SendToUser(user,"<" ..tConfig.Bot.. "> *** Usage: !delchatter <name>")
				end
			end
		end,
		["clearstats"] = function(user, data)
			if tConfig.AllowedProfiles[user.iProfile] then
				Chatstats = {}
				saveTableToFile(Path..tConfig.File, Chatstats, "Chatstats")
				Core.SendToAll("<" ..tConfig.Bot.. "> Chatstats are cleared by "..user.sNick)
			end
		end,
		}
		if tCmds[cmd] then
			return tCmds[cmd](user, data),true
		end
	end
end

function Stats(Topic,Y,M)
	if Chatstats then
		if Y and M then
			if loadfile("chatstats - " ..Y.. "-" ..M.. ".tbl") then
				loadTableFromFile("chatstats - " ..Y.. "-" ..M.. ".tbl")
				Table = ChatstatsMonth
			else
				return "That month has not been logged"
			end
		else
			Table = Chatstats
		end
		TCopy={}
		for i,v in pairs(Table) do
			table.insert(TCopy,{i,v.post,v.chars,v.words,v.tot,v.rank})
		end
		table.sort(TCopy,function(a,b) return (a[tConfig.Sortstats] > b[tConfig.Sortstats]) end)
		local chat = Topic..":\r\n\r\n"
		chat = chat.."\t -------------------------------------------------------------------------------------------------------------------\r\n"
		---- Build order list, part 1
		chat = chat.."\t Nr.\tPosts:\tChars:\tWords:"
		if tConfig.Total then
			chat = chat.."\tTotalt:"
		end
		chat = chat.."\tName:"
		if tConfig.Rank then
			chat = chat.."\t\tRank:"
		end
		chat = chat.."\r\n"
		----
		chat = chat.."\t -------------------------------------------------------------------------------------------------------------------\r\n"
		for i = 1,25 do 
			if TCopy[i] then
				---- Build order list, part 2
				chat = chat.."\t "..i..".\t "..TCopy[i][2].."\t "..TCopy[i][3].."\t "..TCopy[i][4] -- Nr, Posts,Chars,Words
				if tConfig.Total then
					chat = chat.."\t"..TCopy[i][5] -- Total
				end
				chat = chat.."\t"..TCopy[i][1] -- Name
				if tConfig.Rank then
					chat = chat.."\t\t"..TCopy[i][6] -- Rank
				end
				chat = chat.."\r\n"
				----
			end
		end
	return chat
	end
	TCopy={}
end


function updStats(nick, str)
	local tmp = Chatstats[nick] or {["post"]=0, ["chars"]=0, ["words"]=0, ["time"]=os.date("%x"),["tot"]=0,["rank"]=""}
	tmp["post"], tmp["chars"], tmp["words"], tmp["time"], tmp["tot"] = tmp["post"]+1, tmp["chars"]+string.len(str), tmp["words"]+cntargs(str,"(%a+)"), os.date("%x"), tmp["tot"]+string.len(str)+cntargs(str,"(%a+)")+1
	if tConfig.Rank then
		for posts,rank in pairs(tConfig.tRank) do
			if tmp["post"] == tonumber(posts) then
				tmp["rank"] = rank
				Core.SendToAll("<" ..tConfig.Bot.. "> " ..nick.. " is now at rank:" ..rank)
			end
		end
	end
	Chatstats[nick] = tmp
	saveTableToFile(Path..tConfig.File, Chatstats, "Chatstats")
	if tConfig.Monthly then
		local tmpM = ChatstatsMonth[nick] or {["post"]=0, ["chars"]=0, ["words"]=0, ["time"]=os.date("%x"),["tot"]=0,["rank"]=""}
		tmpM["post"], tmpM["chars"], tmpM["words"], tmpM["time"], tmpM["tot"] = tmpM["post"]+1, tmpM["chars"]+string.len(str), tmpM["words"]+cntargs(str,"(%a+)"), os.date("%x"), tmpM["tot"]+string.len(str)+cntargs(str,"(%a+)")+1
		if tConfig.Rank then
			for posts,rank in pairs(tConfig.tRank) do
				if tmpM["post"] == tonumber(posts) then
					tmpM["rank"] = rank
				end
			end
		end
		ChatstatsMonth[nick] = tmpM
		saveTableToFile(Path..ChatStatsFileMonth,ChatstatsMonth,"ChatstatsMonth")
	end
end


function cntargs(str, rule)
	local s,n = string.gsub(str, rule, "")
	return n
end

----------------------------------------------
-- load & save Tables
----------------------------------------------
function Serialize(tTable, sTableName, sTab)
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

-----------------------------------------------------------
function saveTableToFile(file, table, tablename)
	local handle = io.open(file,"w+")
	handle:write(Serialize(table, tablename))
	handle:flush()
	handle:close()
end
-----------------------------------------------------------
function loadTableFromFile(file)
	local f = io.open(file)
	if f then
		local r = f:read("*a")
		f:flush()
		f:close()
		local func,err = loadstring(r)
		if func then x,err = pcall(func) end
	end
end

-------------table checker by herodes
--- for an associative table, like ["smth"] = "smth else",
function isEmpty(t)
	for i,v in pairs(t) do
		return false;
	end
	return true;
end;