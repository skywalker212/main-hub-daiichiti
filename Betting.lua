--[[

      The Betting Field - LUA 5.1x [API 2]
      Edited By Mr.Reese
      
      Description:
        - Similar to the usual Betting Games.
        - You need to create an account first before betting.
        - When any team is declared as a winner then their money is doubled.
        
      +Changes from 1.0
          +Added: Commands like +mybalance,+myteam,+resetacc,+resetall
          *Fixed: Create Account bug

      +Changes from 2.0
          +Added: Time Limit for Betting Field
          +Added: Command for Top Betters          
        	      
]]--

tSettings = {

  -- Bot Name
  sBot = "»BOoKiE«",
	
  -- Game DB
  fBets = "tBets.txt",
	
  -- User DB
  fUsers = "tUsers.txt",
	
  -- Initial Balance
  iBalance = 10000,
  
  -- Default Max Users to display in Top Betters command
  iMaxUsers = 10

}

x = 1

OnStartup = function()
  tSettings.fBets = Core.GetPtokaXPath().."scripts/"..tSettings.fBets
  tSettings.fUsers = Core.GetPtokaXPath().."scripts/"..tSettings.fUsers
  tSettings.sVersion = ""
  --if (tSettings.sBot ~= SetMan.GetString(21) or tSettings.bRegister) then Core.RegBot(tSettings.sBot,"Betting Field"..tSettings.sVersion.."","",true) end
  if loadfile(tSettings.fBets) ~= nil then dofile(tSettings.fBets)
  else
    tBets = {}
    SaveToFile(tBets,"tBets",tSettings.fBets)
  end
  if loadfile(tSettings.fUsers) ~= nil then dofile(tSettings.fUsers)
  else
    tUsers = {}
    SaveToFile(tUsers,"tUsers",tSettings.fUsers)
  end
  if next(tBets) and tBets["status"] == "active" and tBets["tob"] > 0 then
    tSettings.iTimer = TmrMan.AddTimer(60*60*1000)
  end
end

ChatArrival = function(user,data)
  local _,_,cmd = string.find(data,"%b<> %p(%w+)") 
  if cmd and tCommands[cmd:lower()] then
    cmd = cmd:lower()
    if tCommands[cmd].tLevels[user.iProfile] then
      return tCommands[cmd].fFunction(user,data,cmd), true
    else
      return Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Error: You are not allowed to use this command!"), true
    end
  end
end

function ToArrival(user,data)
  local _,_,to,arg = string.find(data,"$To: (%S+) From: %S+ $(.*)")
  local _,_,cmd = string.find(data,"%b<> %p(%w+)")
  if to == tSettings.sBot then
    if user.sNick:lower() == tBets["operator"]:lower() and tBets["status"] == "config" then
      CreateBF(user,arg)
    else
      if cmd and tCommands[cmd:lower()] then
        cmd = cmd:lower()
        if tCommands[cmd].tLevels[user.iProfile] then
          return tCommands[cmd].fFunction(user,data,cmd), true
        else
          return Core.SendPmToNick(user.sNick,tSettings.sBot,"Error: You are not allowed to use this command!"), true
        end
      end
    end
  end
end

UserConnected = function(user)
  --Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Welcome "..user.sNick..", Mr.Reese's Betting Field "..tSettings.sVersion.." is enabled. Use RightClick for menu.")
  for i,v in pairs(tCommands) do
    if v.tLevels[user.iProfile] then
      Core.SendToNick(user.sNick, "$UserCommand 1 3 DA-iiCT MAiN HuB\\The Betting Field\\"..v.tRC[1].."$<%[mynick]> "..SetMan.GetString(29):sub(1,1)..i..v.tRC[2].."&#124;|")
    end
  end
end
OpConnected,RegConnected = UserConnected,UserConnected 

OnExit = function()
  SaveToFile(tBets,"tBets",tSettings.fBets)
  SaveToFile(tUsers,"tUsers",tSettings.fUsers)
