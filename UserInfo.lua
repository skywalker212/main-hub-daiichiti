--[[
      
      Userinfo Script [API 2]  (5/03/08)
      Edited by Mr.Reese
      --------------------------------------------
      Changes:
        Added: Command to search database with IP.
        Added: Shows info on user connect.
        Fixed: Possible null field value.
      --------------------------------------------
      
      Description:
        Adds userdata to database
        You can find userinfo on input of command
      
]]--

tSettings = {
-- Bot Name
sBot = SetMan.GetString(21),
 
-- Hub Name
sHub = SetMan.GetString(0),
 
-- File Name
fFile = "userinfo.tbl",
 
-- Command
infocommand = "userinfo",
ipcommand = "userip",
 
-- Show stats on Login?
bLogin = false,
 
-- Permissions: 1 = Allow; 0 = Dont allow
Permission = {
    [-1] = 0,   -- Unreg Users
        [0] = 1,    -- Owner
        [1] = 0,    -- Masters
        [2] = 0,    -- Operators
        [3] = 0,    -- VIPs
		[4] = 0,	-- Regs
        }
}
 
function OnStartup()
  if loadfile(tSettings.fFile) ~= nil then
    dofile(tSettings.fFile)
  else
    UserDB = {}
    SaveToFile(tSettings.fFile,UserDB,"UserDB")
  end
end 
 
UserConnected = function(user)
  Core.GetUserAllData(user)
  --Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Welcome "..user.sNick..", speedX's UserInfo 1.2 is enabled. RightClick for menu.")
    UserDB[user.sNick] = {user.sNick,user.sIP or "N/A",user.sDescription or "N/A",user.sClient or "N/A",user.sClientVersion or "N/A",user.sMode or "N/A",user.sTag or "N/A",user.iHubs or "N/A",user.iSlots or "N/A",user.sConnection or "N/A",user.sEmail or "N/A",user.iShareSize or "N/A",os.date()}
    SaveToFile(tSettings.fFile,UserDB,"UserDB")
    if tSettings.bLogin then
      local border = "\r\n\t"..string.rep("=-",30).."\r\n\t"
      local header = "Welcome to "..tSettings.sHub.."\r\n\t"..string.rep("=-",30)
      Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> "..border..header..Data(user.sNick,nil,UserDB[user.sNick])..border)
    end
    if tSettings.Permission[user.iProfile] and tSettings.Permission[user.iProfile] == 1 then
      Core.SendToNick(user.sNick,"$UserCommand 1 3 DAIICT MAIN HUB\\UserInfo\\Get UserInfo$<%[mynick]> +"..tSettings.infocommand.." %[line:Nick]&#124;|")
      Core.SendToNick(user.sNick,"$UserCommand 1 3 DAIICT MAIN HUB\\UserInfo\\Get UserIP$<%[mynick]> +"..tSettings.ipcommand.." %[line:IP]&#124;|")
    end
end
OpConnected,RegConnected = UserConnected,UserConnected
 
ChatArrival = function(user,data)
  local _,_,cmd = string.find(data,"%b<> %p(%w+)")
  if cmd then
    if cmd:lower() == tSettings.infocommand then
      if tSettings.Permission[user.iProfile] and tSettings.Permission[user.iProfile] == 1 then
      local _,_,nick = string.find(data,"%b<> %p%w+ (%S+)|")
      if nick then
      local tNick = CheckUser(nick)
        if tNick then
          Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Searching for "..nick.." in database......")
          local border = "\r\n\t"..string.rep("=",50).."\r\n\t"
          local header = "\t\tInfo on Nick: "..nick.."\r\n\t"..string.rep("-",100)
          Core.SendPmToNick(user.sNick,tSettings.sBot,border..header..Data(nick,nil,tNick)..border)
          Clear()
          return true
        else
          Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> "..nick.." is not in the database.")
          return true
        end
      else
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Please specify a nick. Use +"..tSettings.infocommand.." <nick>")
        return true
      end
      end
    elseif cmd:lower() == tSettings.ipcommand then
      if tSettings.Permission[user.iProfile] and tSettings.Permission[user.iProfile] == 1 then
      local _,_,ip = string.find(data,"%b<> %p%w+ (%d+.%d+.%d+.%d+)|")
      local iCount,msg = 0,""
      if ip then
      Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Searching for IP "..ip.." in database......")
        for i,v in pairs(UserDB) do
          if v[2] == ip then
            msg = msg.."\r\n"..Data(i,ip,v)
            iCount = iCount + 1
          end
        end
        Clear()
        if iCount == 0 then
          Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> IP: "..ip.." is not in the database.")
        else
          local border = "\r\n\t"..string.rep("=",50).."\r\n\t"
          local header = "\t\tInfo on IP: "..ip.."\r\n\t"..string.rep("-",100)
          Core.SendPmToNick(user.sNick,tSettings.sBot,border..header..msg..border)
        end
        return true
      else
        Core.SendToNick(user.sNick,"<"..tSettings.sBot.."> Invalid IP. Use +"..tSettings.ipcommand.." <ip>")
        return true
      end
      end
    end
  end
