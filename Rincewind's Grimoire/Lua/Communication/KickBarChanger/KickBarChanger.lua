

----------------------------------------------------------------------------
-- show topic changer
----------------------------------------------------------------------------
function KickBarChangerChangeTopic()
	
	local sTabs = ""
	for i = 1, table.getn(tKickBarChangerTopics) do
		if i == iKickBarChangerIncrement then
			sTabs = ""
			for iLoop = 1, 30 do
				sTabs = sTabs.."\t"
			end
			SendMessage("all", tBots.tMain.sName, "\t"..tKickBarChangerTopics[i]..sTabs.." is kicking because:", 1)
			if table.getn(tKickBarChangerTopics) == i then
				iKickBarChangerIncrement = 1
			else
				iKickBarChangerIncrement = i + 1
			end
			break
		end
	end
	
end


----------------------------------------------------------------------------
-- Function KickBar Changer Trigger
----------------------------------------------------------------------------
function TriggerKickBarChanger()

	KickBarChangerChangeTopic()

end