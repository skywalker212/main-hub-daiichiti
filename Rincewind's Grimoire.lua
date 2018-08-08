
--[[-------------------------------------------------------
  Rincewind's Grimoire by Rincewind 
  Version = Rincewind's Grimoire v5.0.0
  Version Date = 07/11/2007
-------------------------------------------------------]]--

if dofile(Core.GetPtokaXPath().."scripts/Rincewind's Grimoire/Lua/General/Globals/OpenFiles.lua") then
	loadfile(Core.GetPtokaXPath().."scripts/Rincewind's Grimoire/Lua/General/Globals/OpenFiles.lua")
end

----------------------------------------------------------------------------
-- Function MAIN 
----------------------------------------------------------------------------
function OnStartup()

	OpenFiles()

	ScriptMain()

end


----------------------------------------------------------------------------
-- Function New User Connected 
----------------------------------------------------------------------------
function UserConnected(user)
	
	ScriptNewUserConnected(user)
	
end 

OpConnected = UserConnected
RegConnected = UserConnected


----------------------------------------------------------------------------
-- Function User Disconnected 
----------------------------------------------------------------------------
function UserDisconnected(user)
	
	ScriptUserDisconnected(user)
	
end

OpDisconnected=UserDisconnected
RegDisconnected=UserDisconnected


----------------------------------------------------------------------------
-- Function Main Chat Arrival
----------------------------------------------------------------------------
function ChatArrival(user, data)
	
	if ScriptChatArrival(user, data) == true then return true end
	
end

ToArrival = ChatArrival


----------------------------------------------------------------------------
-- Function Main Chat Arrival
----------------------------------------------------------------------------
function UnknownArrival(user, data)
	
	if string.find(data,"UserIP") then return true end
	
end


----------------------------------------------------------------------------
-- Function Search Arrival 
----------------------------------------------------------------------------
function SearchArrival(user,data)
	
	if ScriptSearchArrival(user,data) == true then return true end
	
end


----------------------------------------------------------------------------
-- Function MyINFO Arrival 
----------------------------------------------------------------------------
function MyINFOArrival(user, data)
	
	if ScriptMyINFOArrival(user, data) == true then return true end
	
end


----------------------------------------------------------------------------
-- Function Connect To Me Arrival 
----------------------------------------------------------------------------
function ConnectToMeArrival(user,data)
	
	if ScriptConnectToMeArrival(user,data) == true then return true end
	
end


----------------------------------------------------------------------------
-- Function Multi Connect To Me Arrival 
----------------------------------------------------------------------------
function RevConnectToMeArrival(user,data)
	
	if ScriptRevConnectToMeArrival(user,data) == true then return true end
	
end


----------------------------------------------------------------------------
-- Function Rev Connect To Me Arrival 
----------------------------------------------------------------------------
function MultiConnectToMeArrival(user,data)
	
	if ScriptMultiConnectToMeArrival(user,data) == true then return true end
	
end


----------------------------------------------------------------------------
-- Function On Exit 
----------------------------------------------------------------------------
function OnExit()
	
	if tSwitches.bSlotMachine == 1 then SlotMachineOnExit() end
	if tSwitches.bUserLog == 1 then SaveFile(tSettingPaths.sUserLog, tUserLog, "tUserLog") end
	
end


----------------------------------------------------------------------------
-- Function On Error
----------------------------------------------------------------------------
function OnError(sErrorMsg)
	
	Core.SendPmToOps(SetMan.GetString(21), sErrorMsg)
	
end

