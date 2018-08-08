--[[

	RegMe 1.0g LUA 5.11 [Strict][API 2]
	
	By Mutor	04/07/07
	
	Self Registration / Change Password Script
	
	-Checks if user is already registered
	-Checks for invalid characters in nick and password
	-Context menus [right click]
	-Responds to user in PM only
	-Existing password required to changed password
	-Prompts unregisted user to reg at script start and at user connect
	
	+Changes from 1.0	04/07/07	Requested by Yahoo
		+Added block unregistered user file transfer/search/chat and pm to non ops
		+Added 'block' message to unregistered user at connect attempt
		+Added report new self-registered user to online ops.
		
	+Changes from 1.0b	04/13/07
		+Added report Unregistered User login to OpNick 	Requested by Yahoo
		
	+Changes from 1.0c	10/21/07
		~Converted for the new PtokaX API

	+Changes from 1.0d	10/21/07
		~Bugfix in user reg, forgot all user data must be requested. Report by DarkElf

	+Changes from 1.0e	02/16/08
		+Added RegOnly/RegChat/RegPms options. Requested by Giorgos
		+Added Report option
		~Changed all SendToNick to SendToUser [faster call]

	+Changes from 1.0f	10/06/09
		+Blocked invalid command syntax, Requested by alcorp.
		+Filtered help message per profile status.
		+Added option for command notification to connecting users.

	RegMe Command Help

	Command		Description 
	¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	!rmhelp		RegMe Command Help 
	!regme		Register Yourself  
	!passwd		Change Your Password  

	¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	
]]

