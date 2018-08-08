
enddate = "26.02.2015 20:00:00"
-- what messages will show up if there is more time than x left
-- ["x"] = "message"
-- %d - counter
messages = {
			["1y"] = "To the SYNAPSE'15 there is %d years left",
			["1M"] = "To the SYNAPSE'15 there is %d months left",
			["1w"] = "To the SYNAPSE'15 there is %d weeks left",
			["1d"] = "To the SYNAPSE'15 there is %d days left",
			["1h"] = "Only %d hours left for SYNAPSE'15",
			["1m"] = "Only %d minutes left for SYNAPSE'15",
			["1s"] = "Patience is over %d seconds left.. here comes the SYNAPSE'15"
		}
-- how often are messages going to show up
freqs = {
			["1y"] = "2M",
			["1M"] = "1M",
			["1w"] = "1d",
			["1d"] = "12h",
			["1h"] = "1m",
			["1m"] = "1s",
			["1s"] = "3s"
		}
finalmsg = "The time has come for the SYNAPSE 2015"
-- Here you can adjust your clock, if on the server there is a different time than on your hub
srvtoffset = 7200
-- Here you can specify what script is supposed to do with a message - Just remove a comment from the right line
function Send(msg)
-- Regular text on main
	VH:SendDataToAll(msg.."|",0,10)
-- Text on a stripe
--	VH:SendDataToAll(msg.."                                                                                                      is kicking  because: |",0,10)
-- Topic
--	VH:SendDataToAll("$HubName "..msg.."|",0,10)
end

-- Do not change these variables and tables :P
timert   = 1
timerm   = 3600
prevmod  = 0
currmsg  = ""
currdiv  = 3600
currdiv2 = 3600
times = {
			["s"]=1,
			["m"]=60,
			["h"]=3600,
			["d"]=86400,
			["w"]=604800,
			["M"]=2419200,
			["y"]=31536000
		}
divs = {}
function DCtime2secs(sTime)
-- parametr - string containing time time in saving in DC (eg 1H) or amount of seconds
	if string.find(tostring(sTime),"^(%d+)(%a)$") then	-- eg sTime="1H"
		local _,_,d,l = string.find(sTime,"^(%d+)(%a)$")
		d = tonumber(d)
		if l~="M" then
			l=string.lower(l)
		end
		if times[l] then
			d = d * times[l];
		end
		return d
	else
		if string.find(tostring(sTime),"^(%d+)$") then	-- eg sTime="3600"
			local _,_,d = string.find(sTime,"^(%d+)$")
			d = tonumber(d)
			return d
		else
			return 0
		end
	end
end

function longdate2unix(sDate)
-- parametr - date in one of the formats:
-- dd.mm.yyyy hh:mm:ss
-- dd.mm.yy hh:mm:ss
-- dd.mm.yyyy hh:mm
-- dd.mm.yy hh:mm
-- dd.mm.yyyy
-- dd.mm.yy
-- mm.yyyy
-- mm.yy
-- yyyy
-- yy
	local dy = "1980"
	local dm = "1"
	local dd = "1"
	local th = "0"
	local tm = "0"
	local ts = "0"
	if string.find(tostring(sDate),"^(%d+)%.(%d+)%.(%d+)%s(%d+)%:(%d+)%:(%d+)$") then
		_,_,dd,dm,dy,th,tm,ts = string.find(tostring(sDate),"^(%d+)%.(%d+)%.(%d+)%s(%d+)%:(%d+)%:(%d+)$")
	else
		if string.find(tostring(sDate),"^(%d+)%.(%d+)%.(%d+)%s(%d+)%:(%d+)$") then
			_,_,dd,dm,dy,th,tm = string.find(tostring(sDate),"^(%d+)%.(%d+)%.(%d+)%s(%d+)%:(%d+)$")
		else
			if string.find(tostring(sDate),"^(%d+)%.(%d+)%.(%d+)%$") then
				_,_,dd,dm,dy = string.find(tostring(sDate),"^(%d+)%.(%d+)%.(%d+)$")
			else
				if string.find(tostring(sDate),"^(%d+)%.(%d+)%$") then
					_,_,dm,dy = string.find(tostring(sDate),"^(%d+)%.(%d+)$")
				else
					if string.find(tostring(sDate),"^(%d+)%$") then
						_,_,dy = string.find(tostring(sDate),"^(%d+)$")
					else
						return os.time()
					end
				end
			end
		end
	end
	dd = tonumber(dd)
	dm = tonumber(dm)
	dy = tonumber(dy)
	if dy < 100 then
		dy = dy + 2000
	end
	th = tonumber(th)
	tm = tonumber(tm)
	ts = tonumber(ts)
	return os.time({["year"]=dy,["month"]=dm,["day"]=dd,["hour"]=th,["min"]=tm,["sec"]=ts})
end

function selectMsg(iRem)
	local tmpt = 1
	local tmpi = "1s"
	if iRem < 1 then
		currmsg = ""
		currdiv = 1
		return 0
	end
	for k,v in pairs(freqs) do
		if ((iRem > v) and (v > tmpt)) then
			tmpt = v
			tmpi = k
		end
	end
	currmsg = messages[tmpi]
	currdiv = tmpt
	currdiv2 = divs[tmpi]
	return 1
end

function VH_OnTimer()
	if timert>0 then
		local rem=timerm-(os.time()+srvtoffset)
		local t = selectMsg(rem)
		if t==1 then
			local newmod = math.mod(rem,currdiv)
			if newmod == 0 then
				prevmod = currdiv
				Send(string.gsub(currmsg,"%%d",tostring(math.floor(rem/currdiv2))))
				return 1
			end
			if newmod > prevmod then
				Send(string.gsub(currmsg,"%%d",tostring(math.floor(rem/currdiv2+0.5))))
			end
			prevmod=newmod
			return 1
		end
		if t==0 then
			Send(finalmsg);
			timert = -1
			return 1
		end
	end
	return 1
end

function Main()
	for k,v in pairs(messages) do
		if not freqs[k] then
			freqs[k] = k
		end
	end
	local r,tm = VH:GetConfig("config","timer_serv_period")
	local tdiv = 2
	if r then
		tdiv = tonumber(tm)+1
	end
	timerm=longdate2unix(enddate)
	for k,v in pairs(freqs) do
		local t = DCtime2secs(v)
		local _,_,l = string.find(tostring(v),"^%d+(%a)$")
		if t>tdiv then
			freqs[k] = t
		else
			freqs[k] = tdiv
		end
		if l~="M" then
			l=string.lower(l)
		end
		if times[l] then
			divs[k]=times[l];
		else
			divs[k]=1;
		end
	end	
	selectMsg(timerm-(os.time()+srvtoffset))
	prevmod=currdiv
	VH:SendDataToAll("*** Countdown by Mr.Reese loaded|",0,10)
	VH:SendDataToAll("*** MAiN HuB Hosting: dchub://10.100.95.1|",0,10)
end

function UnLoad()
	VH:SendDataToAll("*** Countdown by Mr.Reese unloaded|",0,10)
end