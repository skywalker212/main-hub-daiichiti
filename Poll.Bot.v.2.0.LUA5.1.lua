-- Poll.Bot.v.1.3c in LUA 5.1
-- Finally a good pollbot ;-)
-- Created by TTB on 08 November 2006
-- For PtokaX 0.4.0.0 or higher since 12.06.08

-- v.1.1: 
-- [Fixed] Little bugs
-- v.1.2: 
-- [Added] Graph bars on current poll
-- [Fixed] Little bugs
-- v.1.3: 
-- [Added] Graph bars on oldpolls
-- [Added] Multiple votes for poll (#polladd edit!)
-- [Added] #pollusers - who voted already?
-- v.1.3b:
-- [Conversion] 5.02 to 5.1
-- v.1.3c: 12.06.08
-- [Conversion] Quick Convert to API2, By Madman
-- v1.3d: 26.06.08
-- [Fixed] #pollhelp, reported T.C.M
-- [Fixed] Reg don't Rightclick, reported by miago
-- [Fixed] 'SendPmToUser' (3 expected, got 2) bug, reported by miago
-- [Fixed] bug when trying to create poll, reported by miago
-- v1.3e: 29.06.08
-- [Fixed] Fixed buwg, when showing current user as created when checking #pollusers, reported by miago
-- v1.3f: 12.07.08
-- [Fixed] bug with WriteFile, files saved at wrong path
-- v1.3g: 12.07.08
-- [Fixed] SendToPmUser error in OldPoll
-- v1.3h: 21.07.08
-- [Changed] New #oldpoll layout
-- v1.4: 23.07.08
-- [Added] Option to disallow users from voteing on same answer more then once, request by dimetrius
-- [Changed] Layout of pollvotes table
--[[-- !IMPORTANT!
The new layout makes the pollvotes table invalid.
So BEFORE upgrade to 1.4, finsih your current running poll,
or all users will be able to vote again!
--]]--
-- [Removed] UserDisconnected function, it did not do anything
-- [Fixed] Bug in pollusers, due to new pollvotes
-- v1.4a: 25.07.08
-- [Fixed] Pollanswers got unsorted, thanks dimetrius for fix
-- v2.0: 15.08.08
-- [Fixed] bug in sorting poll
-- [Changed] Align of votes, thanks to fodin for code
-- [Added] FullBars option, code from fodin
-- [Added] ShowShare option, code from fodin
-- [Added] Tabel for language
-- [Changed] lanuage moved to file
-- [Changed] Path to files, now default to scripts/Poll/file
-- [Added] Commands can now be translated
-- [Added] Fully supported multi lang
-- v2.0: 12.10.08
-- [Fixed] typo in RC
-- v2.0: 27.02.09
-- [Fixed] another typo in RC

----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--------------------------------------------------------------------
--[[ 
There are many features on this bot. When a bot has been created, everyone only gets a PM. When ppl log into the hub, they will get a PM if they did not vote already. 
Just check it out... if you have special requests, post them. I always can see what I can do :-)

Your commands:

All users:
#pollhelp - Check the commands
#poll - View the current poll 
#poll <nr> - Vote when poll is active 
#pollusers - List of voted ppl
#oldpoll - List of all oldpolls 
#oldpoll <pollname> - View old poll 
Operators:
#polladd <name> <nr> <subj> - Create a new poll 
#pollclose - Close current poll, and add it to oldpolls 
#polldel - Delete current poll (it won't be added to oldpolls) 
#oldpolldel <pollname> - Delete oldpoll forever 

NOTE: All commands can be done in the main chat. Only the wizard and the #poll command can be done in PM to the bot.
]]--

--------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------
bot = "GORT"
botDesc = "Poll bot, approved by Ash"
botTag = ""
botEmail = "bot@electioncommission.com"
prefix = "#"

-- The graphical bar on reply with the votes. Default = 30.
lengthbar = 30

-- The users with true are the OPs and do have extra settings!
Profiles = {
[-1] = false,  -- UnREGs
[0] = true,   -- Owner
[1] = false,   -- Masters
[2] = false,   -- OPs
[3] = false,   -- VIPs
[4] = false,   -- REGs
}

-- Users can't vote more then once on the same answer
-- Set to true to activate
NoMultiVotes = true

-- Entire graph have the same width regardless of the bar value, % of votes is shown by • dotes
FullBars = false

-- Users can vote by just typing nr instead of #poll nr
NoCmdVote = false

-- Show users share in poll-users (if user online)
ShowShare = false