end

tCommands = {
  createbf =	{ 
    fFunction = function(user,data,cmd)
      local _,_,topic,nop,tob,question = string.find(data,"%b<> %p%w+ (%S+) (%d+) (%d+) (.*)|")
      if not next(tBets) or tBets["status"] == "closed" then
        if topic and question and nop and tob then
          tBets = {}
          tBets["status"] = "config"
          tBets["operator"] = user.sNick
          tBets["date"] = os.date("%d/%m/%y at %X")
          tBets["topic"] = topic
          tBets["question"] = question
          tBets["nop"] = tonumber(nop)
          tBets["winner"] = 0
          tBets["tob"] = tonumber(tob)
          tBets["teams"] = {}
          SaveToFile(tBets,"tBets",tSettings.fBets)
          x = 1
          Core.SendPmToNick(user.sNick,tSettings.sBot,"Enter the "..nop.." teams. (Only one at a time)")
          Core.SendPmToNick(user.sNick,tSettings.sBot,"Enter 1 of "..nop)
        else
          Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Invalid argument. Use "..SetMan.GetString(29):sub(1,1)..cmd.." <topic> <no. of teams> <time limit of the betting field> <question>")
        end
      else
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> There is an active Betting Field. In order to create a new one you should declare the winner of the current Betting Field.")
      end
    end, 
    tLevels = {
      [-1] = false, [0] = true, [1] = true, [2] = true, [3] = false, [4] = false, [5] = false,
    },
    tHelp = " <topic> <no. of teams> <time limit of the betting field> <question>\tTo Initiate A Betting Field",
    tRC = { "Initiate A Betting Field"," %[line:Topic] %[line:No. of Teams] %[line:Time Limit of the Betting Field(in Hours) (0=disable)] %[line:Question?]" },
  },
  bet = { 
    fFunction = function(user,data,cmd)
    local _,_,opt,amt = string.find(data,"%b<> %p%w+ (%d+) (%d+)|")
      if tBets["status"] == "active" then
        if CheckAcc(user.sNick) then 
          if opt and amt then
            opt = tonumber(opt)
            amt = tonumber(amt)
            if opt >= 1 and opt <= tBets["nop"] then
              local tNick = CheckAcc(user.sNick) 
              if amt <= tNick["balance"] then
                if tNick["betstatus"] == 0 then
                  tNick["opt"] = opt
                  tNick["bet"] = amt
                  tNick["balance"] = tNick["balance"] - amt
                  tNick["betstatus"] = 1
                  SaveToFile(tUsers,"tUsers",tSettings.fUsers)
                  Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You have bet $"..amt.." on Team: "..tBets["teams"][opt])
                else
                  Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You have already bet.")
                end
              else
                Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Sorry, you cannot bet more than your balance.")
              end
            else
              Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You have bet on an invalid team.")
            end
          else
            Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Invalid argument. Use "..SetMan.GetString(29):sub(1,1)..cmd.." <team no.> <amount>")
          end
        else
          Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You need to create an account first.")
        end
      elseif tBets["status"] == "inactive" then
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Sorry, the betting time of the active betting field has already passed. You cannot bet now.")      
      else
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Sorry, there is no active Betting Field.")
      end
    end,
    tLevels = {
      [-1] = false, [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true,
    },
    tHelp = " <team no.> <amount>\t\t\tTo Bet On A Team",
    tRC = { "Bet On A Team"," %[line:Team No.] %[line:Amount]" },
  },
  showt = {
    fFunction = function(user,data,cmd)
      if tBets["status"] == "active" then
        Show(user)
        if CheckAcc(user.sNick) then
          local tNick = CheckAcc(user.sNick)
          if tNick["betstatus"] == 0 then  	
            Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You have not yet bet.")
          else
            Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You have already Bet $"..tNick["bet"].." on Team: "..tBets["teams"][tNick["opt"]])
          end
        else
          Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You have not yet bet.")
        end
      elseif tBets["status"] == "inactive" then
        Show(user)       
      else
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Sorry, there is no active Betting Field.")
      end        
    end, 
    tLevels = {
      [-1] = false, [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true,
    },
    tHelp = "\t\t\t\t\tTo Display Teams",
    tRC = { "Display Teams","" },
  },
  bfwinner = { 
    fFunction = function(user,data,cmd)
    local _,_,opt = string.find(data,"%b<> %p%w+ (%d+)|")
      if tBets["status"] == "active" or tBets["status"] == "inactive" then
        if opt then
          opt = tonumber(opt)
          if opt >= 1 and opt <= tBets["nop"] then 
            for i,v in pairs(tUsers) do
              if v["opt"] == opt then
                tUsers[i]["balance"] = tUsers[i]["balance"] + 2*tUsers[i]["bet"]
                if Core.GetUser(i) then
                  Core.SendPmToNick(i,tSettings.sBot,"Your Team has won :D . Your Balance is now $"..tUsers[i]["balance"])
                end
              end
              tUsers[i]["betstatus"] = 0
            end
            tBets["winner"] = opt
            tBets["status"] = "closed"
            SaveToFile(tBets,"tBets",tSettings.fBets)
            SaveToFile(tUsers,"tUsers",tSettings.fUsers)
            Core.SendToAll("<"..tSettings.sBot.."> The Winner of the current Betting Field is "..tBets["teams"][opt].." :D")
          else
            Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You have selected an invalid team as a winner.")            
          end
        else
          Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Invalid argument. Use "..SetMan.GetString:sub(1,1)..cmd.." <team no.>")
        end
      elseif tBets["status"] == "closed" then
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> The winner is already selected as Team: "..tBets["teams"][tBets["winner"]]) 
      else
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> There is no active Betting Field.")
      end			
    end,
    tLevels = {
      [-1] = false, [0] = true, [1] = true, [2] = true, [3] = false, [4] = false, [5] = false,
    },
    tHelp = " <team no.>\t\t\tTo Declare A Winner",
    tRC = { "Declare A Winner"," %[line:Team No.]" },
  },
  createacc = { 
    fFunction = function(user,data,cmd)
      if CheckAcc(user.sNick) then
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You already have an account :)")
      else
        tUsers[user.sNick] = {}
        tUsers[user.sNick]["balance"] = tSettings.iBalance
        tUsers[user.sNick]["betstatus"] = 0
        tUsers[user.sNick]["opt"] = -1
        tUsers[user.sNick]["bet"] = -1
        SaveToFile(tUsers,"tUsers",tSettings.fUsers)
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You have successfully created your account with Initial Balance $"..tSettings.iBalance)        
      end
    end,
    tLevels = {
      [-1] = false, [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true,
    },
    tHelp = "\t\t\t\tTo Create An Account",
    tRC = { "Create My Account","" },
  },
  mybalance = { 
    fFunction = function(user,data,cmd)
      if CheckAcc(user.sNick) then
        local tNick = CheckAcc(user.sNick)
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Your Balance is $"..tNick["balance"])
      else
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You need to create an Account first.")
      end
    end,
    tLevels = {
      [-1] = false, [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true,
    },
    tHelp = "\t\t\t\tTo Check Your Balance",
    tRC = { "My Balance","" },
  },
  myteam = { 
    fFunction = function(user,data,cmd)
      if CheckAcc(user.sNick) then
        local tNick = CheckAcc(user.sNick)
        if tNick["betstatus"] == 1 then
          Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You have bet $"..tNick["bet"].." on Team: "..tBets["teams"][tNick["opt"]])
        else
          Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You have not yet bet.")
        end
      else
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You need to create an Account first.")
      end
    end,
    tLevels = {
      [-1] = false, [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true,
    },
    tHelp = "\t\t\t\t\tTo Check Your Team",
    tRC = { "My Team","" },
  },
  resetacc = { 
    fFunction = function(user,data,cmd)
      tUsers = {}
      SaveToFile(tUsers,"tUsers",tSettings.fUsers)
      Core.SendPmToNick(user.sNick,tSettings.sBot,"All Accounts have been erased.")
    end,
    tLevels = {
      [-1] = false, [0] = true, [1] = false, [2] = false, [3] = false, [4] = false, [5] = false,
    },
    tHelp = "\t\t\t\t\tReset All Accounts",
    tRC = { "Reset Accounts","" },
  },
  resetall = { 
    fFunction = function(user,data,cmd)
      tUsers = {}
      tBets = {}
      SaveToFile(tUsers,"tUsers",tSettings.fUsers)
      SaveToFile(tBets,"tBets",tSettings.fBets)
      Core.SendPmToNick(user.sNick,tSettings.sBot,"All data has been erased.")
    end,
    tLevels = {
      [-1] = false, [0] = true, [1] = false, [2] = false, [3] = false, [4] = false, [5] = false,
    },
    tHelp = "\t\t\t\t\tReset All Data",
    tRC = { "Reset All","" },
  },
  bfhelp = { 
    fFunction = function(user,data,cmd)
      local msg,p = "\r\n\r\n\tThe Betting Field "..tSettings.sVersion.." Game Help\r\n",SetMan.GetString(29):sub(1,1)
      for i,v in pairs(tCommands) do
        if v.tLevels[user.iProfile] then
          msg = msg.."\r\n\t"..p..i..v.tHelp
        end
      end
      Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> "..msg)
    end,
    tLevels = {
      [-1] = false, [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true,
    },
    tHelp = "\t\t\t\t\tDisplays This Help Message",
    tRC = { "The Betting Field Help","" },
  },
  topbetters = { 
    fFunction = function(user,data,cmd)
      if next(tUsers) then
        if CheckAcc(user.sNick) then
          local _,_,iStart,iEnd = string.find(data,"%b<> %p%w+ (%d+)-(%d+)|")
          local tTemp,msg,bUser = {},"\r\n\t"..string.rep("=", 35).."\r\n\tRank\tAmount:\t\tName:\r\n\t"..string.rep("-", 70),false
          iStart, iEnd = (iStart or 1), (iEnd or tSettings.iMaxUsers)
          for i,_ in pairs(tUsers) do
            table.insert(tTemp, {iBalance = tUsers[i]["balance"], sNick = i})
          end
          table.sort(tTemp, function(a, b) return (a.iBalance > b.iBalance) end)
          for i = iStart, iEnd do
            if tTemp[i] then
              if tTemp[i].sNick:lower() == user.sNick:lower() then bUser = true end
              msg = msg.."\r\n\t"..i..".\t$"..tTemp[i].iBalance.."\t\t"..tTemp[i].sNick
            end
          end
          if bUser == false then
            for i = iEnd, table.getn(tTemp) do
              if tTemp[i].sNick:lower() == user.sNick:lower() then
                msg = msg.."\r\n\t..\t..\t\t.."
                msg = msg.."\r\n\t..\t..\t\t.."
                msg = msg.."\r\n\t..\t..\t\t.."
                if tTemp[i-1] and tTemp[i+1] then
                  msg = msg.."\r\n\t"..(i-1)..".\t$"..tTemp[i-1].iBalance.."\t\t"..tTemp[i-1].sNick
                  msg = msg.."\r\n\t"..i..".\t$"..tTemp[i].iBalance.."\t\t"..tTemp[i].sNick
                  msg = msg.."\r\n\t"..(i+1)..".\t$"..tTemp[i+1].iBalance.."\t\t"..tTemp[i+1].sNick
                elseif tTemp[i-1] then
                  msg = msg.."\r\n\t"..(i-1)..".\t$"..tTemp[i-1].iBalance.."\t\t"..tTemp[i-1].sNick
                  msg = msg.."\r\n\t"..i..".\t$"..tTemp[i].iBalance.."\t\t"..tTemp[i].sNick
                end                
              end
            end
          end
          msg = msg.."\r\n\t"..string.rep("-", 70)                
          Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> "..msg)
          Clear()
        else
          Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> You need to create an account first.")
        end
      else
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Sorry, users table is currently empty.")
      end              
    end,
    tLevels = {
      [-1] = false, [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true,
    },
    tHelp = " <start_range> <end_range>\t\tTo Display Top Betters",
    tRC = { "Display Top Betters"," %[line:Start Range (Optional)]-%[line:End Range (Optional)]" },
  },
};

CreateBF = function(user,data)
  if tBets["status"] == "config" then
    if x <= tBets["nop"] then
      local s = string.len(tBets["operator"]) + 4
      data = string.sub(data,s,data:len()-1)
      tBets["teams"][x] = data
      SaveToFile(tBets,"tBets",tSettings.fBets)
      x = x+1
    end
    if x > tBets["nop"] then
      tBets["status"] = "active"
      SaveToFile(tBets,"tBets",tSettings.fBets)
      Core.SendPmToNick(user.sNick,tSettings.sBot,"The Betting Field has been created.")
      Core.SendToAll("<"..tSettings.sBot.."> The Betting Field has been created. Try Your Luck guyzz... ;)")
      Show()
      if tBets["tob"] > 0 then
        tSettings.iTimer = TmrMan.AddTimer(60*60*1000)
      end 
    else
      Core.SendPmToNick(user.sNick,tSettings.sBot,"Enter "..x.." of "..tBets["nop"])
    end
  end
end

OnTimer = function(iID)
  if tSettings.iTimer and iID == tSettings.iTimer then
    tBets["tob"] = tBets["tob"] - 1
    if tBets["tob"] == 0 then
      tBets["status"] = "inactive"
      Core.SendToAll("<"..tSettings.sBot.."> The betting time is now over. There will be no more bets. The Results will be declared shortly. :)")      
      SaveToFile(tBets,"tBets",tSettings.fBets)
      TmrMan.RemoveTimer(tSettings.iTimer)
    end
  end
end    

Show = function(user)
  local border,lborder,msg2 = string.rep("=-",25),string.rep("-",70),""
  local msg1 = "\r\n\t"..border.."\r\n\tTopic: "..tBets["topic"].."\r\n\t"..
  "Question: "..tBets["question"].."\r\n\t"..border.."\r\n\tTeams:"
  for i,v in ipairs(tBets["teams"]) do
    msg2 = msg2.."\r\n\t"..i.."] "..v
  end
  msg2 = msg2.."\r\n\t"..lborder
  if user then
    Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> "..msg1..msg2)
  else
    Core.SendToAll("<"..tSettings.sBot.."> "..msg1..msg2)
  end
end

Clear = function()
  collectgarbage("collect")
  io.flush()
end

CheckAcc = function(user)
  for i,v in pairs(tUsers) do
    if i:lower() == user:lower() then
      return tUsers[i]
    end
  end
end   

Serialize = function(tTable,sTableName,hFile,sTab)
	sTab = sTab or "";
	hFile:write(sTab..sTableName.." = {\n");
	for key,value in pairs(tTable) do
		if (type(value) ~= "function") then
			local sKey = (type(key) == "string") and string.format("[%q]",key) or string.format("[%d]",key);
			if(type(value) == "table") then
				Serialize(value,sKey,hFile,sTab.."\t");
			else
				local sValue = (type(value) == "string") and string.format("%q",value) or tostring(value);
				hFile:write(sTab.."\t"..sKey.." = "..sValue);
			end
			hFile:write(",\n");
		end
	end
	hFile:write(sTab.."}");
end

SaveToFile = function(table,tablename,file)
  local hFile = io.open(file,"w+") Serialize(table,tablename,hFile); hFile:close()
  Clear() 
end