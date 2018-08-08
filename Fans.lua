--[[

  User Fans Script [API 2]
  Edited by Mr.Reese 

  Changes by speedX:
  - Changed Data Save Structure
  - Added two new commands:
    +topfans - Shows users with maximum fans. (Based on jiten's TopHubbers function) (Requested by gutswe)
    +fansof <nick> - Shows nick is a fan of how many other users. (Requested by Yahoo)
  
  - Added notification to nick when a user is added to his fan list.  (Requested by KauH)
    
  Note:
    Please delete your old tFans.tbl file to use this new version of the script.

  Description:
      Allows to become a fan of other user
      Shows fans
      [14:46] <PtokaX> 
	    ==============================
	    Fans of speedX are: [Total: 2]
	    ==============================
	    [1] speed
	    [2] blink
	      
	    Also allows to delete your name from others fan list

]]--

-- Fans File Name
fFansFile = "tFans.tbl"

-- Max users to be shown in topfans command
tMaxUsers = 20

-- Bot Name 
sBot = SetMan.GetString(21)

-- Commands
Addfan = "fan"
Showfans = "showfans"
Delfan = "delfan"
Topfans = "topfans"
Fansof = "fansof"

OnStartup = function()
  if loadfile(fFansFile) ~= nil then dofile(fFansFile)
  else
    Fans = {}
    SaveToFile(fFansFile, Fans, "Fans")
  end
  if sBot ~= SetMan.GetString(21) then Core.RegBot(sBot,"","",true) end
end

UserConnected = function(user)
  --Core.SendToNick(user.sNick,"<"..sBot.."> Welcome "..user.sNick..", Mr.Reese's Fans Script 2.1 is enabled. RightClick for menu.")
  if tCommands[Addfan].tLevels[user.iProfile] then
    Core.SendToNick(user.sNick,"$UserCommand 1 3 DA-iiCT MAiN HuB\\User Fans\\Become Fan of a user$<%[mynick]> +"..Addfan.." %[line:Nick]&#124;|")
  end
  if tCommands[Showfans].tLevels[user.iProfile] then
    Core.SendToNick(user.sNick,"$UserCommand 1 3 DA-iiCT MAiN HuB\\User Fans\\Show Fans of a user$<%[mynick]> +"..Showfans.." %[line:Nick]&#124;|")
  end
  if tCommands[Delfan].tLevels[user.iProfile] then
    Core.SendToNick(user.sNick,"$UserCommand 1 3 DA-iiCT MAiN HuB\\User Fans\\Delete Fan$<%[mynick]> +"..Delfan.." %[line:Nick]&#124;|")
  end
  if tCommands[Topfans].tLevels[user.iProfile] then
    Core.SendToNick(user.sNick,"$UserCommand 1 3 DA-iiCT MAiN HuB\\User Fans\\Show Top Fans$<%[mynick]> +"..Topfans.."&#124;|")
  end
  if tCommands[Fansof].tLevels[user.iProfile] then
    Core.SendToNick(user.sNick,"$UserCommand 1 3 DA-iiCT MAiN HuB\\User Fans\\Show <nick> is fan of?$<%[mynick]> +"..Fansof.." %[line:Nick]&#124;|")
  end
end
OpConnected = UserConnected
RegConnected = UserConnected

ChatArrival = function(user,data)
	local _,_,to = string.find(data,"^$To: (%S+) From:")
	local _,_,cmd = string.find(data,"%b<> %p(%w+)") 
		if cmd and tCommands[cmd:lower()] then
			cmd = cmd:lower()
			if tCommands[cmd].tLevels[user.iProfile] then
				if to and to == sBot then
					return Core.SendPmToNick(user.sNick,sBot,tCommands[cmd].sFunction(user,data)), true
				else
				  return Core.SendToNick(user.sNick,"<"..sBot.."> "..tCommands[cmd].sFunction(user,data)), true
				end
			else
				if to and to == sBot then
					return Core.SendPmToNick(user.sNick,sBot, "*** Error: You are not allowed to use this command!"), true
				else
					return Core.SendToNick(user.sNick,"<"..sBot.."> Error: You are not allowed to use this command!"), true
				end
			end
		end
end
ToArrival = ChatArrival 

tCommands = {
  [Addfan] = {
    sFunction = function(user,data)
      local _,_,nick = string.find(data,"%b<> %p%w+ (%S+)|")
      local msg = ""
      if nick then
        if nick:lower() ~= user.sNick:lower() then
        if not Fans[nick:lower()] then
          Fans[nick:lower()] = {}
        end
        if CheckUser(nick,user.sNick) then
          msg = "You are already a fan of "..nick
          return msg        
        else
          if Core.GetUser(nick) then
            Core.SendToNick(nick,"<"..sBot.."> *** "..user.sNick.." has been added to your fan list.")
          end
          table.insert(Fans[nick:lower()],user.sNick)
          SaveToFile(fFansFile, Fans, "Fans")
          msg = "You have been added to the fan list of "..nick
          return msg
        end
        else
          return "You cannot become a fan of yourself :P"
        end
      else
        return "Please enter a valid nick"
      end
    end,
    tLevels = {[-1] = false,[0] = true,[1] = true,[2] = true,[3] = true,[4] = true},
  },
  [Showfans] = {
    sFunction = function(user,data)
      local _,_,nick = string.find(data,"%b<> %p%w+ (%S+)|")
      local msg,header,border,count = "","","",0
      if nick then
        if Fans[nick:lower()] then
          for i,v in pairs(Fans[nick:lower()]) do
            header = "Fans of "..nick.." are:"
            border = string.rep("=",30)
            count = count + 1
            msg = msg.."\t["..count.."] "..v.."\r\n"
          end
          if count == 0 then
            Fans[nick:lower()] = nil
            SaveToFile(fFansFile, Fans, "Fans")
            return nick.." has no fans :("
          else
            return "\r\n\t"..border.."\r\n\t"..header.." [Total: "..count.."]\r\n\t"..border.."\r\n"..msg
          end
        else
          return nick.." has no fans :("
        end
      else
        return "Please enter a valid nick"
      end
    end,
    tLevels = {[-1] = false,[0] = true,[1] = false,[2] = false,[3] = false,[4] = false},
  },
  [Delfan] = {
    sFunction = function(user,data)
      local _,_,nick = string.find(data,"%b<> %p%w+ (%S+)|")
      if nick then
        if not Fans[nick:lower()] then
          return nick.." is not in the database"
        end
        if CheckUser(nick,user.sNick) then
          table.remove(Fans[nick:lower()],i)
          SaveToFile(fFansFile, Fans, "Fans")
          return "You have deleted your name from the fans list of "..nick
        else
          return "You are not in the fans list of "..nick
        end
      else
        return "Please enter a valid nick"
      end
    end,
    tLevels = {[-1] = false,[0] = true,[1] = true,[2] = true,[3] = true,[4] = true},
  },
  [Topfans] = {
    sFunction = function(user,data)
      local Temp,msg = {},"\r\n\t"..string.rep("=", 35).."\r\n\tNr.\tTotal Fans:\tName:\r\n\t"..string.rep("-", 70).."\r\n"
      iStart, iEnd = (iStart or 1), (iEnd or tMaxUsers)
      for i,v in pairs(Fans) do
        table.insert(Temp, {TotalFans = table.getn(Fans[i:lower()]), sNick = i})
      end
      table.sort(Temp, function(a, b) return (a.TotalFans > b.TotalFans) end)
      for i = iStart, iEnd, 1 do
        if Temp[i] then
          local v = Temp[i]
          msg = msg.."\t["..i.."]\t     "..v.TotalFans.."\t\t"..v.sNick.."\r\n"
        end
      end
      msg = msg.."\t"..string.rep("-", 70)
      Clear()
      return msg
    end,
    tLevels = {[-1] = false,[0] = true,[1] = true,[2] = true,[3] = true,[4] = true},  
  },
  [Fansof] = {
    sFunction = function(user,data)
      local _,_,nick = string.find(data,"%b<> %p%w+ (%S+)|")
      local msg,header,border,count = "","","",0
      if nick then
        for a,b in pairs(Fans) do
          for c,d in pairs(b) do
            if d:lower() == nick:lower() then
              header = nick.." is a fan of:"
              border = string.rep("=",30)
              count = count + 1
              msg = msg.."\t["..count.."] "..a.."\r\n"
            end
        end
        end
        if count == 0 then
          return nick.." is not a fan of any user."
        else
          return "\r\n\t"..border.."\r\n\t"..header.." [Total: "..count.."]\r\n\t"..border.."\r\n"..msg
        end
        Clear()
      end
    end,
    tLevels = {[-1] = false,[0] = true,[1] = false,[2] = false,[3] = false,[4] = false},
  }
}

CheckUser = function(nick,fan)
  for i,v in pairs(Fans[nick:lower()]) do
    if v:lower() == fan:lower() then
      return i
    end
  end
end

Clear = function() 
	collectgarbage()
	io.flush()
end

Serialize = function(tTable,sTableName,hFile,sTab) -- (based on jitens)
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

SaveToFile = function(file,table,tablename)
	local hFile = io.open(file,"w+") Serialize(table,tablename,hFile); hFile:close()
	Clear()
end