-- The Files used by this script
polllang = "Poll/Lang/English.lang"
pollvotes = "Poll/pollvotes.tbl" -- Holds the voters of active poll
pollsettings = "Poll/pollsettings.tbl" -- Holds the settings of active poll
pollold = "Poll/pollold.tbl" -- Hold old polls
--------------------------------------------------------------------
-- Preloading
--------------------------------------------------------------------
function loadlua(file,msg)
	local f = assert(loadfile(Core.GetPtokaXPath().."scripts/"..file), msg)
	return f()
end

function LangTranslate()
	for value,text in pairs(tLang) do
		if type(text) == "table" then
			-- text was a table, there for we will get subs...
			for subvalue,subtext in pairs(text) do
				subtext = StringTranslate(tostring(subtext)) -- Transalte text
				tLang[value][subvalue] = subtext -- Change text to transleted text
			end
		else
			text = StringTranslate(text)
			tLang.value = text
		end
	end
end

function StringTranslate(Text)
	Text = string.gsub(Text,"%[bot%]",bot)
	Text = string.gsub(Text,"%[cPollAdd%]",tLang.tCmds.polladd)
	Text = string.gsub(Text,"%[cPoll%]",tLang.tCmds.poll)
	Text = string.gsub(Text,"%[cOldPoll]",tLang.tCmds.oldpoll)
	Text = string.gsub(Text,"%[cPollDel]",tLang.tCmds.polldel)
	Text = string.gsub(Text,"%[cOldPollDel]",tLang.tCmds.oldpolldel)
	Text = string.gsub(Text,"%[prefix%]",prefix)
	return Text
end

loadlua(polllang,polllang.. " for " ..bot.. "bot found, or could not be loaded")
loadlua(pollvotes,pollvotes.." for "..bot.." not found")
loadlua(pollsettings,pollsettings.." for "..bot.." not found")
loadlua(pollold,pollold.." for "..bot.." not found")

function OnStartup()
	LangTranslate()
	Core.RegBot(bot,botDesc.."<"..botTag..">",botEmail,true)
end

teller = 0
CurrentPoll ={}
--------------------------------------------------------------------
-- User connects
--------------------------------------------------------------------
function UserConnected(curUser,data)
	if PollSettings["current"] == 2 and not PollVotes[curUser.sNick] then
		ShowPollWithNoResult(curUser,data)
	end
	RC(curUser)
end

OpConnected=UserConnected
RegConnected=UserConnected

--------------------------------------------------------------------
-- Help commands
--------------------------------------------------------------------
MainInfo = ("\r\n\t--<>--------------------------------------------------------------------------------------------------------------------------------------------------------<>--"..
		"\r\n\t\t\t [ POLL Help ]\t\t\t [ POLL Help ]\r\n\t"..
		"--<>--------------------------------------------------------------------------------------------------------------------------------------------------------<>--"..
		"\r\n\t\t "..prefix..tLang.tCmds.poll.."\t\t\t\t=\t"..tLang.tHelp.ViewPoll..
		"\r\n\t\t "..prefix..tLang.tCmds.poll.." <"..tLang.tHelp.Nr..">\t\t\t=\t"..tLang.tHelp.VotePoll..
		"\r\n\t\t "..prefix..tLang.tCmds.pollusers.."\t\t\t=\t"..tLang.tHelp.Voted..
		"\r\n\t\t "..prefix..tLang.tCmds.oldpoll.."\t\t\t\t=\t"..tLang.tHelp.ListOld..
		"\r\n\t\t "..prefix..tLang.tCmds.oldpoll.." <"..tLang.tHelp.Name..">\t\t=\t"..tLang.tHelp.ViewOld..
		"\r\n\t--<>--------------------------------------------------------------------------------------------------------------------------------------------------------<>--")
OPInfo = ("\r\n\t\t "..prefix..tLang.tCmds.polladd.." "..tLang.tHelp.CreateOpt.."\t=\t"..tLang.tHelp.Create..
		"\r\n\t\t "..prefix..tLang.tCmds.pollclose.."\t\t\t=\t"..tLang.tHelp.Close..
		"\r\n\t\t "..prefix..tLang.tCmds.polldel.."\t\t\t\t=\t"..tLang.tHelp.Del..
		"\r\n\t\t "..prefix..tLang.tCmds.oldpolldel.." <"..tLang.tHelp.Name..">\t\t=\t"..tLang.tHelp.DelOld..
		"\r\n\t--<>--------------------------------------------------------------------------------------------------------------------------------------------------------<>--\r\n")

