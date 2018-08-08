

----------------------------------------------------------------------------
-- show topic changer
----------------------------------------------------------------------------
function TopicChangerChangeTopic()

	for i = 1, table.getn(tTopicChangerTopics) do
		if i == iTopicChangerIncrement then
			SetMan.SetString(tStringSettings.bHubTopic, tTopicChangerTopics[i])
			if table.getn(tTopicChangerTopics) == i then
				iTopicChangerIncrement = 1
			else
				iTopicChangerIncrement = i + 1
			end
			break
		end
	end
	
end


----------------------------------------------------------------------------
-- Function Topic Changer Trigger
----------------------------------------------------------------------------
function TriggerTopicChanger()

	TopicChangerChangeTopic()

end