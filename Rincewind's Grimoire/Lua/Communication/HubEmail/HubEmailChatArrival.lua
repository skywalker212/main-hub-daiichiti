
----------------------------------------------------------------------------
-- Function Whisper Chat Arrival
----------------------------------------------------------------------------
function HubEmailChatArrival(user, data, cmd)
	
	if not cmd then return false end
	local _,_,sWhere = string.find(data, "%$To:%s(%S+)")
	local bInMain, sSender = 1, tBots.tHubEmail.sName
	if sWhere then 
		bInMain = 0
		sSender = sWhere
	end
	
	local tCmds = {
		-- HubEmail
		[tScriptCommands.sInbox] = function(user, data)
			if tSwitches.bHubEmail == 1 then
				EmailInbox(user, string.lower(cmd)) return true
			else
				SendMessage(user.sNick, sSender,tScriptMessages.sCommandDisabled, bInMain) return true
			end
		end,
		
		[tScriptCommands.sPostMsg] = function(user, data)
			if tSwitches.bHubEmail == 1 then
				EmailPostMessage(user,data, string.lower(cmd)) return true
			else
				SendMessage(user.sNick, sSender,tScriptMessages.sCommandDisabled, bInMain) return true
			end
		end,
		
		[tScriptCommands.sReadMsg] = function(user, data)
			if tSwitches.bHubEmail == 1 then
				EmailReadMessage(user,data, string.lower(cmd)) return true
			else
				SendMessage(user.sNick, sSender,tScriptMessages.sCommandDisabled, bInMain) return true
			end
		end,
		
		[tScriptCommands.sDelMsg] = function(user, data)
			if tSwitches.bHubEmail == 1 then
				EmailDeleteMessage(user,data, string.lower(cmd)) return true
			else
				SendMessage(user.sNick, sSender,tScriptMessages.sCommandDisabled, bInMain) return true
			end
		end,
	}
	if tCmds[cmd] then return tCmds[cmd](user, data) end
	
end