--//--
-- Disable transfer and search by unregistered users? true/false
local RegOnly = true
-- Disable chat for unregistered users? true/false
local RegChat = true
-- Disable private messages for unregistered users? true/false [pm's to ops are never blocked]
local RegPms = true
-- Report unregistered user logins to OpNick? true/false
local Report = true
-- Report nick for error messages and unregistered user logins [if Report = true]
local OpNick = "Mutor"
-- Show command notification to new connections? true/false
local Notify = true
--//--


local Bot,Scp,Pfx,Menu,SubMenu = "","","","",""
local BlockMsg = "\r\n\r\n\tUnregistered users may not chat, pm, search or transfer files in this hub.\r\n"..
"\tYou may pm operators for assistance. You may also self-register by typing.\r\n"..
"\t!regme <password> or use context menu commands [right click].\r\n\r\n"

OnStartup = function()
	Bot,Scp,Pfxs = SetMan.GetString(21),"",SetMan.GetString(29)
	Menu,SubMenu,Pfx =SetMan.GetString(0),"Self Registration",Pfxs:sub(1,1)
	for _,user in ipairs(Core.GetOnlineUsers(-1)) do
		Core.SendToUser(user,"<"..Bot.."> "..BlockMsg..RegCmds["rmhelp"](user,data,cmd))
	end
end

UserConnected = function(user)
	if user.iProfile == -1 then
		SendCmds(user)
		if Report then
			OnError("The Unregistered User: "..user.sNick.." has logged in to "..SetMan.GetString(0))
		end
		if RegOnly then
			Core.SendToUser(user,"<"..Bot.."> "..BlockMsg..RegCmds["rmhelp"](user,data,cmd))
		end
	end
end
OpConnected,RegConnected = UserConnected,UserConnected

ChatArrival = function(user,data)
	local _,_,pfx,cmd = data:find("%b<> (["..Pfxs.."])(%a+)")
	if pfx and cmd then
		cmd = cmd:lower()
		local i = user.iProfile
		local p = "Unregistered User",user.iProfile
		if i ~= -1 then p = ProfMan.GetProfile(i).sProfileName end
		local msg = "Sorry "..user.sNick..", "..p.."'s may not use the "..pfx..cmd.." command."
		if RegCmds[cmd] then
			if i == -1 and cmd == "regme" or i ~= -1 and cmd == "passwd" or cmd == "rmhelp" then
				return Core.SendPmToUser(user,Bot,RegCmds[cmd](user,data,cmd)), true
			else
				return Core.SendPmToUser(user,Bot,msg), true
			end
		else
			return Core.SendToUser(user,"<"..Bot.."> "..msg),
			Core.SendToUser(user,"<"..Bot.."> "..BlockMsg),true
		end
	else
		local _,_,to,from = string.find(data,"^$To: (%S+) From: (%S+)")
		if to and from then
			if RegPms and user.iProfile == -1 then
				local prof = Core.GetUser(to)
				if prof then
					if not Core.GetUserValue(prof,11) then
						return Core.SendPmToUser(user,to,"<"..Bot.."> "..BlockMsg),true
					end
				else
					return true
				end
			end
		else
			if RegChat and user.iProfile == -1 then
				return Core.SendToUser(user,"<"..Bot.."> "..BlockMsg),true
			end
		end
	end
end
ToArrival = ChatArrival

ConnectToMeArrival = function(user, data)
	if RegOnly and user.iProfile == -1 then
		local CtmMsg = "\t*Please remove this transfer from your download queue.*"
		return Core.SendToUser(user,"<"..Bot.."> "..BlockMsg..
		CtmMsg:gsub(" ",string.char(160)).."\r\n\r\n|"),true
	end
end
RevConnectToMeArrival = ConnectToMeArrival

SearchArrival = function (user, data)
	if RegOnly and user.iProfile == -1 then
		local _,_,search = string.find(data,"([^?]+)|$")
		if search then
			local t = "TTH:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"--hash(t) in lieu of hub(h)
			local n,h,b,i,u = user.sNick,SetMan.GetString(0),SetMan.GetString(21),
			SetMan.GetString(3):gsub(";.*",""),SetMan.GetString(4)
			local res = "Unknown Path"..string.char(92)..n..", search is "..
			"disabled for you :P "..string.rep("\t",15)..search
			return Core.SendToUser(user,"$SR "..b.." "..res.." 0 1/2"..t.." ("..i..":"..u..")|"..
			"<"..Bot.."> "..n..", search is disabled for you. Please close the "..
			string.format("%q",search:gsub("%$"," ")).." search window. Thank you.|"),true
		end
	end
end

OnError = function(msg)
	local user = Core.GetUser(OpNick)
	if user then
		Core.SendToUser(user,"<"..Bot.."> "..msg)
	end
end

SendCmds = function(user)
	local n,b = user.iProfile
	for i,v in pairs(RegCmds) do
		local c = i:lower()
		if n == -1 and c == "regme" or n ~= -1 and c == "passwd" or c == "rmhelp" then
			local desc,arg1,arg2 = RegCmds[i]()
			Core.SendToUser(user,"$UserCommand 1 1 "..Menu.."\\"..SubMenu.."\\"..
			desc.."$<%[mynick]> "..Pfx..i..arg1.."&#124;")
			Core.SendToUser(user,"$UserCommand 1 2 "..Menu.."\\"..SubMenu.."\\"..
			desc.."$<%[mynick]> "..Pfx..i..arg2.."&#124;")
			if not b then b = true end
		end
	end
	if b and Notify then
		local Prof = "Unregistered User"
		if user.iProfile > -1 then Prof = ProfMan.GetProfile(user.iProfile).sProfileName end
		Core.SendToUser(user,"<"..Bot.."> "..Prof.."'s "..Scp.." commands "..
		"enabled. See hub tab or user list for a menu.")
	end
end

FormatSize = function(int)
	local i,u,x = tonumber(int) or 0,{"","K","M","G","T","P"},1
	while i > 1024 do i,x = i/1024,x+1 end return string.format("%.2f %sB.",i,u[x])
end

RegCmds = {
	regme = function(user,data,cmd)
		if user then
			local nick = user.sNick
			if user.iProfile ~= -1 then
				return "Don't be silly "..nick.." you're already registered here."
			elseif Core.GetUserAllData(user) then
				local _,_,pwd = data:find("%b<> %p%w+ (%S+)|$")
				if pwd then
					if nick:find("[%c\$\|\<\>\:\?\*\"\/\\]") then
						return "Your nickname contains invalid characters. "..
						"Please choose a new one."
					end
					if pwd:find("[%c\$\|\<\>\:\?\*\"\/\\]") then
						return "Your password contains invalid characters. "..
						"Please choose a new one."
					end
					local hub = SetMan.GetString(0)
					local addy = SetMan.GetString(2)..":"..SetMan.GetString(3)
					local share,ip = FormatSize(user.iShareSize),user.sIP
					local slots = user.iSlots or 0
					local mode = "Passive"
					if user.bActive then mode = "Active" end
					if user.sMode and user.sMode == "5" then mode = "Socks5" end
					local opmsg = "\r\n\r\n\tA user has self-registered\r\n"..
					"\twith the the following details:\r\n"..
					"\t"..string.rep("¯",22).."\r\n"..
					"\tNick:\t"..nick.."\r\n"..
					"\tPass:\t"..pwd:gsub(".","x").."\r\n"..
					"\tShare:\t"..share.."\r\n"..
					"\tI.P.:\t"..ip.."\r\n"..
					"\tMode:\t"..mode.."\r\n"..
					"\tSlots:\t"..slots.."\r\n"
					RegMan.AddReg(nick, pwd, 3)
					Core.SendToOps("<"..Bot.."> "..opmsg)
					return "\r\n\r\n\tWelcome. You have successfully "..
					"registered yourself.\r\n\t"..string.rep("¯",40).."\r\n"..
					"\tHub Name:\t"..hub.."\r\n"..
					"\tHub Address:\t"..addy.."\r\n"..
					"\tUser Name:\t"..nick.."\r\n"..
					"\tPassword:\t"..pwd.."\r\n\r\n"..
					"\t"..string.rep("¯",40).."\r\n"..
					"\tPlease make a note of this information.\r\n"..
					"\tPlease reconnect to activate your status.\r\n"
				else
					return "Error! Usage: "..Pfx..cmd.." <password>"
				end
			end
		else
			return "Register Yourself "," %[line:Password]"," %[line:Password]"," <password>>"
		end
	end,
	passwd = function(user,data,cmd)
		if user then
			if user.iProfile == -1 then
				return "Don't be silly "..user.sNick.." you're not registered here."
			elseif Core.GetUserAllData(user) then
				local _,_,oldpass,newpass = data:find("%b<> %p%w+ (%S+) (.+)|$")
				if oldpass and newpass then
					local pwd,prof = RegMan.GetReg(user.sNick).sPassword,user.iProfile
					if pwd and prof then
						if oldpass:lower() ~= pwd:lower() then
							return "That is not your correct password. "..
							"Please try again. [case insensitive]"
						end
						if newpass:find("[%c\$\|\<\>\:\?\*\"\/\\]") then
							return "Your new password contains invalid characters. "..
							"Please choose a new one."
						end
						if newpass:lower() == oldpass:lower() then
							return "Your cannot change to the same password. "..
							"Please choose a new one."
						end
						RegMan.ChangeReg(user.sNick, newpass, prof)
						return "You have successfully changed your password from "..
						oldpass.." to "..newpass
					end
				else
					return "Error! Usage: ."..Pfx..cmd.." <old password> <new password>"
				end
			end
		else
			return "Change Your Password"," %[line:Old Password] %[line:New Password]",
			" %[line:Old Password] %[line:New Password]"," <old password> <new password>"
		end
	end,
	rmhelp = function(user,data,cmd,reg)
		if user then
			local n,b = user.iProfile
			local reply = "\r\n\r\n\t"..Scp.." Help\r\n\r\n\tCommand\t\tDescription\r\n"..
			"\t"..string.rep("¯",40).."\r\n"
			for i,v in pairs(RegCmds) do
				local c = i:lower()
				if n == -1 and c == "regme" or n ~= -1 and c == "passwd" or c == "rmhelp" then
				local desc = RegCmds[i]()
				reply = reply.."\t"..Pfx..string.format("%-15s",i).."\t"..desc.."\r\n"
				end
			end
			return reply.."\n\t"..string.rep("¯",40).."\r\n\r\n"
		else
			return "RegMe Help","",""
		end
	end,
	}