--------------------------------------------------------------------
-- ChatArrival / ToArrival for commands
--------------------------------------------------------------------
function ChatArrival(curUser,data)
	data = string.sub(data,1,string.len(data)-1)
	s,e,cmd = string.find(data,"%b<>%s+(%S+)")
	if cmd then
		if Profiles[curUser.iProfile] then
			if string.lower(cmd) == (prefix..tLang.tCmds.polladd) then
				NewPoll(curUser,data)
				return true
			elseif string.lower(cmd) == (prefix..tLang.tCmds.polldel) then
				if PollSettings["current"] then
					ClearActivePoll()
					Core.SendToAll("<"..bot.."> " ..tLang.curPollErased)
				else
					Core.SendToUser(curUser,"<"..bot.."> " ..tLang.NoPollNoDel)
				end
				return true
			elseif string.lower(cmd) == (prefix..tLang.tCmds.pollclose) then
				if PollSettings["current"] == 2 then
					ClosePoll(curUser,data)
				else
					Core.SendToUser(curUser,"<"..bot.."> " ..tLang.NoPollNoClose)
				end
				return true
			elseif string.lower(cmd) == (prefix..tLang.tCmds.pollhelp) then
				Core.SendToUser(curUser,"<"..bot.."> "..MainInfo..OPInfo)
				return true
			elseif string.lower(cmd) == (prefix..tLang.tCmds.oldpolldel) then
				OldPollDel(curUser,data)
				return true
			end
		else
			if string.lower(cmd) == (prefix..tLang.tCmds.pollhelp) then
				Core.SendToUser(curUser,"<"..bot.."> "..MainInfo)
				return true
			end
		end
		if string.lower(cmd) == (prefix..tLang.tCmds.poll) then
			PollPM(curUser,data)
			return true
		elseif string.lower(cmd) == (prefix..tLang.tCmds.oldpoll) then
			OldPoll(curUser,data)
			return true
		elseif string.lower(cmd) == (prefix..tLang.tCmds.pollusers) then
			PollVoters(curUser,data)
			return true
		end
	end
end

function ToArrival(curUser,data)
	local _,_,whoTo,mes = string.find(data,"$To:%s+(%S+)%s+From:%s+%S+%s+$(.*)")
	if (whoTo == bot and string.find(mes,"%b<>%s+(.*)")) then
		data = string.sub(mes,1,string.len(mes)-1)
		if PollSettings["current"] == 1 and curUser.sNick == PollSettings["currentcreator"] then
			ConfigPoll(curUser,data)
		elseif PollSettings["current"] == 2 then
			PollPM(curUser,data)
		else
			Core.SendPmToUser(curUser,bot,tLang.NoPollNoVote)
		end
	end
end

--------------------------------------------------------------------
-- Creating a Poll
--------------------------------------------------------------------
function NewPoll(curUser,data)
	local _,_,_,namepoll,votemax,questions,subject = string.find(data,"^%b<>%s+(%S+)%s+(%S+)%s+(%d+)%s+(%d+)%s+(.+)")
	if subject == nil or questions == nil then
		Core.SendToUser(curUser,"<"..bot.."> " ..tLang.Error.BadPollAdd.."\r\n"..tLang.Error.BaddPollAddEx)
	else
		if namepoll == OldPolls[namepoll] then
			Core.SendToUser(curUser,"<"..bot.."> " ..tLang.BadPollName)
		else
			local questions = tonumber(questions)
			local votemax = tonumber(votemax)
			if questions > 20 then
				Core.SendToUser(curUser,"<"..bot.."> " ..tLang.Plus20)
			elseif questions < 2 then
				Core.SendToUser(curUser,"<"..bot.."> " ..tLang.More2Ans)
			elseif votemax < 1 then
				Core.SendToUser(curUser,"<"..bot.."> " ..tLang.pplNeedVote)
			elseif votemax >= questions then
				Core.SendToUser(curUser,"<"..bot.."> " ..tLang.ToMuchVotes)
			else
				if PollSettings["current"] == nil then
					PollSettings = {}
					PollSettings["current"] = 1
					PollSettings["currentcreator"] = curUser.sNick
					PollSettings["title"] = namepoll
					PollSettings["questions"] = questions
					PollSettings["subject"] = subject
					PollSettings["maxvote"] = votemax
					PollSettings["date"] = os.date("[%X] / [%d-%m-20%y]")
					Core.SendToUser(curUser,"<"..bot.."> ---------------->>> " ..tLang.GoGandalf.. " <<<----------------")
					Core.SendToUser(curUser,"<"..bot.."> ---------------->>> " ..tLang.GoGandalf.. " <<<----------------")
					Core.SendToUser(curUser,"<"..bot.."> ---------------->>> " ..tLang.GoGandalf.. " <<<----------------")
					WriteFile(PollSettings, "PollSettings", pollsettings)
					Core.SendPmToUser(curUser,bot,"\r\n"..string.rep("*",50).."\r\n\t"..tLang.Gandalf.Wizard.."\r\n"..string.rep("*",50).."\r\n"..tLang.Gandalf.WizKid.." = "..curUser.sNick.."\r\n"..tLang.Gandalf.Name.." = "..PollSettings["title"].."\r\n"..tLang.Gandalf.Votes..": "..PollSettings["maxvote"].."\r\n"..tLang.Gandalf.PollQs..": "..PollSettings["subject"].."\r\n"..tLang.Gandalf.PollAns.." = "..PollSettings["questions"].."\r\n"..string.rep("*",50))
					teller = 1
					Core.SendPmToUser(curUser,bot,tLang.Answer.." "..teller.."/"..questions..":")
				elseif PollSettings["current"] == 1 then
					Core.SendToUser(curUser,"<"..bot.."> " ..tLang.PollIsConfig.." "..PollSettings["currentcreator"])
				elseif PollSettings["current"] == 2 then
					Core.SendToUser(curUser,"<"..bot.."> " ..tLang.CloseRunPoll)
				end
			end
		end
		return true
	end
