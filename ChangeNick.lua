--[[

	Change Nick 2.0 LUA 5.1x [Strict] [API 2]

	By SmArTy	10/12/06

	Requested by JueLz

	Allows users to change their own registered nick
	-Removes existing hub account , then adds new account
	-Maintains existing user password and profile
	-Provides context menu commands [right click]



	Change Nick Help

	Command		Description
	¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	+nickhelp	Change Nick Help
	+changenick	Change Nick <new nick>

	¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

	+Changes from 1.0	05/12/08
		~Converted to API 2 strict
		~Converted to Lua 5.1x strict
		~A few optimizations
]]

Cn = {
	-- "Botname" ["" = hub bot]
	Bot = "»PhoebeBuffay«",
	-- Should bot have a key? true/false
	BotIsOp = true,
	--Bot description
	BotDesc = "User Registry Bot",
	--Bot Email address
	BotMail = "",
	--"Command Menu" ["" = hub name]
	Menu = "DA-iiCT MAiN HuB",
	--"Command SubMenu" ["" = script name]
	SubMenu = "Change Nick",
	-- Admins nick for status / error messages
	OpNick = "Mr.Reese",
	-- Send command notice to connecting users? true/false
	CmdRpt = true,
	}


OnStartup = function()
	Cn.Scp = "Change Nick 2.0"
	if Cn.Bot == "" then Cn.Bot = SetMan.GetString(21) end
	if Cn.Bot ~= SetMan.GetString(21) then Core.RegBot(Cn.Bot,Cn.BotDesc,Cn.BotMail,Cn.BotIsOp) end
	if Cn.Menu == "" then Cn.Menu = SetMan.GetString(0) end
	if Cn.SubMenu == "" then Cn.SubMenu = Cn.Scp end
end

function UserConnected(user, data)
	if user.iProfile ~= -1 then
		SendNickCmds(user)
		if Cn.CmdRpt then
			--Core.SendToUser(user,"<"..Cn.Bot.."> "..ProfMan.GetProfile(user.iProfile).sProfileName.."'s change "..
			--"nick commands enabled. Right click hub tab or user list for command menu.")
		end
	end
end
OpConnected,RegConnected = UserConnected,UserConnected

ChatArrival = function(user, data)
	if user.iProfile ~= -1 then
		local _,_,to = data:find("^$To: ([^ ]+) From:")
		local _,_,cmd = data:find("%b<> ["..SetMan.GetString(29).."](%a+)")
		if cmd and NickCmds[cmd:lower()] then
			if to and to == Cn.Bot then
				return Core.SendPmToUser(user,Cn.Bot,NickCmds[cmd:lower()](user,data)),true
			else
				return Core.SendToUser(user,"<"..Cn.Bot.."> "..NickCmds[cmd](user,data)),true
			end
		end
	end
end
ToArrival = ChatArrival

SendNickCmds = function(user)
	for i,v in pairs(NickCmds) do
		local desc,arg1,arg2 = NickCmds[i]()
		Core.SendToUser(user,"$UserCommand 1 1 "..Cn.Menu.."\\"..Cn.SubMenu.."\\"..
		desc.."$<%[mynick]> +"..i..arg1.."&#124;")
		Core.SendToUser(user,"$UserCommand 1 2 "..Cn.Menu.."\\"..Cn.SubMenu.."\\"..
		desc.."$$To: %[nick] From: %[mynick] $<%[mynick]> +"..i..arg2.."&#124;")
		collectgarbage("collect")
	end
end

NickCmds = {
	changenick = function(user,data)
		if user then
			if user.iProfile ~= -1 then
				local _,_,newnick = data:find("%b<> %p%a+ ([^|]+)|$")
				local t = RegMan.GetReg(user.sNick)
				if newnick and t then
					if newnick == t.sNick then return "Error! You must choose a new nick name." end
					if Core.GetUser(newnick) then
						return "Error! A user is currently using that nick."
					end
					if RegMan.GetReg(newnick) then
						return "Error! That nickname is already registered to another."
					end
					local nick,pswd,prof = t.sNick,t.sPassword,t.iProfile
					if nick and pswd and prof then
						if RegMan.AddReg(newnick,pswd,prof) then
							if RegMan.DelReg(nick) then
								if RegMan.GetReg(newnick) then
									return "New nick successfully changed to: "..
									newnick..". Reconnect as "..newnick.." to "..
									"effect the change."
								end
							end
						end
					end
				else
					return "Error!, Usage: "..SetMan.GetString(29):sub(1,1)..
					"changenick <newnick>"
				end
			end
		else
			return "Change Nick <new nick>"," %[line:New Nick Name]"," %[line:New Nick Name]"
		end
	end,
	nickhelp = function(user,data)
		if user then
			local r = "¯"
			local reply = Cn.Scp.." Help\n\n\tCommand\t\tDescription\n"..
			"\t"..r:rep(40).."\n"
			for i,v in pairs(NickCmds) do
				local desc,args = NickCmds[i]()
				reply = reply.."\t+"..string.format("%-15s",i).."\t"..desc.."\n"
			end
			return reply.."\n\t"..r:rep(40).."\n\n"
		else
			return "Change Nick Help","",""
		end
	end,
}