end
 
Data = function(nick,ip,data)
  local sReg,msg,prof = RegMan.GetReg(nick),""
  if sReg then
        prof = ProfMan.GetProfile(sReg.iProfile).sProfileName
  else
        prof = "Unregistered"
  end
  msg = msg.."\r\n\tName :\t\t"..data[1]
  msg = msg.."\r\n\tIP :\t\t"..data[2]
  msg = msg.."\r\n\tProfile :\t\t"..prof
  msg = msg.."\r\n\tDescription :\t"..data[3]
  msg = msg.."\r\n\tClient :\t\t"..data[4].." "..data[5]
  msg = msg.."\r\n\tMode :\t\t"..data[6]
  msg = msg.."\r\n\tTag :\t\t"..data[7]
  msg = msg.."\r\n\tHubs :\t\t"..data[8]
  msg = msg.."\r\n\tSlots :\t\t"..data[9]
  msg = msg.."\r\n\tConnection :\t"..data[10]
  msg = msg.."\r\n\tE-Mail :\t\t"..data[11]
  msg = msg.."\r\n\tShare :\t\t"..ShareConverter(data[12])
  if Core.GetUser(nick) then
    msg = msg.."\r\n\tStatus :\t\tONLINE"
  else
    msg = msg.."\r\n\tStatus :\t\tOFFLINE"
    msg = msg.."\r\n\tLastseen :\t"..data[13]
  end
  return msg
end
 
CheckUser = function(nick)
  for i,_ in pairs(UserDB) do
    if i:lower() == nick:lower() then
      return UserDB[i]
    end
  end
end
 
ShareConverter = function(x)
  if x < 1024 then
    unit = "B"
  elseif x < 1048576 then
    x = x/1024
    unit = "KB"
  elseif x < 1073741824 then
    x = x/1048576
    unit = "MB"
  elseif x < 1099511627776 then
    x = x/1073741824
    unit = "GB"
  elseif x > 1099511627776 then
    x = x/1099511627776
    unit = "TB"
  end
  return string.format("%.2f "..unit,x)
end
 
Clear = function() 
    collectgarbage()
    io.flush()
end

Save_Serialize = function(tTable, sTableName, hFile, sTab)
    sTab = sTab or "";
    hFile:write(sTab..sTableName.." = {\n" );
    for key, value in pairs(tTable) do
        local sKey = (type(key) == "string") and string.format("[%q]",key) or string.format("[%d]",key);
        if(type(value) == "table") then
            Save_Serialize(value, sKey, hFile, sTab.."\t");
        else
            local sValue = (type(value) == "string") and string.format("%q",value) or tostring(value);
            hFile:write( sTab.."\t"..sKey.." = "..sValue);
        end
        hFile:write( ",\n");
    end
    hFile:write( sTab.."}");
end
 
SaveToFile = function(file,table , tablename )
    local hFile = io.open(file , "w")
    Save_Serialize(table, tablename, hFile);
    hFile:close()
    Clear()
end
 