end

function ConfigPoll(curUser,data)
	local s,e,answer = string.find(data,"%b<>%s+(.*)")
	local tellermax = PollSettings["questions"]
	CurrentPoll[teller] = answer
	teller = teller + 1
	if teller > tellermax then
		teller = 0
		PollSettings["current"] = 2
		WriteFile(PollSettings, "PollSettings", pollsettings)
		Core.SendPmToUser(curUser,bot,tLang.YayNewPoll)
		Core.SendToAll("<"..bot.."> -------->>>>>>>>>> " ..tLang.NewPoll.." <--> " ..tLang.PleaseVote.. " <<<<<<<<<<--------")
		Core.SendToAll("<"..bot.."> -------->>>>>>>>>> " ..tLang.NewPoll.." <--> " ..tLang.PleaseVote.. " <<<<<<<<<<--------")
		Core.SendToAll("<"..bot.."> -------->>>>>>>>>> " ..tLang.NewPoll.." <--> " ..tLang.PleaseVote.. " <<<<<<<<<<--------")
		Convert(curUser,data)
	else
		Core.SendPmToUser(curUser,bot,tLang.Answer.." "..teller.."/"..tellermax..":")
	end
end

function Convert(curUser,data) -- This function will convert the answers from memory to the db file
	if PollSettings["current"] == 2 then
		PollSettings["active"] = {}
		PollSettings["votes"] = {}
		PollSettings["votes"]["n"] = 0
		for a,b in pairs(CurrentPoll) do
			PollSettings["active"][a] = b
			PollSettings["votes"][a] = 0
			WriteFile(PollSettings, "PollSettings", pollsettings)
		end
		CurrentPoll = nil
		CurrentPoll ={}
		Poll(curUser,data)
	else
		Core.SendToUser(curUser,"<"..bot.."> " ..tLang.Error.BadConvert)
		ClearActivePoll()
	end
end

---------------------------------------------------------------------------------------------------
-- Poll is running... let all people know by mass message! :-)
---------------------------------------------------------------------------------------------------
function Poll(curUser,data)
	local PollText = "\r\n"..string.rep("*",50).."\r\n"..tLang.Poll..": "..PollSettings["subject"].."\r\n"..string.rep("*",50).."\r\n\r\n"
	for a=1,table.maxn(PollSettings["active"]) do
		PollText = PollText..a..". "..string.rep(" ",(2-string.len(a))*2+1)..PollSettings["active"][a].."\r\n"
	end
	PollText = PollText.."\r\n"..tLang.PollMe.CanVote.." "..PollSettings["maxvote"].."x.\r\n"..tLang.PollMe.GiveAns.."\r\n"..string.rep("*",50).."\r\n"..tLang.PollMe.Created..": "..PollSettings["currentcreator"].."\r\n"..string.rep("*",50)
	for i,v in pairs(Core.GetOnlineUsers()) do
		Core.SendPmToUser(v,bot,PollText)
	end
