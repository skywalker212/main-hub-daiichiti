

----------------------------------------------------------------------------
-- Function Parse Email Commands
----------------------------------------------------------------------------
function HubEmailCheckInbox(user)
	
	if tSwitches.Email == 1 then
		-- email
		if tHubEmailSettings.tEnabledProfiles[user.iProfile] = 0 then return false end
		if message[user.sNick] then
			local cnt=0
			for a,b in pairs(message[user.sNick]) do if (b.read == 0) then cnt = cnt+1; end end
			if (cnt > 0) then EmailSendBackMessage( user, "You have "..cnt.." new messages. Type !inbox to see your inbox!", tBots.tEmail.Name, true ); end
		end
	end
	
end


----------------------------------------------------------------------------
-- Function Parse Email Commands
----------------------------------------------------------------------------
function EmailParseCmds( user, data, cmd, how )
	local t = {
			[tScriptCommands.sEmailPost] = { EmailPostMessage, { user, data, how } },
			[tScriptCommands.sEmailRead] = { EmailReadMessage, { user, data, how } },
			[tScriptCommands.sEmailInbox] = { EmailInbox, { user, how } },
			[tScriptCommands.sEmailDelete] = { EmailDeleteMessage, { user, data, how } },
		}
	if t[cmd] then
		return t[cmd][1]( unpack(t[cmd][2]) )
	end
end


----------------------------------------------------------------------------
-- Function Email Post Message
----------------------------------------------------------------------------
function EmailPostMessage( user, data, how )
	
	local sMessage = ""
	local _,_,nick,msg = string.find(data,"%b<>%s+%S+%s+(%S+)%s+(.*)")
	if nick then
		if not GetItemByName(nick) then
			if washere[nick] then
				local function checksize(n) local cnt = 0; for a,b in pairs(message[n]) do cnt = cnt + 1; end return cnt; end
				if not message[nick] then message[nick] = {}; end
				if (checksize(nick) < tHubEmailSettings.iInboxSize) then
					table.insert( message[nick], { ["message"] = msg, ["who"] = user.sNick, ["when"] = os.date("%Y. %m. %d. %X"), ["read"] = 0, } )
					EmailSendBackMessage( user, tScriptMessages.sEmailPostSent, tBots.tEmail.Name, how )
					EmailSaveMessage()
				else
					sMessage = string.gsub(tScriptMessages.sEmailPostFullInbox, "!username!", nick)
					EmailSendBackMessage( user, sMessage, tBots.tEmail.Name, how )
				end
			else
				sMessage = string.gsub(tScriptMessages.sEmailPostNever, "!username!", nick)
				EmailSendBackMessage( user, sMessage, tBots.tEmail.Name, how )
			end
		else
			sMessage = string.gsub(tScriptMessages.sEmailPostOnline, "!username!", nick)
			EmailSendBackMessage( user, sMessage, tBots.tEmail.Name, how )
		end
	else
		sMessage = string.gsub(string.gsub(tScriptMessages.sEmailPostSyntax, "!prefix!", tGeneral.sPrefix), "!command!", tScriptCommands.sEmailPost)
		EmailSendBackMessage( user, sMessage, tBots.tEmail.Name, how )
	end
	EmailCls(); return true;
	
end


----------------------------------------------------------------------------
-- Function Email Delete Message
----------------------------------------------------------------------------
function EmailDeleteMessage( user, data, how )
	
	local sMessage = ""
	if message[user.sNick] then
		local _,_,args = string.find(data,"%b<>%s+%S+%s+(.+)")
		if args then
			local function checksize(n) local cnt = 0; for a,b in pairs(message[n]) do cnt = cnt + 1; end return cnt; end
			local function resort(t) local r ={}; for i,v in pairs(t) do table.insert(r, v); end; return r; end
			for num in string.gmatch( args, "%s-(%d+)%s-" ) do
				if num then
					num = tonumber(num);
					if message[user.sNick][num] then
						message[user.sNick][num] = nil
						sMessage = string.gsub(tScriptMessages.sEmailDeleteSuccess, "!number!", num)
						EmailSendBackMessage( user, sMessage, tBots.tEmail.Name, how )
					else
						sMessage = string.gsub(tScriptMessages.sEmailDeleteNotExist, "!number!", num)
						EmailSendBackMessage( user, sMessage, tBots.tEmail.Name, how )
					end
				end
			end
			message[user.sNick] = resort(message[user.sNick]);
			if checksize(user.sNick) == 0 then message[user.sNick] = nil; end
			EmailSaveMessage()
		else
		sMessage = string.gsub(string.gsub(tScriptMessages.sEmailDeleteSyntax, "!prefix!", tGeneral.sPrefix), "!command!", tScriptCommands.sEmailDelete)
		EmailSendBackMessage( user, sMessage, tBots.tEmail.Name, how )
		end
	else
		EmailSendBackMessage( user, sEmailDeleteEmpty, tBots.tEmail.Name, how )
	end
	EmailCls(); return true;
end


