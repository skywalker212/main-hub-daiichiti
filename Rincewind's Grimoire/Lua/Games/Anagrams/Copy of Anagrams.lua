

----------------------------------------------------------------------------
-- Function Anagrams Start
----------------------------------------------------------------------------
function AnagramStartGame(user, data)
gsFunction = "AnagramStartGame"

	-- autostart of game is stopped now. will be retsrated when game ends
	if tAnagramSettings.bManualStart == 0 then
		TmrMan.RemoveTimer(tTimers.TriggerAnagramsAutoStart)
		tTimers.TriggerAnagramsAutoStart = nil
	end
	tTimers.TriggerAnagramsTimeOut = TmrMan.AddTimer(tAnagramSettings.iTimeOut * Minute, "TriggerAnagramsTimeOut")

	sGameInProgress = "Anagrams"

	local sMessage = ""
	sActualPhrase = "kjsdgiujfhgijkfgllirhgirelgkpwek"
	
	if user ~= "" then
		sMessage = string.gsub(string.gsub(tScriptMessages.sQuizStartedBy, "!username!", user.sNick), "!game!", gsVersion.." "..sGameInProgress)
	else
		sMessage = string.gsub(tScriptMessages.sQuizStarted, "!game!", gsVersion.." "..sGameInProgress)
	end
	
	if tAnagramSettings.bPlayInMain == 1 then
		SendMessage("all", tBots.tAnagrams.sName, "\r\n\r\n\t\t"..sMessage.."\r\n", tAnagramSettings.bPlayInMain)
		iAnagramQuestion = 1
		AnagramQuestion()
	else
		SendMessage("all", tBots.tAnagrams.sName, string.gsub(string.gsub(string.gsub(tScriptMessages.sAnagramsStarting, "!prefix!", tGeneralSettings.sPrefix), "!command!", tScriptCommands.sAnJoin), "!bot!", tBots.tAnagrams.sName), 1)
		for sPlayer,v in pairs(tAnagramPlayers) do
			SendMessage(sPlayer, tBots.tAnagrams.sName, "\r\n\r\n\t\t"..sMessage.."\r\n", tAnagramSettings.bPlayInMain)
		end
	
		iAnagramQuestion = 0
		tTimers.TriggerAnagramsQPause = TmrMan.AddTimer(tAnagramSettings.iQuestionsPause * Second, "TriggerAnagramsQPause")
	end
	
end


----------------------------------------------------------------------------
-- Function Anagrams Stop
----------------------------------------------------------------------------
function AnagramStopGame(user, data)
gsFunction = "AnagramStopGame"

	if data == "TimeOut" then
		sMessage = string.gsub(tScriptMessages.sQuizStopped, "!game!", gsVersion.." "..sGameInProgress)
	else
		sMessage = string.gsub(string.gsub(tScriptMessages.sQuizStoppedBy, "!username!", user.sNick), "!game!", gsVersion.." "..sGameInProgress)
	end
	AnagramSetScores("", tAnagramSettings.iTopScores)
	if tAnagramSettings.bPlayInMain == 1 then
		SendMessage("all", tBots.tAnagrams.sName, "\r\n\r\n\t\t"..sMessage.."\r\n", tAnagramSettings.bPlayInMain)
		SendMessage("all", tBots.tAnagrams.sName, sScoresOutput, tAnagramSettings.bPlayInMain)
	else
		for sPlayer,v in pairs(tAnagramPlayers) do
			SendMessage(sPlayer, tBots.tAnagrams.sName, "\r\n\r\n\t\t"..sMessage.."\r\n", tAnagramSettings.bPlayInMain)
			SendMessage(sPlayer, tBots.tAnagrams.sName, sScoresOutput, tAnagramSettings.bPlayInMain)
		end
	end
	
ViewTimers(user, data)
	if tTimers.TriggerAnagramsTimeOut then
		TmrMan.RemoveTimer(tTimers.TriggerAnagramsTimeOut)
		tTimers.TriggerAnagramsTimeOut = nil
	end
	if tTimers.TriggerAnagrams then
		TmrMan.RemoveTimer(tTimers.TriggerAnagrams)
		tTimers.TriggerAnagrams = nil
	end
	if tTimers.TriggerAnagramsBonus then
		TmrMan.RemoveTimer(tTimers.TriggerAnagramsBonus)
		tTimers.TriggerAnagramsBonus = nil
	end
	if tTimers.TriggerAnagramsQPause then
		TmrMan.RemoveTimer(tTimers.TriggerAnagramsQPause)
		tTimers.TriggerAnagramsQPause = nil
	end