end

function PollPM(curUser,data)
	local s,e,cmd = string.find(data,"%b<>%s+(%S+)")
	if NoCmdVote then
		if tonumber(cmd)~=nil then 
			cmd=prefix..tLang.tCmds.poll
		end
	end
	if cmd and (string.lower(cmd) == (prefix..tLang.tCmds.poll)) then
		local s,e,cmd,answer = string.find(data,"%b<>%s+(%S+)%s+(%d+)")
		if NoCmdVote then
			if cmd==nil then
				s,e,answer = string.find(data,"%b<>%s+(%d+)")
			end
		end
		if PollSettings["current"] == 2 then
			if answer then
				if PollVotes[curUser.sNick] then
					if PollVotes[curUser.sNick]["n"] >= PollSettings["maxvote"] then
						Core.SendPmToUser(curUser,bot,tLang.MaxVote.Voted.." "..PollSettings["maxvote"].." "..tLang.MaxVote.FinishIt)
						return true
					end
					if NoMultiVotes then
						if PollVotes[curUser.sNick][tostring(answer)] == true then
							Core.SendPmToUser(curUser,bot,VotedAns)
							return true
						end
					end
				end
				answer = tonumber(answer)
				if answer > PollSettings["questions"] then
					Core.SendPmToUser(curUser,bot,tLang.Error.Err.." "..tLang.Answer.." "..answer.." " ..tLang.Error.NoList)
					-- Yeah, it's splited in to 3 different, I could have done 2, but why? ;p
				else
					PollSettings["votes"][answer] = PollSettings["votes"][answer] + 1
					PollSettings["votes"]["n"] = PollSettings["votes"]["n"] + 1
					WriteFile(PollSettings, "PollSettings", pollsettings)
					if PollVotes[curUser.sNick] then
						PollVotes[curUser.sNick][tostring(answer)] = true
						PollVotes[curUser.sNick]["n"] = PollVotes[curUser.sNick]["n"] + 1
					else
						PollVotes[curUser.sNick] = {}
						PollVotes[curUser.sNick]["n"] = 1
						PollVotes[curUser.sNick][tostring(answer)] = true
					end
					WriteFile(PollVotes, "PollVotes", pollvotes)
					ShowPollWithResult(curUser,data)
					if PollVotes[curUser.sNick]["n"] == PollSettings["maxvote"] then
						Core.SendPmToUser(curUser,bot,tLang.ThanksForVote.." "..answer..". "..tLang.CheckPoll..". "..tLang.NextPoll)
					else
						Core.SendPmToUser(curUser,bot,tLang.ThanksForVote.." "..answer..". "..tLang.YouHave.." "..PollSettings["maxvote"] - PollVotes[curUser.sNick]["n"].." "..tLang.VotesLeft.." "..tLang.CheckPoll)
					end
					Core.SendPmToNick(PollSettings["currentcreator"],bot,tLang.Voted..":  "..PollSettings["votes"]["n"].."   :)")
				end
			else
				if PollVotes[curUser.sNick] then
					ShowPollWithResult(curUser,data)
				else
					ShowPollWithNoResult(curUser,data)
				end
			end
		else
			Core.SendPmToUser(curUser,bot,tLang.NoPollActive)
		end
	end
end

function ShowPollWithResult(curUser,data)
	local PollText = "\r\n"..string.rep("*",50).."\r\n"..tLang.Poll..": "..PollSettings["subject"].."\r\n"..string.rep("*",50).."\r\n\r\n"
	local c = tonumber(PollSettings["votes"]["n"])
	for a=1,table.maxn(PollSettings["active"]) do
		local bar = DoBars(string.format("%.0f",(100/c)*PollSettings["votes"][a]),100,lengthbar)
		PollText = PollText..a..". "..string.rep(" ",(2-string.len(a))*2+1)..PollSettings["votes"][a].." "..tLang.Votes.."\t"..bar.." ("..string.format( "%.2f",(100/c)*PollSettings["votes"][a]).."%)  "..PollSettings["active"][a].."\r\n"
	end
	PollText = PollText.."\r\n"..tLang.TotVotes..": "..PollSettings["votes"]["n"].." (100.00%)\r\n"..string.rep("*",50).."\r\n"..tLang.PollMe.Created..": "..PollSettings["currentcreator"].."\r\n"..tLang.PollMe.CreatedOn..": "..PollSettings["date"].."\r\n"..string.rep("*",50)
	Core.SendPmToUser(curUser,bot,PollText)
	PollText = nil
