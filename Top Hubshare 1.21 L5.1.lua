--[[

	Top Hubshare 1.21 LUA 5.1x [Strict] [API 1 & 2]

	By Mutor	01/30/09

	Requested by monster

	Caches top hub shares with date
	-Displays in main chat on timer
	-Option for date format
	-Option for custom message with replaceable params.
	-Option to display only on new [greater] hub share

	+Changes from 1.0	01/31/09
		+Added support for API 1

	+Changes from 1.1	02/16/09
		+Added option for message users at login. Requested by WhiteKnuckles
		+Added user count to table/message variables
		+Will update TopShare table of existing file with new value

	+Changes from 1.2	02/26/09
		+Added permission by profile, requested by quicky2g 

]]

Cfg = {
-- "Botname" ["" = hub bot]
Bot = "T-A-R-S",
-- Admins nick for status / error messages
OpNick = "Ash",
-- Message file path/name
File = "TopHubShare11.dat",
-- Timer interval [in minutes]
Interval = 300,
-- Display only on new top hub share value true/false [false = show on every interval]
JustNew = true,
-- Send share message to all connected users?
MsgAll = true,
-- Set profiles [Used when: MsgAll = false]
-- [#] = true/false, (true = Enable script messages / false = Disable script messages)
Profiles  = {
	[-1] = false,	--Unregistered User
	[0] = true,	--Master
	[1] = true,	--Operator
	[2] = true,	--Vip
	[3] = true,	--Registered User
	},
-- Share message, Replacements: [Hub] = Hubname, [Date] = Date of top share, [Share] = top share value, [Users] = User count
ShareMsg = "\r\n\r\n\t[Hub] 's Largest Total Hub Share To Date Is "..
	"[Share] This share was reached on [Date] with [Users] users.\r\n\r\n",
-- Date Format, see: os.date() in Lua manual nil = local defaults
DateFmt = nil,
-- Maximum number of top share values to cache?
MaxCache = 20,
-- Send share message to new connection? true/false
MsgLogins = true,
}

OnStartup = function()
	Cfg.Scp = "Top Hubshare 1.2"
	if Core then
		local Path = Core.GetPtokaXPath().."scripts/"
		if not Cfg.File:find("^"..Path,1,true) then Cfg.File = Path..Cfg.File end
	end
	if Cfg.Bot == "" then
		if Core then
			Cfg.Bot = SetMan.GetString(21)
		else
			Cfg.Bot = frmHub:GetHubBotName()
		end
	end
	if loadfile(Cfg.File) then
		dofile(Cfg.File)
		if next(TopShare) then
			local b
			for i = 1, #TopShare do
				if not TopShare[i][3] then TopShare[i][3] = "Not recorded" if not b then b = true end end
			end
			if b then Save() end
		end
	else 
		TopShare = {}
		Save()
	end
	Cfg.Interval = math.max(Cfg.Interval,5)
	if Core then
		Tmr = TmrMan.AddTimer(Cfg.Interval * 60000)
	else
		SetTimer(Cfg.Interval * 60000)
		StartTimer()
	end
	Update()
end

OnExit = function()
	FileCheck()
end

OnError = function(msg)
	local user 
	if Core then
		user = Core.GetUser(Cfg.OpNick)
		if msg and user then Core.SendToUser(user,"<"..Cfg.Bot.."> "..msg.."|") end
	else
		user = GetItemByName(Cfg.OpNick)
		if msg and user then user:SendData(Cfg.Bot,msg) end
	end
end

OnTimer = function(Id)
	if Core then if Id == Tmr then Update() end else UpDate() end
end

UserConnected = function(user)
	if Cfg.MsgLogins then
		if Cfg.MsgAll or Cfg.Profiles[user.iProfile] then
			local msg = ReturnTop()
			if msg and #msg > 0 then
				if Core then
					Core.SendToUser(user,"<"..Cfg.Bot.."> "..msg.."|")
				else
					SendData(Cfg.Bot,msg)
				end
			end
		end
	end
end
OpConnected,RegConnected,NewUserConnected = UserConnected,UserConnected,UserConnected

Update = function(arg)
	local x,bool1,bool2
	if Core then
		x = Core.GetCurrentSharedSize()
	else
		x = frmHub:GetCurrentShareAmount()
	end
	if next(TopShare) then
		while #TopShare > Cfg.MaxCache do
			table.remove(TopShare,#TopShare)
			if not bool2 then bool2 = true end
		end
		table.sort(TopShare, function(a,b)return a[1] > b[1] end)
		if x > TopShare[1][1] then
			table.insert(TopShare,1,{x,os.time(),#Core.GetOnlineUsers()})
			bool1 = true
		end
	else
		table.insert(TopShare,1,{x,os.time(),#Core.GetOnlineUsers()})
		bool1 = true
	end
	if bool1 or bool2 then Save() end
	if bool1 or not Cfg.JustNew then
		local msg = ReturnTop()
		if Core then
			if Cfg.MsgAll then
				Core.SendToAll("<"..Cfg.Bot.."> "..msg.."|")
			else
				for _,user in ipairs(Core.GetOnlineUsers()) do
					if Cfg.Profiles[user.iProfile] then
						Core.SendToUser(user,"<"..Cfg.Bot.."> "..msg.."|")
					end
				end
			end
		else
			if Cfg.MsgAll then
				SendToAll(Cfg.Bot,msg)
			else
				for _,user in ipairs(frmHub:GetOnlineUsers()) do
					if Cfg.Profiles[user.iProfile] then
						user:SendData(Cfg.Bot,msg)
					end
				end
			end
		end
	end
end

ReturnTop = function()
	local t = {{"%[Share%]",FmtSz(TopShare[1][1])},
	{"%[Date%]",os.date(Cfg.DateFmt,TopShare[1][2])},
	{"%[Users%]",tostring(TopShare[1][3])}}
	if Core then table.insert(t,{"%[Hub%]",SetMan.GetString(0)}) else table.insert(t,{"%[Hub%]",frmHub:GetHubName()}) end
	local msg = Cfg.ShareMsg
	for i,v in ipairs(t) do msg = msg:gsub(v[1],v[2]) end
	return msg
end

FileCheck = function()
	if not loadfile(Cfg.File) then
		local ren,err = os.rename(Cfg.File,Cfg.File)
		if err and not err:lower():find("denied") then os.remove(Cfg.File) Save() end
	end
end

Save = function()
	table.sort(TopShare, function(a,b)return a[1] > b[1] end)
	local f,e = io.open(Cfg.File,"wb")
	if f then
		if next(TopShare) then
			table.sort(TopShare, function(a,b)return a[1] > b[1] end)
			f:write("TopShare = {\n")
			for i,v in ipairs(TopShare) do f:write("\t["..i.."] = {"..v[1]..","..v[2]..","..v[3].."},\n") end
			f:write("}")
			f:flush() f:close()
		end
	else
		OnError(e:sub(1,-2))
	end
end

FmtSz = function(int)
	local i,u,x=tonumber(int) or 0,{"","K","M","G","T","P"},1
	while i > 1024 do i,x = i/1024,x+1 end return string.format("%.2f %sB.",i,u[x])
end

if not Core then Main = OnStartup() end