ViewTimers(user, data)
	iAnagramHints = 0

	-- restart autostart timer
	if tAnagramSettings.bManualStart == 0 then
		tTimers.TriggerAnagramsAutoStart = TmrMan.AddTimer(tAnagramSettings.iAutoStartDelay * Minute, "TriggerAnagramsAutoStart")
	end
	
	sGameInProgress = nil
	
end


----------------------------------------------------------------------------
-- Function Anagrams Question
----------------------------------------------------------------------------
function AnagramQuestion()
gsFunction = "AnagramQuestion"
	
	local sMessage = ""
	if iAnagramQuestion > tAnagramSettings.iQuestions then
		sMessage = string.gsub(tScriptMessages.sQuizFinished, "!game!", gsVersion.." "..sGameInProgress)
		AnagramSetScores("", tAnagramSettings.iTopScores)
		if tAnagramSettings.bPlayInMain == 1 then
			SendMessage("all", tBots.tAnagrams.sName, "\r\n\r\n\t\t"..sMessage.."\r\n", tAnagramSettings.bPlayInMain)
			SendMessage("all", tBots.tAnagrams.sName, sScoresOutput, tAnagramSettings.bPlayInMain)
		else
			for sPlayer,v in pairs(tAnagramPlayers) do
				SendMessage(sPlayer, tBots.tAnagrams.sName, "\r\n\r\n\t\t"..sMessage.."\r\n", tAnagramSettings.bPlayInMain)
				SendMessage(sPlayer, tBots.tAnagrams.sName, sScoresOutput, tAnagramSettings.bPlayInMain)
			end
		end
		
		if tTimers.TriggerAnagrams then
			TmrMan.RemoveTimer(tTimers.TriggerAnagrams)
			tTimers.TriggerAnagrams = nil
		end
		if tTimers.TriggerAnagramsBonus then
			TmrMan.RemoveTimer(tTimers.TriggerAnagramsBonus)
			tTimers.TriggerAnagramsBonus = nil
		end
		if tTimers.TriggerAnagramsQPause then
			TmrMan.RemoveTimer(tTimers.TriggerAnagramsQPause)
			tTimers.TriggerAnagramsQPause = nil
		end
		if tTimers.TriggerAnagramsTimeOut then
			TmrMan.RemoveTimer(tTimers.TriggerAnagramsTimeOut)
			tTimers.TriggerAnagramsTimeOut = nil
		end
		
		-- restart autostart timer
		if tAnagramSettings.bManualStart == 0 then 
			tTimers.TriggerAnagramsAutoStart = TmrMan.AddTimer(tAnagramSettings.iAutoStartDelay * Minute, "TriggerAnagramsAutoStart")
		end
		
		sGameInProgress = nil
	else	
		filevar = io.open(tSettingPaths.sAnagramWords[1], "r")
		if filevar == nil then
			sMessage = string.gsub(string.gsub(tScriptMessages.sQuizLoadFailed, "!game!", gsVersion.." "..sGameInProgress), "!filename!", tAnagramSettings.ssFile)
			SendMessage("ops", tBots.tAnagrams.sName, sMessage, 1)
			return true	
		end
	
		local _, phrase = nil, nil;
		local iFileSize = filevar:seek("end")
		math.randomseed(os.clock())
		while(phrase == nil) do
			filevar:seek("set", math.random(iFileSize)-1)
			_, phrase = filevar:read( "*l", "*l")
		end
		
		filevar:close()
		
		sActualPhrase = string.upper(phrase)
		sNoSpacePhrase = string.gsub(sActualPhrase, "%s", "")
		sAnagramPhrase = AnagramMixPhrase(sActualPhrase)
		sAnagramPhraseLength = string.len(sNoSpacePhrase)
		
		local sAnagramsQuestion = string.gsub(tScriptMessages.sQuizAnagramsQuestion, "!phrase!", sAnagramPhrase)
		
		sMessage = string.gsub(string.gsub(string.gsub(tScriptMessages.sQuizQuestion, "!thisquestion!", iAnagramQuestion), "!totalquestions!", tAnagramSettings.iQuestions), "!question!", sAnagramsQuestion)
		
		if tAnagramSettings.bPlayInMain == 1 then
			SendMessage("all", tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
		else
			for sPlayer,v in pairs(tAnagramPlayers) do
				SendMessage(sPlayer, tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
			end
		end
		
		iQuizStartTime = os.clock()
		iBonusTime = 11
		tTimers.TriggerAnagramsBonus = TmrMan.AddTimer(Second, "TriggerAnagramsBonus")
		tTimers.TriggerAnagrams = TmrMan.AddTimer(tAnagramSettings.iHintTime * Second, "TriggerAnagrams")
	end
	
end


----------------------------------------------------------------------------
-- Function Anagrams Hint
----------------------------------------------------------------------------
function AnagramHint()
gsFunction = "AnagramHint"
	
	local sMessage = ""
	iAnagramHints = iAnagramHints + 1
	if iAnagramHints == 4 then
		sMessage = string.gsub(tScriptMessages.sQuizUnanswered, "!answer!" , sActualPhrase)
		if tAnagramSettings.bPlayInMain == 1 then
			SendMessage("all", tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
		else
			for sPlayer,v in pairs(tAnagramPlayers) do
				SendMessage(sPlayer, tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
			end
		end
		TmrMan.RemoveTimer(tTimers.TriggerAnagrams)
		tTimers.TriggerAnagrams = nil
		iAnagramHints = 0
		sActualPhrase = "jdsghihgierhvierhvbjuevierhgoiernborebio"
		tTimers.TriggerAnagramsQPause = TmrMan.AddTimer(tAnagramSettings.iQuestionsPause * Second, "TriggerAnagramsQPause")
	elseif iAnagramHints == 3 then
		SetAnagramHint()
		sMessage = string.gsub(tScriptMessages.sQuizAutoHint, "!hint!", sHint)
		if tAnagramSettings.bPlayInMain == 1 then
			SendMessage("all", tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
		else
			for sPlayer,v in pairs(tAnagramPlayers) do
				SendMessage(sPlayer, tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
			end
		end
		sMessage = string.gsub(tScriptMessages.sQuizTimeLeft, "!time!", tAnagramSettings.iHintTime)
		if tAnagramSettings.bPlayInMain == 1 then
			SendMessage("all", tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
		else
			for sPlayer,v in pairs(tAnagramPlayers) do
				SendMessage(sPlayer, tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
			end
		end
	else
		SetAnagramHint()
		sMessage = string.gsub(tScriptMessages.sQuizAutoHint, "!hint!", sHint)
		if tAnagramSettings.bPlayInMain == 1 then
			SendMessage("all", tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
		else
			for sPlayer,v in pairs(tAnagramPlayers) do
				SendMessage(sPlayer, tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
			end
		end
	end
	
end


----------------------------------------------------------------------------
-- Function Anagrams Set Jumble Hint
----------------------------------------------------------------------------
function SetAnagramHint()
gsFunction = "SetAnagramHint"

	local tRevealArray = { };
	
	local iReveal = math.floor(.4 * sAnagramPhraseLength + .5)
	local iPos = nil
	while(iReveal > 0) do
	repeat iPos = math.random(sAnagramPhraseLength) until tRevealArray[iPos] == nil
		tRevealArray[iPos] = 1
		iReveal = iReveal - 1
	end
	tRevealArray.iPos = 1
	sHint = string.gsub(sActualPhrase, "(%S)", function (c) 
	if (c == nil) then return "" end
	local out, tTemp = nil, tRevealArray
		if(tTemp[tTemp.iPos]) then
			out = c
		else
			out = tAnagramSettings.sHintChar
		end
		tTemp.iPos = tTemp.iPos + 1
		return out.." "
	end)
	sHint = string.sub(sHint, 1, -2)
	
end


----------------------------------------------------------------------------
-- Function Anagrams Guess
----------------------------------------------------------------------------
function AnagramGuess(user, data)
gsFunction = "AnagramGuess"

	RemoveTimer("TriggerAnagramsTimeOut",1)
	tTimers.TriggerAnagramsTimeOut = TmrMan.AddTimer(tAnagramSettings.iTimeOut * Minute, "TriggerAnagramsTimeOut")
	
	local sMessage = ""
	local s,e,guess = string.find(data, "%b<>%s+(.*)")
	local _,_,sInPM = string.find(data, "%$To:")
	
	if string.lower(guess) == string.lower(sActualPhrase) then
		if tAnagramSettings.bPlayInMain == 1 then
			SendMessage("all", user.sNick, guess, tAnagramSettings.bPlayInMain)
		else
			for sPlayer,v in pairs(tAnagramPlayers) do
				if sPlayer ~= string.lower(user.sNick) then
					SendMessage(sPlayer, tBots.tAnagrams.sName, user.sNick.."^"..guess, tAnagramSettings.bPlayInMain)
				end
			end
		end
		
		local score = tAnagramSettings.iPoints + tAnagramSettings.iBonusTime
		score = tAnagramSettings.iPoints + iBonusTime
		local sCorrectAnswer = sActualPhrase
		sActualPhrase = "456dsgfsdgdf5sg56df4sh54fd64hh465dsfhd5f4hd64ha68fh6"
		
		if tAnagramScoresByName[user.sNick] then
			tAnagramScoresByName[user.sNick][2] = tAnagramScoresByName[user.sNick][2] + score
		else
			tAnagramScoresByName[user.sNick] = {user.sNick, score};
			table.insert(tAnagramScores, tAnagramScoresByName[user.sNick])
		end

		local iRank = AnagramSetScores(user.sNick, 0);
		local iRankTotal = table.getn(tAnagramScores);
		local iUserScore = tAnagramScoresByName[user.sNick][2];
		local sBehind = ""
		if iRank > 1 then
			sBehind = (tAnagramScores[iRank-1][2] - tAnagramScores[iRank][2])
		end
		AnagramWriteScoresToFile();
		
		iQuizStartTime = string.format("%.0f", os.clock() - iQuizStartTime)
		sMessage = string.gsub(string.gsub(string.gsub(tScriptMessages.sQuizCorrectAnswer, "!username!", user.sNick), "!answer!", sCorrectAnswer), "!time!", iQuizStartTime)
		if tAnagramSettings.bPlayInMain == 1 then
			SendMessage("all", tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
		else
			for sPlayer,v in pairs(tAnagramPlayers) do
				SendMessage(sPlayer, tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
			end
		end
		
		local sBonusPointMessage = ""
		if iBonusTime > 0 and iRank > 1 then
			sMessage = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(tScriptMessages.sQuizAnagramsRankBehind, "!username!", user.sNick),"!score!", score), "!totalscore!", iUserScore), "!rank!", iRank), "!totalrank!", iRankTotal), "!bonus!", iBonusTime), "!nextrank!", tAnagramScores[iRank-1][1]), "!behind!", sBehind)
		elseif iBonusTime > 0 then
			sMessage = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(tScriptMessages.sQuizAnagramsRank, "!username!", user.sNick),"!score!", score), "!totalscore!", iUserScore), "!rank!", iRank), "!totalrank!", iRankTotal), "!bonus!", iBonusTime)
		elseif iRank > 1 then
			sMessage = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(tScriptMessages.sQuizRankBehind, "!username!", user.sNick),"!score!", score), "!totalscore!", iUserScore), "!rank!", iRank), "!totalrank!", iRankTotal), "!nextrank!", tAnagramScores[iRank-1][1]), "!behind!", sBehind)
		else
			sMessage = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(tScriptMessages.sQuizRank, "!username!", user.sNick),"!score!", score), "!totalscore!", iUserScore), "!rank!", iRank), "!totalrank!", iRankTotal)
		end
		if tAnagramSettings.bPlayInMain == 1 then
			SendMessage("all", tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
		else
			for sPlayer,v in pairs(tAnagramPlayers) do
				SendMessage(sPlayer, tBots.tAnagrams.sName, sMessage, tAnagramSettings.bPlayInMain)
			end
		end
		
		TmrMan.RemoveTimer(tTimers.TriggerAnagrams)
		tTimers.TriggerAnagrams = nil
		TmrMan.RemoveTimer(tTimers.TriggerAnagramsBonus)
		tTimers.TriggerAnagramsBonus = nil
		
		tTimers.TriggerAnagramsQPause = TmrMan.AddTimer(tAnagramSettings.iQuestionsPause * Second, "TriggerAnagramsQPause")
		--StartTimer()
		
		return true
	else
		if tAnagramSettings.bPlayInMain == 0 then
			for sPlayer,v in pairs(tAnagramPlayers) do
				if sPlayer ~= string.lower(user.sNick) then
					SendMessage(sPlayer, tBots.tAnagrams.sName, user.sNick.."^"..guess, tAnagramSettings.bPlayInMain)
				end
			end
		end
	end
	return false
	
end


----------------------------------------------------------------------------
-- Function Anagrams Set Scores
----------------------------------------------------------------------------
function AnagramSetScores(sName, ShowXScores)
gsFunction = "AnagramSetScores"

	local iCount = table.getn(tAnagramScores)
	local whatvalue,iPos,sUsername,iUserScore,numscoretabs,sMessage = 0,0,"",0,"",""
	if ShowXScores > 0 then
		sScoresOutput = string.gsub(string.gsub(tScriptMessages.sQuizScoresTopX, "!top!", ShowXScores), "!game!", "Anagrams")
		whatvalue = ShowXScores
	else
		sScoresOutput = string.gsub(tScriptMessages.sQuizScoresTop, "!game!", "Anagrams")
		whatvalue = 10000
	end
	
	if iCount == 0 then
		sScoresOutput = "\r\n\r\n\t"..string.gsub(tScriptMessages.sQuizScoresNone, "!game!", "Anagrams").."\r\n"
		return true
	else
		table.sort(tAnagramScores, function(a, b) return a[2] > b[2]; end)
		for i = 1, iCount, 1 do
			tAnagramScores[i][3] = i -- set ranks for all users
		end
		sScoresOutput = "\r\n\r\n\t\t"..string.rep(tGeneralSettings.sBorder, 40).."\r\n\t\t"..tGeneralSettings.sBorder.."\t\t"..
				gsVersion.." "..sScoresOutput.."\r\n\t\t"..string.rep(tGeneralSettings.sBorder, 40).."\r\n\t\t"..
				tGeneralSettings.sBorder.."\r\n"
		for i = 1, math.min(whatvalue, iCount), 1 do
			iPos = i
			sUserName = tAnagramScores[iPos][1]
			iUserScore = tAnagramScores[iPos][2]
			if iPos < 10 then
				anscoretabs = "\t\t"
			else
				anscoretabs = "\t"
			end
			sScoresOutput = sScoresOutput.."\t\t"..tGeneralSettings.sBorder.."\tRank. "..iPos.."   "..anscoretabs.."Score. "..
					iUserScore.."    \t\t"..sUserName.."\r\n"
		end
		sScoresOutput = sScoresOutput.."\t\t"..tGeneralSettings.sBorder.."\r\n\t\t"..string.rep(tGeneralSettings.sBorder, 40).."\r\n\r\n"
	end
	sUserName = sName
	if sName then
		if sName ~= "" and tAnagramScoresByName[sName] then
			return tAnagramScoresByName[sName][3]
		end
	end

end


----------------------------------------------------------------------------
-- Function Anagrams Set Scores
----------------------------------------------------------------------------
function AnagramReadScoresFromFile()
gsFunction = "AnagramReadScoresFromFile"
	
	dofile(tSettingPaths.sAnagramScores[1])
	for i = 1, table.getn(tAnagramScores), 1 do
		tAnagramScoresByName[tAnagramScores[i][1]] = tAnagramScores[i]
	end

end


----------------------------------------------------------------------------
-- Function Anagrams Set Scores
----------------------------------------------------------------------------
function AnagramWriteScoresToFile()
gsFunction = "AnagramWriteScoresToFile"

	local filevar,Er = io.open(tSettingPaths.sAnagramScores[1], "w")
	filevar:write("tAnagramScores = {\n")
	for i = 1, table.getn(tAnagramScores), 1 do
		filevar:write("["..i.."] = {"..string.format("%q", tAnagramScores[i][1])..","..tAnagramScores[i][2].."},\n")
	end
	filevar:write("n="..table.getn(tAnagramScores).."\n")
	filevar:write("};")
	filevar:close()

end


----------------------------------------------------------------------------
-- Function Anagrams
----------------------------------------------------------------------------
function AnagramShowScores(user, showsomescores)
gsFunction = "AnagramShowScores"

	AnagramSetScores(user.sNick, showsomescores)

	local sMessage = string.gsub(tScriptMessages.sQuizShowScores, "!username!", user.sNick)
	if tAnagramSettings.bPlayInMain == 1 then
		SendMessage("all", tBots.tAnagrams.sName, sMessage..sScoresOutput, tAnagramSettings.bPlayInMain)
	else
		for sPlayer,v in pairs(tAnagramPlayers) do
			SendMessage(sPlayer, tBots.tAnagrams.sName, sMessage..sScoresOutput, tAnagramSettings.bPlayInMain)
		end
	end
	
end


----------------------------------------------------------------------------
-- Function Anagrams
----------------------------------------------------------------------------
function AnagramClearScores(user)
gsFunction = "AnagramClearScores"

	tAnagramScores, tAnagramScoresByName  = { n = 0 }, {}

	AnagramWriteScoresToFile()
	
end


----------------------------------------------------------------------------
-- Function Anagrams Mix Phrase
----------------------------------------------------------------------------
function AnagramMixPhrase(phrase)
gsFunction = "AnagramMixPhrase"

	return string.sub(string.gsub(phrase, "(%S+)", function (w) return AnagramMixString(w).."  "; end), 1, -2)

end


----------------------------------------------------------------------------
-- Function Anagrams Mix String
----------------------------------------------------------------------------
function AnagramMixString(str)
gsFunction = "AnagramMixString"

	local tStr = { n = 0; }
	local newString = ""
	string.gsub(str, "(.)", function(c) table.insert(tStr, c); end)
	math.randomseed(os.clock())
	
	-- Fisher-Yates shuffle
	for n = table.getn(tStr), 1, -1 do
		local pos = math.random(n)
		newString = tStr[pos].." "..newString
		tStr[pos] = tStr[n]
	end
	return newString

end


----------------------------------------------------------------------------
-- Function Anagrams Question Pause
----------------------------------------------------------------------------
function AnagramQuestionPause()
gsFunction = "AnagramQuestionPause"

	iAnagramHints = 0
	iAnagramQuestion = iAnagramQuestion + 1
	AnagramQuestion(user)
	
	TmrMan.RemoveTimer(tTimers.TriggerAnagramsQPause)
	tTimers.TriggerAnagramsQPause = nil

end


----------------------------------------------------------------------------
-- Function Anagrams Question Pause
----------------------------------------------------------------------------
function AnagramTimeOut()
gsFunction = "AnagramTimeOut"
	Core.SendToNick("Rincewind", "here aargh")
	
	AnagramStopGame(nil, "TimeOut")
	
end


----------------------------------------------------------------------------
-- Function Anagrams Auto Start
----------------------------------------------------------------------------
function AnagramAutoStart()
gsFunction = "AnagramAutoStart"
	
	if sGameInProgress == nil then
		if not tMainBlock.bBlocked then
			AnagramStartGame("","") 
		end
	end
	
end


----------------------------------------------------------------------------
-- Function Anagrams Clear Scores
----------------------------------------------------------------------------
function AnagramsClearScores(user)
gsFunction = "AnagramsClearScores"
	
	local sUser = ""
	if user then
		sUser = user.sNick
	else
		sUser = tBots.tAnagrams.sName
	end
	tAnagramScores, tAnagramScoresByName  = { n = 0 }, {}
	AnagramWriteScoresToFile()
	local sMessage = string.gsub(string.gsub(tScriptMessages.sScoresCleared, "!game!", "Anagrams"), "!username!", sUser)
	if tAnagramSettings.bPlayInMain == 1 then
		SendMessage("all", tBots.tAnagrams.sName, sMessage, 1)--tAnagramSettings.bPlayInMain)
	else
		for sPlayer,v in pairs(tAnagramPlayers) do
			SendMessage(sPlayer, tBots.tAnagrams.sName, sMessage, 1)--tAnagramSettings.bPlayInMain)
		end
	end
	