end

function ShowPollWithNoResult(curUser,data)
	local PollText = "\r\n"..string.rep("*",50).."\r\n"..tLang.Poll..": "..PollSettings["subject"].."\r\n"..string.rep("*",50).."\r\n\r\n"
	for a=1,table.maxn(PollSettings["active"]) do
		PollText = PollText..a..". "..string.rep(" ",(2-string.len(a))*2+1)..PollSettings["active"][a].."\r\n"
	end
	PollText = PollText.."\r\n" ..tLang.PollMe.CanVote.." "..PollSettings["maxvote"].."x.\r\n"..tLang.PollMe.GiveAns.."\r\n"..string.rep("*",50).."\r\n" ..tLang.PollMe.Created.. ": "..PollSettings["currentcreator"].."\r\n"..string.rep("*",50)
	Core.SendPmToUser(curUser,bot,PollText)
	PollText = nil
end

---------------------------------------------------------------------------------------------------
-- Close the active Poll
---------------------------------------------------------------------------------------------------
function ClosePoll(curUser,data)
	if PollSettings["current"] == 2 then
		if tonumber(PollSettings["votes"]["n"]) == 0 then
			Core.SendToUser(curUser,"<"..bot.."> " ..tLang.NoVoteNoOld)
		else
			local Pollname = PollSettings["title"]
			OldPolls[Pollname] = {}
			OldPolls[Pollname]["subject"] = PollSettings["subject"]
			OldPolls[Pollname]["active"] = PollSettings["active"]
			OldPolls[Pollname]["votes"] = PollSettings["votes"]
			OldPolls[Pollname]["date"] = PollSettings["date"]
			OldPolls[Pollname]["currentcreator"] = PollSettings["currentcreator"]
			OldPolls[Pollname]["close"] = os.date("[%X] / [%d-%m-20%y]")
			WriteFile(OldPolls, "OldPolls", pollold)
			local PollText = "\r\n"..string.rep("*",50).."\r\n"..tLang.ClosedPoll..": "..PollSettings["subject"].."\r\n"..string.rep("*",50).."\r\n\r\n"
			local c = tonumber(PollSettings["votes"]["n"])
			for a=1,table.maxn(PollSettings["active"]) do
				PollText = PollText..a..". "..PollSettings["votes"][a].." ("..string.format( "%.2f",(100/c)*PollSettings["votes"][a]).."%) " ..tLang.Votes.. "  "..PollSettings["active"][a].."\r\n"
			end
			PollText = PollText.."\r\n"..tLang.TotVotes..": "..c.." (100.00%)\r\n"..string.rep("*",50).."\r\n"..tLang.PollMe.Created..": "..PollSettings["currentcreator"].."\r\n"..tLang.PollMe.CreatedOn..": "..PollSettings["date"].."\r\n"..string.rep("*",50)
			for i,v in pairs(Core.GetOnlineUsers()) do
				Core.SendPmToUser(v,bot,PollText)
			end
			PollText = nil
			ClearActivePoll()
			Core.SendToUser(curUser,"<"..bot.."> " ..tLang.NowOld)
		end
	end
end

---------------------------------------------------------------------------------------------------
-- Show an old Poll
---------------------------------------------------------------------------------------------------
function OldPoll(curUser,data)
	local _,_,_,namepoll = string.find(data,"^%b<>%s+(%S+)%s+(%S+)")
	if namepoll == nil then
		oTmp = ""
		iets = nil
		for a,b in pairs(OldPolls) do
			Date = string.gsub(OldPolls[a]["date"],"%[","")
			Date = string.gsub(Date,"%]","")
			if iets then
				iets = iets.."->["..a.." ("..Date..") ]<-\r\n"
			else
				iets = "->["..a.." ("..Date..") ]<-\r\n"
			end
		end
		if iets == nil then
			oTmp = tLang.NoOld
		else
			oTmp = tLang.BadOldPoll..":\r\n"..iets
		end
		Core.SendToUser(curUser,"<"..bot.."> "..oTmp)
	else
		if OldPolls[namepoll] then
			ooTmp = "\r\n"..string.rep("*",50).."\r\n" ..tLang.OldPoll.. ": "..OldPolls[namepoll]["subject"].."\r\n"..string.rep("*",50).."\r\n\r\n"
			local c = tonumber(OldPolls[namepoll]["votes"]["n"])
			for a=1,table.maxn(OldPolls[namepoll]["active"]) do
				local bar = DoBars(string.format("%.0f",(100/c)*OldPolls[namepoll]["votes"][a]),100,lengthbar)
				ooTmp = ooTmp..a..". "..OldPolls[namepoll]["votes"][a].." " ..tLang.Votes.. "\t"..bar.." ("..string.format( "%.2f",(100/c)*OldPolls[namepoll]["votes"][a]).."%) " ..tLang.Votes.. "  "..OldPolls[namepoll]["active"][a].."\r\n"
			end
				ooTmp = ooTmp.."\r\nTotal votes: "..c.." (100.00%)\r\n"..string.rep("*",50).."\r\nPoll created by: "..OldPolls[namepoll]["currentcreator"].."\r\nPoll created on: "..OldPolls[namepoll]["date"].."\r\nPoll closed at: "..OldPolls[namepoll]["close"].."\r\n"..string.rep("*",50)
		else
			ooTmp = tLang.OldSorry.."  '"..namepoll.."'  "..tLang.SorryBadOld
		end
		Core.SendPmToUser(curUser,bot,ooTmp)
	end
	oTmp = nil
	ooTmp = nil
	iets = nil
	return true