----------------------------------------------------------------------------
-- Function Email Show Message
----------------------------------------------------------------------------
function EmailInbox( user, how )
	
	local sMessage = ""
	local sep, msg = string.rep( "=", 75 ), "\r\n\r\n\t\t\t\t\t\t\tHere is your inbox:\r\n"
	msg = msg..sep.."\r\n Msg#\tSender\tTime of sending\t\tRead\r\n"..sep
	if message[user.sNick] then
		local function numess ( r ) if r == 0 then return "no"; end return "yes"; end
		local function checksize ( n ) local cnt = 0; for a,b in pairs(message[n]) do cnt = cnt + 1; end return cnt; end
		local function dcode ( s )	if (string.sub(s,1,3) == "-n#") then s=string.sub(s,4,-1); local res = ""; for num in string.gmatch( s, "#?(%d+)") do res = res..string.char(tonumber(num));end;return res;end;return s;end
		for num, t in pairs(message[user.sNick]) do
			msg=msg.."\r\n "..num.."\t"..dcode(t.who).."\t"..t.when.."\t"..numess(t.read).."\r\n"..sep
		end
		EmailSendBackMessage( user, msg, tBots.tEmail.Name, true )
		sMessage = string.gsub(string.gsub(string.gsub(tScriptMessages.sEmailInboxMail, "!prefix!", tGeneral.sPrefix), "!readcommand!", tScriptCommands.sEmailRead), "!deletecommand!", tScriptCommands.sEmailDelete)
		EmailSendBackMessage( user, sMessage, tBots.tEmail.Name, true )
		if checksize(user.sNick) >= tEmails.InboxSize then EmailSendBackMessage( user, tScriptMessages.sEmailInboxFull, tBots.tEmail.Name, true ); end
	else
		EmailSendBackMessage( user, tScriptMessages.sEmailInboxEmpty, tBots.tEmail.Name, how )
	end
	EmailCls(); return true;
end


----------------------------------------------------------------------------
-- Function Email Read Message
----------------------------------------------------------------------------
function EmailReadMessage( user, data, how )
	
	local sMessage = ""
	if message[user.sNick] then
		local _,_,args=string.find(data,"%b<>%s+%S+%s+(.+)")
		if args then
			local function dcode(s) if (string.sub(s,1,3) == "-n#") then s = string.sub(s,4,-1);local res = ""; for num in string.gmatch( s, "#?(%d+)") do res = res..string.char(tonumber(num));end;return res;end;return s;
			end
			for num in string.gmatch( args, "%s-(%d+)%s-" ) do
				if num then num = tonumber(num) end
				if num and message[user.sNick][num] then
					local t = message[user.sNick][num]
					local msg, sep,set = "\r\n\r\n\t\t\t\t\t\t\tMessage #"..num.."\r\n", string.rep( "=", 100 ), string.rep("- ", 85)
					msg = msg..sep.."\r\n\r\nFrom: "..dcode(t.who).."\tTime: "..t.when.."\t\tMessage follows\r\n"..set.."[Message start]\r\n"..dcode(t.message).."\r\n"..set.."[Message end]\r\n"..sep
					EmailSendBackMessage( user, msg, tBots.tEmail.Name, true )
					if t.read == 0 then t.read = 1; EmailSaveMessage(); end
				else
					sMessage = string.gsub(tScriptMessages.sEmailReadNotExist, "!number!", num)
					EmailSendBackMessage( user, sMessage, tBots.tEmail.Name, how )
				end
			end
		else
			sMessage = string.gsub(string.gsub(tScriptMessages.sEmailReadSyntax, "!prefix!", tGeneral.sPrefix), "!command!", tScriptCommands.sEmailRead)
			EmailSendBackMessage( user, sMessage, tBots.tEmail.Name, how )
		end
	else
		EmailSendBackMessage( user, tScriptMessages.sEmailInboxEmpty, tBots.tEmail.Name, how )
	end
	EmailCls(); return true;
end


----------------------------------------------------------------------------
-- Function Email Save Message
----------------------------------------------------------------------------
function EmailSaveMessage()

	local function parse(tbl)
		local str, tab ="", string.rep( "\t", 9)
		local function fquot(s) return string.format( "%q", s) end
		local function ncode( s ) if (s ~= "") and (string.sub(s,1,3) ~= "-n#") then local t = {}; for i = 1, string.len(s) do t[i] = string.byte(string.sub(s,i,i)); end; return "-n#"..table.concat(t, "#"); end; return s; end
		for a, t in pairs(tbl) do
			str = str.."\t\t{ ["..fquot("read").."] = "..t.read..", ["..fquot("who").."] = "..fquot(ncode(t.who))..", ["..fquot("when").."] = "..fquot(t.when)..",\n\t\t["..fquot("message").."] = "..fquot(ncode(t.message)).." },\n"
		end
		return str
	end
	local f = io.open ( "Rincewind's "..Product.."/Data/offline.dat", "w+" )
	local s = "message = {"
	for name, t in pairs(message) do
		s = s.."\n\t["..string.format( "%q", string.gsub( name, "\"", "\"")).."] = {\n"..parse(t).."\t},"
	end;
	f:write(s.."\n}")
	f:close()
end


----------------------------------------------------------------------------
-- Function Email Send Back Message
----------------------------------------------------------------------------
function EmailSendBackMessage( user, msg, who, pm )

	if pm then
		SendMessage(who, user.sNick, msg, 0)
	else
		SendMessage(who, user.sNick, msg, 1)
	end

end


----------------------------------------------------------------------------
-- Function Email Cls
----------------------------------------------------------------------------
function EmailCls()

	collectgarbage()
	io.flush()

end