end


----------------------------------------------------------------------------
-- Function Anagrams Clear Scores
----------------------------------------------------------------------------
function AnagramsArchiveScores(user)
gsFunction = "AnagramsArchiveScores"
	
	if tAnagramSettings.bArchiveScores == 1 then
		local tAnagramScoresArchive = {}
		for i,v in ipairs(tAnagramScores) do
			if i <= tAnagramSettings.iArchiveScores then tAnagramScoresArchive[i] = tAnagramScores[i] end
		end
		local sMonth,sYear = os.date("%m")-1, os.date("%y")
		if sMonth == 0 then
			sMonth = 12
			sYear = sYear - 1
		end
		if string.len(sMonth) == 1 then sMonth = "0"..sMonth end
		
		local sArchiveCount = table.getn(tAnagramScoresArchiveIndex)
		if tAnagramScoresArchiveIndex[sArchiveCount] ~= sMonth..sYear then tAnagramScoresArchiveIndex[sArchiveCount + 1] = sMonth..sYear end
		SaveFile(tSettingPaths.sAnagramScoresArchiveIndex, tAnagramScoresArchiveIndex, "tAnagramScoresArchiveIndex")
		
		SaveFile({string.gsub(tSettingPaths.sAnagramScoresArchive, "!filename!", sYear..sMonth),1}, tAnagramScoresArchive, "tAnagramScoresArchive")
		
		SendMessage("ops", tBots.tAnagrams.sName, tScriptMessages.sAnagramScoresArchived, 0)
	end
	