end

---------------------------------------------------------------------------------------------------
-- Display a graph bar. DoBar by Herodes
---------------------------------------------------------------------------------------------------
function DoBars( val, max, length )
	local lenght = length or 10
	local ratio = (val / ( max/length) )
	if FullBars then
		-- Made by fodin
		return "["..string.rep("•", ratio)..string.rep("--", length-ratio).."]"
	else
		return "["..string.rep("-", ratio).."¦"..string.rep(" ", length-ratio).."]"
	end
end

---------------------------------------------------------------------------------------------------
-- Who voted already?
---------------------------------------------------------------------------------------------------
function PollVoters(curUser,data)
	if PollSettings["current"] ==  2 then
		local count = 0
		local dVoteMax = PollSettings["maxvote"]
		local dVotes = "\r\n"..string.rep("*",50).."\r\n\t"..tLang.PollVotes.."\r\n"..string.rep("*",50).."\r\n" ..tLang.Gandalf.WizKid.. " = "..PollSettings["currentcreator"].."\r\n"..tLang.Gandalf.Name.." = "..PollSettings["title"].."\r\n"..tLang.Gandalf.Votes..": "..PollSettings["maxvote"].."\r\n"..tLang.Gandalf.PollQs..": "..PollSettings["subject"].."\r\n"..tLang.Gandalf.PollAns.." = "..PollSettings["questions"].."\r\n\r\n"
		if ShowShare then
			for a,_ in pairs(PollVotes) do
				count = count + 1
				dVotes = dVotes..count.."."..string.rep(" ",(2-string.len(count))*2+1)..a
				if dVoteMax>1 then
					dVotes = dVotes.." " ..tLang.With.. " "..PollVotes[a]["n"].."/"..dVoteMax.." "..tLang.Votes
				end
				if Profiles[curUser.iProfile] then 
					local u = Core.GetUser(a)
					if u ~= nil then
						Core.GetUserData(u,16)
						dVotes = dVotes.."\t"..math.floor(u.iShareSize/1024/1024/1024*100)/100
					else
						dVotes = dVotes.."\t"..tLang.Offline
					end
					for i,ans in pairs(PollVotes[a]) do
						if i~="n" then
							dVotes = dVotes.."\t"..i
						end
					end
				end
				dVotes = dVotes.."\r\n"
			end
		else
			for a,_ in pairs(PollVotes) do
				count = count + 1
				dVotes = dVotes..count..". "..a.." "..tLang.With.." "..PollVotes[a]["n"].."/"..dVoteMax.." "..tLang.Votes.."\r\n"
			end
		end
		dVotes = dVotes.."\r\n"..string.rep("*",50).."\r\n"..tLang.TotVotes..": "..PollSettings["votes"]["n"].."\r\n"..tLang.TotUsers..": "..count.."\r\n"..string.rep("*",50)
		Core.SendPmToUser(curUser,bot,dVotes)
	else
		Core.SendPmToUser(curUser,bot,tLang.NoPoll)
	end
end


---------------------------------------------------------------------------------------------------
-- Clean it all up
---------------------------------------------------------------------------------------------------
function ClearActivePoll()
	teller = 0
	PollSettings = nil
	PollSettings = {}
	WriteFile(PollSettings, "PollSettings", pollsettings)
	CurrentPoll = nil
	CurrentPoll ={}
	PollText = nil
	PollVotes = nil
	PollVotes = {}
	WriteFile(PollVotes, "PollVotes", pollvotes)
	collectgarbage()
	io.flush()
