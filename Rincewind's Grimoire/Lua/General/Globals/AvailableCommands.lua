


----------------------------------------------------------------------------
-- Function Show Available Commands
----------------------------------------------------------------------------
function AvailableCommandsShow(user)
	
	Core.GetUserAllData(user)
	
	local sRCText, sMessage, sLowerUser = "", "", string.lower(user.sNick)
	
	sMessage = "\r\n\t"..string.rep(tGeneralSettings.sBorder, 60).."\r\n\t"..tGeneralSettings.sBorder.."\t\t\t\tAvailable Commands\r\n\t"
	sMessage = sMessage..string.rep(tGeneralSettings.sBorder, 60).."\r\n\t"..tGeneralSettings.sBorder
	
	if user.iProfile < 0 then
		if tSwitches.bRegistration == 1 then
			if tRegistrationSettings.bAllowRegme == 1 then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sRegme.." [password]\t\t\t - Register with hub"
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder
			end
		end
	end
	
	sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..string.lower(gsProduct).."\t\t\t\t\t - See Available Commands"
	
	-- communication
	if tSwitches.bAutoCorrect == 1 then
		if tAutoCorrectSettings.tEnabledProfiles[user.iProfile] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sAutoCorrectAdd.." [word to add] [replacement word]\t - Add word to Auto Correct for replacement"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sAutoCorrectDelete.." [word to delete]\t\t\t - Delete word from Auto Correct"
		end
	end
	
	if tSwitches.bMassMessage == 1 then
		if tMassMessageSettings[user.iProfile].All == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sMass.." [message]\t\t\t\t - Mass Message to All"
		end
		if tMassMessageSettings[user.iProfile][-1] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sMassProfile.." [profile number] [message]\t\t - Mass Message to Selected Profile"
		end
		if tMassMessageSettings[user.iProfile].Operator == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sMassOps.." [message]\t\t\t - Mass Message to Operators"
		end
		if tMassMessageSettings[user.iProfile].Banner == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sBanner.." [message]\t\t\t\t - Mass Message Banner"
		end
		if tMassMessageSettings[user.iProfile].Passive == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sMassPassive.."\t\t\t\t - Mass Message to Passive Users"
		end
		if tMassMessageSettings.tEnabledPassiveProfiles[user.iProfile] == 1 then
			-- hub commands
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sAddPassImmune.." [nick]\t\t\t - Add User to Mass Message Passive Immune List"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sRemPassImmune.." [nick]\t\t\t - Remove User from Mass Message Passive Immune List"
		end
	end
	if tSwitches.bMute == 1 then
		if tMute[-1][user.iProfile] == 1 then
			-- hub commands
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sMute.." [nick]\t\t\t\t - Mute"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sUnmute.." [nick]\t\t\t\t - Unmute"
		end
	end
	if tSwitches.bTalk == 1 then
		if tTalk[-1][user.iProfile] == 1 then
			-- hub commands
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sTalk.." [nick] [message]\t\t\t - Talk as User"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sTalk.." [message]\t\t\t\t - Talk"
		end
	end
	if tSwitches.bRotatingMainMessage == 1 then
		if tRotatingMainMessageSettings.tEnabledAdProfiles[user.iProfile] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sAdvert.." [advert]\t\t\t\t - Send Advert in Main"
		end
	end
	if tSwitches.bRotatingPrivateMessage == 1 then
		if tRotatingPrivateMessageSettings.tEnabledAdProfiles[user.iProfile] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sPMAdvert.." [advert]\t\t\t\t - Send Advert in PM"
		end
		if tRotatingPrivateMessageSettings.tEnabledMaintainProfiles[user.iProfile] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sRotatingPrivateMessageShowImmune.."\t\t\t\t - Show Rotating PM Immune Users List"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sRotatingPrivateMessageAddImmune.." [nick]\t\t\t - Add User to Rotating PM Immune List"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sRotatingPrivateMessageDelImmune.." [nick]\t\t\t - Delete User from Rotating PM Immune List"
		end
	end
	if tSwitches.bWhisper == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sWhisper.." [nick] [message]\t\t\t - Whisper to Another User"
	end
	
	-- customise user
	if tSwitches.bDescriptionTags == 1 then
		if tDescriptionTagSettings.tEnabledProfiles[user.iProfile] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sAddTag.." [nick] [new tag]\t\t\t - Add New Description Tag"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sDelTag.." [nick]\t\t\t\t - Delete Description Tag"
		end
	end
	if tSwitches.bHideShare == 1 then
		if tHideShareSettings.tEnabledProfiles[user.iProfile] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sAddHiddenShare.."\t\t\t\t\t - Hide Share"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sDelHiddenShare.."\t\t\t\t\t - Unhide Share"
		end
	end
	if tSwitches.bIntroOutro == 1 then
		if tCustomIntroOutroSettings.tEnabledProfiles[user.iProfile] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sSetIntro.." [intro]\t\t\t\t - Set Own Intro"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sSetOutro.." [outro]\t\t\t\t - Set Own Outro"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sDelIntro.."\t\t\t\t\t - Delete Own Intro"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sDelOutro.."\t\t\t\t\t - Delete Own Outro"
			-- other user's intro
			if user.bOperator then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
						tScriptCommands.sSetUserIntro.." [nick] [intro]\t\t\t - Set User's Intro"
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
						tScriptCommands.sSetUserIntro.." [nick] [intro]\t\t\t - Set User's Outro"
				
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
						tScriptCommands.sDelUserOutro.." [nick]\t\t\t\t - Delete User's Intro"
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
						tScriptCommands.sDelUserOutro.." [nick]\t\t\t\t - Delete User's Outro"
				
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
						tScriptCommands.sShowIntro.."\t\t\t\t - Show Intros"
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
						tScriptCommands.sShowOutro.."\t\t\t\t - Show Outros"
				
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
						tScriptCommands.sSetAsciiIntro.." [nick] [filename]\t\t\t - Set Ascii Intro for User"
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
						tScriptCommands.sDelAsciiIntro.." [nick]\t\t\t\t - Delete User's Outro"
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
						tScriptCommands.sShowAsciiIntro.."\t\t\t\t - Show Ascii Intros"
			end
		end
	end
	
	-- games
	if tSwitches.bAnagrams == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sAnStart.."\t\t\t\t\t - Start Anagrams"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sAnStop.."\t\t\t\t\t - Stop Anagrams"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sAnScores.."\t\t\t\t - Show Anagram Scores"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sAnAllScores.."\t\t\t\t - Show All Anagram Scores"
		if tScoreClearers[string.lower(sLowerUser, 1)] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sAnClear.."\t\t\t\t\t - Clear Anagram Scores"
		end
		if tAnagramSettings.bPlayInMain == 0 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sAnJoin.."\t\t\t\t\t - Join Anagrams"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sAnLeave.."\t\t\t\t\t - Leave Anagrams"
			if user.bOperator then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
						tScriptCommands.sAnAdd.." [nick]\t\t\t\t - Add User to Anagrams"
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
						tScriptCommands.sAnRemove.." [nick]\t\t\t\t - Remove User from Anagrams"
			end
		end
	end
	if tSwitches.bCodeBreaker == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCodeBreakerStart.."\t\t\t\t\t - Start CodeBreaker"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCodeBreakerStop.."\t\t\t\t\t - Stop CodeBreaker"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCodeBreakerScores.."\t\t\t\t - Show CodeBreaker Scores"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCodeBreakerAllScores.."\t\t\t\t - Show All CodeBreaker Scores"
		if tScoreClearers[string.lower(sLowerUser, 1)] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCodeBreakerClear.."\t\t\t\t\t - Clear CodeBreaker Scores"
		end
		if tCodeBreakerSettings.bPlayInMain == 0 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCodeBreakerJoin.."\t\t\t\t\t - Join CodeBreaker"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCodeBreakerLeave.."\t\t\t\t\t - Leave CodeBreaker"
			if user.bOperator then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCodeBreakerAdd.." [nick]\t\t\t\t - Add User to CodeBreaker"
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCodeBreakerRemove.." [nick]\t\t\t\t - Remove User from CodeBreaker"
			end
		end
	end
	if tSwitches.bGuessTheNumber == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGStart.."\t\t\t\t\t - Start GuessTheNumber"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGStop.."\t\t\t\t\t - Stop GuessTheNumber"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGScores.."\t\t\t\t\t - Show GuessTheNumber Scores"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGAllScores.."\t\t\t\t - Show All GuessTheNumber Scores"
		if tScoreClearers[string.lower(sLowerUser, 1)] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGClear.."\t\t\t\t\t - Clear GuessTheNumber Scores"
		end
		if tGuessTheNumberSettings.bPlayInMain == 0 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGJoin.."\t\t\t\t\t - Join GuessTheNumber"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGLeave.."\t\t\t\t\t - Leave GuessTheNumber"
			if user.bOperator then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGAdd.." [nick]\t\t\t\t - Add User to GuessTheNumber"
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGRemove.." [nick]\t\t\t\t - Remove User from GuessTheNumber"
			end
		end
	end
	if tSwitches.bHangman == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sHangStart.."\t\t\t\t\t - Start Hangman"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sHangStop.."\t\t\t\t\t - Stop Hangman"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sHangScores.."\t\t\t\t\t - Show Hangman Scores"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sHangAllScores.."\t\t\t\t - Show All Hangman Scores"
		if tScoreClearers[string.lower(sLowerUser, 1)] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sHangClear.."\t\t\t\t\t - Clear Hangman Scores"
		end
		if tHangmanSettings.bPlayInMain == 0 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sHangJoin.."\t\t\t\t\t - Join Hangman"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sHangLeave.."\t\t\t\t\t - Leave Hangman"
			if user.bOperator then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sHangAdd.." [nick]\t\t\t\t - Add User to Hangman"
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sHangRemove.." [nick]\tt\t\t\t - Remove User from Hangman"
			end
		end
	end
	if tSwitches.bNumbers == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sNumStart.."\t\t\t\t\t - Start Numbers"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sNumStop.."\t\t\t\t\t - Stop Numbers"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sNumScores.."\t\t\t\t - Show Numbers Scores"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sNumAllScores.."\t\t\t\t - Show All Numbers Scores"
		if tScoreClearers[string.lower(sLowerUser, 1)] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sNumClear.."\t\t\t\t - Clear Numbers Scores"
		end
		if tNumbersSettings.bPlayInMain == 0 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sNumJoin.."\t\t\t\t\t - Join Numbers"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sNumLeave.."\t\t\t\t - Leave Numbers"
			if user.bOperator then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sNumAdd.." [nick]\t\t\t\t - Add User to Numbers"
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sNumRemove.." [nick]\t\t\t\t - Remove User from Numbers"
			end
		end
	end
	-- russian roulette
	if tSwitches.bRussianRoulette == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sLoadGun.."\t\t\t\t\t - Load Gun"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sUnloadGun.."\t\t\t\t - Unload Gun"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sRounds.." [rounds]\t\t\t\t - Select Number of Rounds (1-5)"
	end
	-- slot machine
	if tSwitches.bSlotMachine == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sSlotsAccount.."\t\t\t\t\t - Open SlotMachine Account"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sSlotsStatus.."\t\t\t\t\t - Check SLotMachine Account Status"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sSlotsSlot.."\t\t\t\t\t - Play SlotMachine"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sSlotsLoan.." [loan value]\t\t\t\t - Take SlotMachine Load"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sSlotsRepay.." [repayment value]\t\t\t - Repay SlotMachine Loan"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sSlotsRank.."\t\t\t\t\t - Check SlotMachine Rank"
	end
	if tSwitches.bThreeCardMonty == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sStartMonty.."\t\t\t\t - Start ThreeCardMonty"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sStopMonty.."\t\t\t\t - Stop ThreeCardMonty"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sChooseMonty.." [card]\t\t\t\t - Choose Card (1-3)"
	end
	if tSwitches.bTrivia == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sTrivStart.."\t\t\t\t\t - Start Trivia"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sTrivStop.."\t\t\t\t\t - Stop Trivia"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sHint.."\t\t\t\t\t - Show Trivia Hint"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sTrivScores.."\t\t\t\t - Show Trivia Scores"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sTrivAllScores.."\t\t\t\t - Show All Trivia Scores"
		if tScoreClearers[string.lower(sLowerUser, 1)] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sTrivClear.."\t\t\t\t\t - Clear Trivia Scores"
		end
		if tTriviaSettings.bPlayInMain == 0 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sTrivJoin.."\t\t\t\t\t - Join Trivia"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sTrivLeave.."\t\t\t\t\t - Leave Trivia"
			if user.bOperator then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sTrivAdd.." [nick]\t\t\t\t - Add User to Trivia"
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sTrivRemove.." [nick]\t\t\t\t - Remove User from Trivia"
			end
		end
	end
	if tSwitches.bTrivia == 1 or tSwitches.bNumbers == 1 or tSwitches.bAnagrams == 1 or tSwitches.bGuessTheNumber == 1 or tSwitches.bHangman == 1 or tSwitches.bCodeBreaker == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sScores.."\t\t\t\t\t - Show Scores"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sAllScores.."\t\t\t\t\t - Show All Scores"
	end
	if tScoreClearers[string.lower(user.sNick)] == 1 then
		-- clear game scores
		if tSwitches.bTrivia == 1 or tSwitches.Numbers == 1 or tSwitches.bAnagram == 1 
						or tSwitches.bGuess == 1 or tSwitches.bHangman == 1 
						or tSwitches.bCodeBreaker == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sClearScores.."\t\t\t\t - Clear All Game Scores"
		end
	end
	
	-- general
	if tBotSettings.tEnabledProfiles[user.iProfile] == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetBotName.." [function]\t\t\t - Get Bot Name"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetBotDesc.." [function]\t\t\t - Get Bot Description"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetBotEmail.." [function]\t\t\t - Get Bot Email"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetBotName.." [function] [new name]\t\t - Set Bot Name"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetBotDesc.." [function] [new desc]\t\t - Set Bot Description"
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetBotEmail.." [function] [new email]\t\t - Set Bot Email"
	end
	sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
			tScriptCommands.sChangeLog.."\t\t\t\t - Show ChangeLog"
	
	-- security
	if tSwitches.bCloneBlocker == 1 then
		if tCloneBlockerSettings.tEnabledProfiles[user.iProfile] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCloneShowExempt.."\t\t\t\t - Show Exempt Clones List"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCloneAddExempt.." [nick]\t\t\t\t - Add User to Exempt Clones List"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCloneDelExempt.." [nick]\t\t\t\t - Remove User From Exempt Clones List"
		end
	end
	if tSwitches.bCommandSpy == 1 then
		if tCommandSpySettings.tEnabledProfiles[user.iProfile] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCommandSpy.."\t\t\t\t\t - Toggle Command Spy On/Off"
		end
	end
	if tSwitches.bKicks == 1 then
		if CheckRightClickKickPermissions(user, "D") == true then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sDrop.." [nick] [reason]\t\t\t - Disconnect User"
		end
		if CheckRightClickKickPermissions(user, "W") == true then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sWarn.." [nick] [reason]\t\t\t - Warn User"
		end
		if CheckRightClickKickPermissions(user, "K") == true then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sKick.." [nick] [reason]\t\t\t - Kick USer"
		end
		if CheckRightClickKickPermissions(user, "T") == true then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sTimeBan.." [nick] [ban length (hh:mm)] [reason]\t - TimeBan User"
		end
		if CheckRightClickKickPermissions(user, "B") == true then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sBan.." [nick] [reason]\t\t\t\t - Ban User"
		end
		if CheckRightClickKickPermissions(user, "U") == true then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sUnban.." [nick]\t\t\t\t - Unban User"
		end
		if CheckRightClickKickPermissions(user, "K") == true then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sTopKickers.."\t\t\t\t - Show TopKickers"
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sShowKickLog.."\t\t\t\t - Show KickLog"
		end
	end
	-- flood
	--[[
	if tSwitches.bFlood == 1 then
		if tFloodSettings[user.iProfile][-1] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sFlood.." [Nick]\t\t - "
		end
	end
	-- main block
	if tSwitches.bMainBlock== 1 then
		if tMainBlockSettings.tEnabledProfiles[user.iProfile] == 1 then
			sMessage = string.gsub(tScriptRightClick.sBlockForX, "!time!", tMainBlockSettings.iBlockTime)
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sBlock.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sPermBlock.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sUnblock.."\t\t - "
		end
	end
	if tSwitches.bMainCleaner == 1 then
		if tMainCleanerSettings.tEnabledProfiles[user.iProfile] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sClearScreen.."\t\t - "
		end
	end
	-- main lock
	if tSwitches.bMainLock == 1 then
		if tMainLockSettings.tEnabledProfiles[user.iProfile] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sLockMain.."\t\t - "
		end
	end
	-- profile rules			
	if tSwitches.bProfileRules == 1 then
		if tProfileRuleSettings.tEnabledGetProfiles[user.iProfile] == 1 then
				-- hub and slot rules
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMaxHubs.." -1\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMaxSlots.." -1\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMinSlots.." -1\t\t - "
		
			--  share rules
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMaxShare.." -1\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMinShare.." -1\t\t - "
			for i,v in ipairs(ProfMan.GetProfiles()) do
				-- hub and slot rules
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMaxHubs.." "..v.iProfileNumber.."\t\t - "
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMaxSlots.." "..v.iProfileNumber.."\t\t - "
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMinSlots.." "..v.iProfileNumber.."\t\t - "
			
				--  share rules
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMaxShare.." "..v.iProfileNumber.."\t\t - "
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMinShare.." "..v.iProfileNumber.."\t\t - "
			end
			
			-- share redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMinShareRedirect.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMaxShareRedirect.."\t\t - "
			
			-- slots redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMinSlotsRedirect.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMaxSlotsRedirect.."\t\t - "
			
			-- max hub redirect address
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileMaxHubsRedirect.."\t\t - "
			
			-- ratio redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileHubSlotRatioRedirect.."\t\t - "
			
			-- all redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetProfileAllRedirect.."\t\t - "
		end
		if tProfileRuleSettings.tEnabledSetProfiles[user.iProfile] == 1 then
			-- hub and slot rules
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMaxHubs.." -1 [New Max Hubs]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMaxSlots.." -1 [New Max Hubs]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMinSlots.." -1 [New Max Hubs]\t\t - "
		
			--  share rules
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMaxShare.." -1 [New Min Share] [New Units]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMinShare.." -1 [New Min Share] [New Units]\t\t - "
			for i,v in ipairs(ProfMan.GetProfiles()) do
				-- hub and slot rules
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMaxHubs.." "..v.iProfileNumber.." [New Max Hubs]\t\t - "
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMaxSlots.." "..v.iProfileNumber.." [New Max Hubs]\t\t - "
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMinSlots.." "..v.iProfileNumber.." [New Max Hubs]\t\t - "
			
				--  share rules
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMaxShare.." "..v.iProfileNumber.." [New Min Share] [New Units]\t\t - "
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMinShare.." "..v.iProfileNumber.." [New Min Share] [New Units]\t\t - "
			end
			
			-- share redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMinShareRedirect.." [New Profile Min Share Redirect Address]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMaxShareRedirect.." [New Profile Max Share Redirect Address]\t\t - "
			
			-- slots redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMinSlotsRedirect.." [New Profile Min Slots Redirect Address]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMaxSlotsRedirect.." [New Profile Max Slots Redirect Address]\t\t - "
			
			-- max hub redirect address
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileMaxHubsRedirect.." [New Profile Max Hubs Redirect Address]\t\t - "
			
			-- ratio redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileHubSlotRatioRedirect.." [New Profile Hub/Slot Ratio Redirect Address]\t\t - "
			
			-- all redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSetProfileAllRedirect.." [Specify new value]\t\t - "
			
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sShowRedirects.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sShowRedirectCounter.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sClearRedirectCounter.."\t\t - "
			
			if tProfileRuleSettings.bAllowExempt == 1 then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sProfileRulesAddExempt.." [nick]\t\t - "
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sProfileRulesDelExempt.." [nick]\t\t - "
			end
		end
	end
	-- ptokax settings
	if tSwitches.bPtokaXSettings == 1 then
		if tPtokaXSettings.tEnabledGetProfiles[user.iProfile] == 1 then
			-- hub stuff
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetHubName.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetHubDesc.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetHubTopic.."\t\t - "
			
			-- hub bot
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetHubBotName.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetHubBotDesc.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetHubBotEmail.."\t\t - "
			
			-- opchat
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetOpChatName.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetOpChatDesc.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetOpChatEmail.."\t\t - "
			
			-- hub stuff
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetHubVersion.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetHubUptime.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetHubAddress.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetHubIP.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetHubPort.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetMaxUsersPeak.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetActualUsersPeak.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetUsers.." -1\t\t - "
			for i,v in ipairs(ProfMan.GetProfiles()) do
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetUsers.." "..v.iProfileNumber.."\t\t - "
			end
			
			-- hub and slot rules
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetMaxHubs.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetMaxSlots.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetMinSlots.."\t\t - "
			
			-- user and share rules
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetMaxUsers.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetMaxShare.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetMinShare.."\t\t - "
			
			-- redirects all or full
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetRedirectAll.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetRedirectFull.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetRedirectAddress.."\t\t - "
			
			-- share redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetShareRedirect.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetShareRedirectAddress.."\t\t - "
			
			-- slots redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetSlotsRedirect.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetSlotsRedirectAddress.."\t\t - "
			
			-- ratio redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetRatioRedirect.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetRatioRedirectAddress.."\t\t - "
			
			-- max hubs redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetMaxHubsRedirect.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetMaxHubsRedirectAddress.."\t\t - "
			
			-- nick rule redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetNickRuleRedirect.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetNickRuleRedirectAddress.."\t\t - "
			
			-- ban redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetBanRedirect.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetBanRedirectAddress.."\t\t - "
			
			-- temp ban redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetTempBanRedirect.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetTempBanRedirectAddress.."\t\t - "
			
			-- all redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltGetAllRedirect.."\t\t - "
		end
		if tPtokaXSettings.tEnabledSetProfiles[user.iProfile] == 1 then
			-- hub stuff
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetHubName.." [New Hub Name]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetHubDesc.." [New Hub Description]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetHubTopic.." [New Hub Topic]\t\t - "
			
			-- hub bot
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetHubBotName.." [New Hub Bot Name]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetHubBotDesc.." [New Hub Bot Description]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetHubBotEmail.." [New Hub Bot Email]\t\t - "
			
			-- opchat
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetOpChatName.." [New Op Chat Name]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetOpChatDesc.." [New Op Chat Description]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetOpChatEmail.." [New Op Chat Email]\t\t - "
			
			-- hub and slot rules
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetMaxHubs.." [New Max Hubs]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetMaxSlots.." [New Max Slots]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetMinSlots.." [New Min Slots]\t\t - "
			
			-- user and share rules
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetMaxUsers.." [New Max Users]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetMaxShare.." [New Max Share] [New Units]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetMinShare.." [New Min Share] [New Units]\t\t - "
			
			-- redirects all or full
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetRedirectAll.." [New Redirect All Switch Setting (1/0)]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetRedirectFull.." [New Redirect Full Switch Setting (1/0)]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetRedirectAddress.." [New Redirect Address]\t\t - "
			
			-- share redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetShareRedirect.." [New Share Redirect Switch Setting (1/0)]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetShareRedirectAddress.." [New Share Redirect Address]\t\t - "
			
			-- slots redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetSlotsRedirect.." [New Slots Redirect Switch Setting (1/0)]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetSlotsRedirectAddress.." [New Slots Redirect Address]\t\t - "
			
			-- ratio redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetRatioRedirect.." [New Ratio Redirect Switch Setting (1/0)]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetRatioRedirectAddress.." [New Ratio Redirect Address]\t\t - "
			
			-- max hubs redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetMaxHubsRedirect.." [New Max Hubs Redirect Switch Setting (1/0)]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetMaxHubsRedirectAddress.." [New Max Hubs Redirect Address]\t\t - "
			
			-- nick rule redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetNickRuleRedirect.." [New Nick Rule Redirect Switch Setting (1/0)]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetNickRuleRedirectAddress.." [New Nick Rule Redirect Address]\t\t - "
			
			-- ban redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetBanRedirect.." [New Ban Redirect Switch Setting (1/0)]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetBanRedirectAddress.." [New Ban Redirect Address]\t\t - "
			
			-- temp ban redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetTempBanRedirect.." [New Temp Ban Redirect Switch Setting (1/0)]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetTempBanRedirectAddress.." [New Temp Ban Redirect Address]\t\t - "
			
			-- all redirects
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInbuiltSetAllRedirect.." [New All Redirect Address]\t\t - "
		end
	end
	-- registration
	if tSwitches.bRegistration == 1 then
		-- hub commands
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetOwnPass.."\t\t - "
		if tRegistrationGetPassword[user.iProfile][3] then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetPass.." [nick]\t\t - "
		end
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sChangeOwnPass.." [Password]\t\t - "
		if tRegistrationChangePassword[user.iProfile][3] then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sChangePass.." [nick] [Password]\t\t - "
		end
		--if user.bOperator then
			SendMessage(user.sNick, "rc", "$UserCommand 0 1|", 1)
			for i,v in ipairs(ProfMan.GetProfiles()) do
				if tRegistrationAdd[user.iProfile][v.iProfileNumber] == 1 then
					sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sAddReg.." [nick] [Password] "..v.iProfileNumber.."\t\t - "
				end
			end
			for i,v in ipairs(ProfMan.GetProfiles()) do
				if tRegistrationAdd[user.iProfile][v.iProfileNumber] == 1 then
					sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sChangeReg..
							" [nick] "..v.iProfileNumber.."\t\t - "
				end
			end
			if tRegistrationDelete[user.iProfile][3] == 1 then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sDelReg.." [nick]\t\t - "
			end
			-- user commands
			SendMessage(user.sNick, "rc", "$UserCommand 1 2 "..sRCText..tScriptRightClick.sGetOwnPass.."$<[mynick]> "..
					tGeneralSettings.sPrefix..tScriptCommands.sGetOwnPass.."\t\t - "
		if tRegistrationGetPassword[user.iProfile][3] then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sGetPass.." [nick]\t\t - "
		end
		SendMessage(user.sNick, "rc", "$UserCommand 1 2 "..sRCText..tScriptRightClick.sChangeOwnPass.."$<[mynick]> "..
				tGeneralSettings.sPrefix..tScriptCommands.sChangeOwnPass.." [Password]\t\t - "
		if tRegistrationChangePassword[user.iProfile][3] then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sChangePass.." [nick] [Password]\t\t - "
		end
		SendMessage(user.sNick, "rc", "$UserCommand 0 2|", 1)
		for i,v in ipairs(ProfMan.GetProfiles()) do
			if tRegistrationAdd[user.iProfile][v.iProfileNumber] == 1 then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sAddReg.." [nick] [Password] "..v.iProfileNumber.."\t\t - "
			end
		end
		for i,v in ipairs(ProfMan.GetProfiles()) do
			if tRegistrationAdd[user.iProfile][v.iProfileNumber] == 1 then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sChangeReg..
						" [nick] "..v.iProfileNumber.."\t\t - "
			end
		end
		if tRegistrationDelete[user.iProfile][3] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sDelReg.." [nick]\t\t - "
		end
		if tRegistrationAdd[user.iProfile][3] == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sRegistrationLogShow.." [nick]\t\t - "
		end
	end
	if tSwitches.bReport == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sReport.." [nick] [Message]\t\t - "
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sReport.." [nick] [Message]\t\t - "
	end
	if tSwitches.bRules == 1 then
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sRules.."\t\t - "
	end
	if tSwitches.bSearchSpy == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sSearchSpyAddFile.." [action (w,d,n,k,b][file] \t\t - "
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sSearchSpyRemoveFile.." [file]\t\t - "
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
				tScriptCommands.sSearchSpyShowFiles.."\t\t - "
	end
	if tSwitches.bUserLog == 1 then
		if tUserLogSettings.tEnabledProfiles[user.iProfile] == 1 then
			if tUserLogSettings.bLogToFile == 1 then
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
						tScriptCommands.sShowLog.."\t\t - "
			end
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sTopHubbers.."\t\t - "
			
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sShowImmune.."\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sAddImmune.." [nick]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sAddImmune.." [nick]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sDelImmune.." [nick]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sDelImmune.." [nick]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sClearUserLog.." [nick]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
					tScriptCommands.sShowInfo.." [nick]\t\t - "
		end
	end
	
	-- user actions
	if tSwitches.bAscii == 1 then
		if tAsciiSettings.tEnabledProfiles[user.iProfile] == 1 and tAsciiSettings.tEnabledRC[user.iProfile] == 1 then
			for i = 1, table.getn(tAsciiIndex) do
				sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..
							tScriptCommands.sAscii.." "..tAsciiIndex[i].sFilename.."\t\t - "
			end
		end
	end
	if tSwitches.bAttacks == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sAttack.." [nick]\t\t - "
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sAttack.." [nick]\t\t - "
	end
	if tSwitches.bCalculator == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sCalc.." [Variable x] [Symbol] [Variable y]\t\t - "
	end
	if tSwitches.bClock == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sTime.." \t\t - "
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sTime.." \t\t - "
	end
	if tSwitches.bDoAction == 1 then
		for i,v in pairs(tDoAction) do
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sDo.." "..i.."\t\t - "
		end
	end
	if tSwitches.bInsults == 1 then
		-- insults
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInsult.." [nick]\t\t - "
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sInsult.." [nick]\t\t - "
		-- medieval insult
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sMedInsult.." [nick]\t\t - "
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sMedInsult.." [nick]\t\t - "
		-- modern insults
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sModInsult.." [nick]\t\t - "
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sModInsult.." [nick]\t\t - "
	end
	if tSwitches.bJokes == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sJoke.."\t\t - "
	end
	if tSwitches.bLimericks == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sLimerick.."\t\t - "
	end
	if tSwitches.bProverbs == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sProverb.."\t\t - "
	end
	if tSwitches.bQuotations == 1 then
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sQuotation.."\t\t - "
	end
	if tSwitches.bSpells == 1 then
		for i,v in pairs(tSpellBook) do
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSpell.." "..i.." [nick]\t\t - "
			sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sSpell.." "..i.." [nick]\t\t - "
		end
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sUnchange.." [nick]\t\t - "
		sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix..tScriptCommands.sUnchange.." [nick]\t\t - "
	end
	sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\t"..tGeneralSettings.sPrefix.."ver\t\t - "
	]]
	
	sMessage = sMessage.."\r\n\t"..tGeneralSettings.sBorder.."\r\n\t"..string.rep(tGeneralSettings.sBorder, 60)
	
	SendMessage(user.sNick, tBots.tMain.sName, sMessage, 1)
end