end


----------------------------------------------------------------------------
-- Function Anagrams Trigger
----------------------------------------------------------------------------
function TriggerAnagrams()
gsFunction = "TriggerAnagrams"

	AnagramHint()

end


----------------------------------------------------------------------------
-- Function Anagrams Trigger
----------------------------------------------------------------------------
function TriggerAnagramsAutoStart()
gsFunction = "TriggerAnagramsAutoStart"
	
	AnagramAutoStart()
	
end


----------------------------------------------------------------------------
-- Function Anagrams Trigger Bonus Time
----------------------------------------------------------------------------
function TriggerAnagramsBonus()
gsFunction = "TriggerAnagramsBonus"

	iBonusTime = iBonusTime - 1
	if iBonusTime == 0 then
		TmrMan.RemoveTimer(tTimers.TriggerAnagramsBonus)
		tTimers.TriggerAnagramsBonus = nil
	end
	
end


----------------------------------------------------------------------------
-- Function Anagrams Trigger Bonus Time
----------------------------------------------------------------------------
function TriggerAnagramsQPause()
gsFunction = "TriggerAnagramsQPause"

	AnagramQuestionPause()
	
end


----------------------------------------------------------------------------
-- Function Anagrams Trigger Time Out
----------------------------------------------------------------------------
function TriggerAnagramsTimeOut()
gsFunction = "TriggerAnagramsTimeOut"

	AnagramTimeOut()
	