end

function OldPollDel(curUser,data)
	local _,_,_,namepoll = string.find(data,"^%b<>%s+(%S+)%s+(%S+)")
	if namepoll == nil then
		Core.SendToUser(curUser,"<"..bot.."> " ..tLang.Error.BadOldDel)
	else
		if OldPolls[namepoll] then
			OldPolls[namepoll] = nil
			WriteFile(OldPolls, "OldPolls", pollold)
			Core.SendToUser(curUser,"<"..bot.."> " ..tLang.DelOldPoll.. "  '"..namepoll.."'  "..tLang.OldDel)
		else
			Core.SendToUser(curUser,"<"..bot.."> "..tLang.Error.NonExistingOld)
		end
	end
end

---------------------------------------------------------------------------------------------------
-- Write to file etc
---------------------------------------------------------------------------------------------------
function WriteFile(table, tablename, file)
	local handle = io.open(Core.GetPtokaXPath().."scripts/"..file, "w")
	Serialize(table, tablename, handle)
  	handle:close()
end

function Serialize(tTable, sTableName, hFile, sTab)
	sTab = sTab or "";
	hFile:write(sTab..sTableName.." = {\n" );
	for key, value in pairs(tTable) do
		local sKey = (type(key) == "string") and string.format("[%q]",key) or string.format("[%d]",key);
		if(type(value) == "table") then
			Serialize(value, sKey, hFile, sTab.."\t");
		else
			local sValue = (type(value) == "string") and string.format("%q",value) or tostring(value);
			hFile:write(sTab.."\t"..sKey.." = "..sValue);
		end
		hFile:write(",\n");
	end
	hFile:write(sTab.."}");
end

---------------------------------------------------------------------------------------------------
-- On Error // You never know?! 
---------------------------------------------------------------------------------------------------
function OnError(ErrorMsg)
	if ErrorMsg then
		Core.SendToAll("<"..bot.."> "..tLang.Error.ScriptError..": "..ErrorMsg)
	end
end

---------------------------------------------------------------------------------------------------
-- Right Clicker
---------------------------------------------------------------------------------------------------
function RC(user)
	Core.SendToNick(user.sNick,"$UserCommand 1 3 " ..tLang.tMenu.Root.. "\\" ..tLang.tMenu.PollHelp.. "$<%[mynick]> "..prefix..tLang.tCmds.pollhelp.."&#124;|")
	Core.SendToNick(user.sNick,"$UserCommand 1 3 " ..tLang.tMenu.Root.. "\\" ..tLang.tMenu.PollVoters.. "$<%[mynick]> "..prefix..tLang.tCmds.pollusers.."&#124;|")
	Core.SendToNick(user.sNick,"$UserCommand 1 3 " ..tLang.tMenu.Root.. "\\"  ..tLang.tMenu.ShowPoll.."$<%[mynick]> "..prefix..tLang.tCmds.poll.."&#124;|")
	Core.SendToNick(user.sNick,"$UserCommand 1 3 " ..tLang.tMenu.Root.. "\\" ..tLang.tMenu.OldPoll.."$<%[mynick]> "..prefix..tLang.tCmds.oldpoll.."&#124;|")
	if Profiles[user.iProfile] then
		Core.SendToNick(user.sNick,"$UserCommand 1 3 " ..tLang.tMenu.Root.. "&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 " ..tLang.tMenu.Root.. "\\" ..tLang.tMenu.AddPoll.."$<%[mynick]> "..prefix..tLang.tCmds.polladd.." %[line:"..tLang.tMenu.Name.."] %[line:"..tLang.tMenu.AddVotes.." %[line:"..tLang.tMenu.AddAns.."] %[line:"..tLang.tMenu.AddSubject.."]&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 " ..tLang.tMenu.Root.. "\\" ..tLang.tMenu.ClosePoll.. "$<%[mynick]> "..prefix..tLang.tCmds.pollclose.."&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 " ..tLang.tMenu.Root.. "\\" ..tLang.tMenu.DelPoll.."$<%[mynick]> "..prefix..tLang.tCmds.polldel.."&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 " ..tLang.tMenu.Root.. "\\" ..tLang.tMenu.OldDelPoll.. "$<%[mynick]> "..prefix..tLang.tCmds.oldpolldel.." %[line:"..tLang.tMenu.Name.."]&#124;|")
	end
end