end


----------------------------------------------------------------------------
-- Function Anagrams Maintain Players
----------------------------------------------------------------------------
function AnagramsMaintainPlayers(user, data, sMode)
gsFunction = "AnagramsMaintainPlayers"
	
	local _,_,sWhere = string.find(data, "%$To:%s(%S+)")
	local sMessage, sNotifyMessage, sLowerUser = "", nil, string.lower(user.sNick)
	
	if sMode == "S" then
		sMessage = "\r\n\r\n\t\t"..string.rep(tGeneralSettings.sBorder, 25).."\r\n\t\t"..tGeneralSettings.sBorder.."\t\t"..
				tScriptMessages.sAnagramsPlayers.."\r\n\t\t"..string.rep(tGeneralSettings.sBorder, 25).."\r\n\t\t"..
				tGeneralSettings.sBorder.."\r\n"
		for i,v in pairs(tAnagramPlayers) do
			sMessage = sMessage.."\t\t"..tGeneralSettings.sBorder.."\t "..i.."\r\n"
		end
		sMessage = sMessage.."\t\t"..tGeneralSettings.sBorder.."\r\n\t\t"..string.rep(tGeneralSettings.sBorder, 25).."\r\n\r\n"
	elseif sMode == "J" then
		if tAnagramPlayers[sLowerUser] then
			sMessage = tScriptMessages.sAnagramsJoinAlready
		else
			tAnagramPlayers[sLowerUser] = 1
			sMessage = tScriptMessages.sAnagramsJoinUser
			sNotifyMessage = string.gsub(tScriptMessages.sAnagramsJoinOp, "!user!", user.sNick)
		end
	elseif sMode == "L" then
		if tAnagramPlayers[sLowerUser] then
			tAnagramPlayers[sLowerUser] = nil
			sMessage = tScriptMessages.sAnagramsLeaveUser
			sNotifyMessage = string.gsub(string.gsub(tScriptMessages.sAnagramsLeaveOp, "!user!", user.sNick), "!nick!")
		else
			sMessage = tScriptMessages.sAnagramsJoinNot
		end
	else
		local _,_,sUser = string.find(data, "%b<>%s+%S+%s+(%S+)")
		sLowerUser = string.lower(sUser)
		if sMode == "A" then
			if tAnagramPlayers[sLowerUser] then
				sMessage = tScriptMessages.sAnagramsAddAlready
			else
				tAnagramPlayers[sUser] = 1
				sMessage = string.gsub(tScriptMessages.sAnagramsAddUser, "!nick!", user.sNick)
				sNotifyMessage = string.gsub(string.gsub(tScriptMessages.sAnagramsAddOp, "!user!", sLowerUser), "!nick!", user.sNick)
			end
		elseif sMode == "D" then
			if tAnagramPlayers[sLowerUser] then
				tAnagramPlayers[sUser] = nil
				sMessage = string.gsub(tScriptMessages.sAnagramsRemoveUser, "!nick!", user.sNick)
				sNotifyMessage = string.gsub(string.gsub(tScriptMessages.sAnagramsRemoveOp, "!user!", sLowerUser), "!nick!", user.sNick)
			else
				sMessage = tScriptMessages.sAnagramsAddNot
			end
		end
	end
	
	local bInMain = 1
	if sWhere then bInMain = 0 end
	SendMessage(sLowerUser, tBots.tAnagrams.sName, sMessage, bInMain)
	
	if sNotifyMessage then
		local i,v = nil,nil
		for i,v in pairs(tAnagramPlayers) do
			if i ~= sLowerUser then SendMessage(i, tBots.tAnagrams.sName, sNotifyMessage, 0) end
		end
		SaveFile(tSettingPaths.sAnagramPlayers, tAnagramPlayers, "tAnagramPlayers")
	end
	
end


----------------------------------------------------------------------------
-- Function Anagrams Maintain Players
----------------------------------------------------------------------------
function AnagramsShowArchive(user, data)
gsFunction = "AnagramsShowArchive"
	
	local sMessage, bInMain = "", 1
	local _,_,sArchive = string.find(data,"%b<>%s+%S+%s+(%S+)")
	local _,_,sWhere = string.find(data, "%$To:%s(%S+)")
	if sWhere then bInMain = 0 end
	
	if sArchive then
		sMessage = "\r\n\r\n\t\t"..string.rep(tGeneralSettings.sBorder, 40).."\r\n\t\t"..tGeneralSettings.sBorder.."\t Anagrams Scores from "..
				sArchive.."\r\n\t\t"..string.rep(tGeneralSettings.sBorder, 40).."\r\n\t\t"..tGeneralSettings.sBorder.."\r\n"
		LoadFile({string.gsub(tSettingPaths.sAnagramScoresArchive[1], "!filename!", sArchive)},1)
		for i,v in ipairs(tAnagramScoresArchive) do
			sMessage = sMessage.."\t\t"..tGeneralSettings.sBorder.."\tRank. "..i.."\t\tScore. "..v[2].."\t\t"..v[1].."\r\n"
		end
		sMessage = sMessage.."\t\t"..tGeneralSettings.sBorder.."\r\n\t\t"..string.rep(tGeneralSettings.sBorder, 40).."\r\n\r\n"
	else
		sMessage = string.gsub(tScriptMessages.sAnagramsArchiveNot, "!archive!", (sArchive or ""))
	end
	
	SendMessage(user.sNick, tBots.tAnagrams.sName, sMessage, bInMain)
	
end
