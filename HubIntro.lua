-- Owner of the hub
local HubOwner = "Ash"

OnStartup = function()
	Core.RegBot("","","",true)
end

UserConnected = function(user)
	if Core.GetUserAllData(user) then
		local Prof = "Unregistered User"
		if user.iProfile ~= -1 then
			Prof = ProfMan.GetProfile(user.iProfile).sProfileName
		end
		local us = user.iShareSize or 0
		local msg="\n Welcome To.."
		msg=msg.."\n    ################	    ####                                        ##############   ##################"
		msg=msg.."\n    ################            ######                ####    ####    ##############   ##################"
		msg=msg.."\n    ####	       ##	        ########                ####    ####    ##                                        ####"
		msg=msg.."\n    ####	   ##	    ####    ####                                        ##                                        ####"
		msg=msg.."\n    ####           ##	####        ####    ####    ####    ####    ##                                        ####"
		msg=msg.."\n    ####       ##	        ####            ####                ####    ####    ##                                        ####"
		msg=msg.."\n    ####   ##	    ####                ####                ####    ####    ##                                        ####"
		msg=msg.."\n    ######	####                    ####                ####    ####    ##############                ####"
		msg=msg.."\n    ####	###                      ####                ####    ####    ##############                ####"
		msg=msg.."\n"
		msg=msg.."\n    ##                    ##                    ####        ##                ####	l Hello "..user.sNick..""
		msg=msg.."\n    ####            ####                ######  ##  ####            ####	l Your Ip Address : "..user.sIP..""
		msg=msg.."\n    ######    ##    ##              #######        ######        ####	l Your State : "..DoMode(user)..""
		msg=msg.."\n    ##    ####        ##          ####    ###  ##  ##    ####    ####	l Your Profile : "..Prof..""
		msg=msg.."\n    ##                    ##      ####        ###  ##  ##        ##    ####	l Your Share : "..FormatSize(us)..""
		msg=msg.."\n    ##                    ##  ####            ###  ##  ##            ######	l"
		msg=msg.."\n    ##                    ##  ##                ###  ##  ##                ####	l Hub Owner : "..HubOwner..""
		msg=msg.."\n									l"
		msg=msg.."\n    ####            ####                        ##########			l Make Sure You Read Rules First..Type '+rules'"
		msg=msg.."\n    ####            ####                        ###########			l Type '+regme 123' to register yourself with password 123"
		msg=msg.."\n    ##############                        ###      ###			l Type '+mybirthday dd/mm/yyyy' to add your birthday"
		msg=msg.."\n    ####            ####  ####        ##  ###    #####			l Type '+fan nick' to become fan of a user"
		msg=msg.."\n    ####            ####  ####        ##  ###      #####			l Type '+help' for other commands"
		msg=msg.."\n    ####            ####  ##########  ###    ####			l Minimum Share Criteria (75 GB) has been applied.. EnJoY.."
		msg=msg.."\n    ####            ####      #######    #######				"
		msg=msg.."\n"
		
		Core.SendToUser(user, "\n"..msg.."\n")
		if user.iProfile == -1 then
			Core.SendToUser(user,"<»ChandlerBing«> You can't Search/Download on this hub. Please register on the hub to get started.")
			Core.SendToUser(user, "<»ChandlerBing«> Type +regme 123 to register yourself with password 123\n")
		end
		Core.SendToUser(user,"<Hub-Admin> People With Offensive Nicks Will Be Banned. So Choose Your Nicks Smartly And Make it Interesting!")
		--Core.SendToUser(user,"<Hub-Admin> Contact Admin if any problem in sharing 100 GB data..")
		--Core.SendToUser(user,"<MAiN HuB Help Desk> @ http://10.100.95.1 \n")
		--Core.SendToUser(user,"Want to become MAiN HuB Owner? Fill the following form. http://goo.gl/forms/FF7D4oL2tp \n")
		--Core.SendToUser(user,"Teamtwister starting on 23rd January..Register yourself on teamtwister.tk and Rules are available on website...")
		--Core.SendToUser(user,"CS 1.6 http://goo.gl/forms/ofQV2QfyOQ")
		--Core.SendToUser(user,"DOTA 2 http://goo.gl/forms/zgjPyNsqQI")
		--Core.SendToUser(user,"kishan patel : 7567475090\n")
		--Core.SendToUser(user,"------------------------------------------------------------------------------------- Registration deadline 27th September -------------------------------------------------------------------------\n")
		--Core.SendToUser(user, "Dota 2 Team League Registration Link : Last Date Of Registration 03/08/2015 11:59:00 PM ")
		--Core.SendToUser(user, "https://docs.google.com/forms/d/1aVQ4Db9zHC-uXDdQtYIYD6qWk1RC9kzURkT4OqaPRxw/viewform?usp=send_form \n")
		--Core.SendToUser(user, "Counter Strike League Registration Link ")
		--Core.SendToUser(user, "http://goo.gl/forms/48KGEUY2hE \n")
		--Core.SendToUser(user, "BattleDrome T-shirts Survey:\t https://www.surveymonkey.com/s/VM3NHWV [Closes tonight, Hurry up!]")
		--Core.SendToUser(user, "Type '!createacc' To Create Account..Use '!showt' command to display teams.. Or Use Right Click Commands")
		--Core.SendToUser(user, "Type '!bet 1 1000' To bet 1000 on team 1.. Type '!bet 2 1000' To bet 1000 on team 2..")
		--Core.SendToUser(user, "Minimum Share(75 GB) criteria has been applied..")
		--Core.SendToUser(user, "========================================== BattleDrome Pools ===================================================\n")
		--Core.SendToUser(user,"Registration for BattleDrome is now OPEN..Visit http://synapse.daiict.ac.in/ for BattleDrome Rules..")
		--Core.SendToUser(user,"Registration Links for Games are given below..Go Go Go..\n")
		--Core.SendToUser(user,"BattleDrome Counter Strike 1.6 Pools --> magnet:?xt=urn:tree:tiger:QYM6L26FHWJBVC7OLZVSAAO7CLQN6ELT7J5744Q&xl=48769&dn=CS+Pools.pdf ")
		--Core.SendToUser(user,"BattleDrome DOTA 2 Pools--> magnet:?xt=urn:tree:tiger:JU3EBQRM4ZSEBBEAK4APBNMVBIB2STYRZ2SZHHI&xl=43494&dn=DOTA+2+Pools.pdf ")
		--Core.SendToUser(user,"BattleDrome FIFA 11 Pools 1st Year--> magnet:?xt=urn:tree:tiger:PDGWWN6WRFN6J5ZYN3DGQUV67BEKTVZ7MYQJ7JQ&xl=54600&dn=FIFA+Pools+1styears.pdf ")
		--Core.SendToUser(user,"BattleDrome FIFA 11 Pools --> magnet:?xt=urn:tree:tiger:O2LAQLIRZOVAKY5MUZNPHGMLKQK6STPMKVOAQPI&xl=56958&dn=FIFA+Pools.pdf ")
		--Core.SendToUser(user,"BattleDrome NFS Most Wanted Pools --> magnet:?xt=urn:tree:tiger:DXXHJLU33V3UPJ4E4XYAFPQUUSLNAZNDBUNJAYY&xl=42366&dn=NFS+MW+Pools.pdf ")
		--Core.SendToUser(user,"BattleDrome COD 4 Modern Warfare Pools --> magnet:?xt=urn:tree:tiger:YFVHM2LN7OW2MQRFFZSP47CYIX2IOZWPA5G5G2Y&xl=34660&dn=COD4+MW+Pools.pdf \n")
		--Core.SendToUser(user,"BattleDrome Age Of Empires 2 -->  \n")
		--Core.SendToUser(user,"Contact BattleDrome HelpDesk for any inquiry about the Games and Pools")
		--Core.SendToUser(user,"BattleDrome HelpDesk : \tNikhil(D-209) @ 9974416682\t\tAkhil(G-119) @ 9925522267\n\t\t\t\t\tSiddharth(E-210) @ 8866195514\t\tChitrang(E-213) @ 7600947822")
		--Core.SendToUser(user, "==================================================================================================================\n")
		--Core.SendToUser(user, "Go to DC++ HelpDesk http://10.100.95.1 .. for DC++ Noobs..\n")
		--Core.SendToUser(user,"<»Macße†h«> If you get tempban for duplicate ip means there is already a dc client running in background check it")
		--Core.SendToUser(user,"<-=DA-IICiTy-Hub-=> Some Registrations/chat-ranks are rolled back due to hdd crash- pm if you remember your rank")
		--Core.SendToUser(user,"<-=DA-IICiTy-Hub-=> 4th years pm any master to become an op")
		--Core.SendToUser(user,"Minimum Share Criteria has been REMOVED.. EnJoY..:P")
		Core.SendToUser(user,"Please Do Not Download Anything By Yourself(Especially from Torrent).. If you want something, Add it to the Requests here..\n")
		--Core.SendToUser(user,"<Counter-Strike> ### Get the details of CS Servers running on DA-IICT LAN at http://10.100.91.21 ! Refresh rate: 5 min. You may need to Reload the page. Use IE/Chrome, not Firefox :!:")
		--Core.SendToUser(user,"<Counter-Strike> ### Cs DeathMatch @ 10.100.91.21:27016 ! Don't forget the port 27016. Happy Fragging !\n")
		--msg=msg.."\n=============================================================================================================================="
		--msg=msg.."\nBattleDrome T-shirts Survey:\t https://www.surveymonkey.com/s/VM3NHWV [Closes tonight, Hurry up!]"
		--msg=msg.."\n\nNote: The colour shade used for printing of the Collar Tees will be the same as that of the Round Neck Tee.\nHowever just in the image of Collar Tee, the colour shade is different."
		--msg=msg.."\n=============================================================================================================================="
		--msg=msg.."\nNote: Share limit has been removed till August.. EnJoY.."
		Core.SendToUser(user,"<»TARS«> Please use IP Messenger, it's good for announcements :P")
		--Core.SendToUser(user,"Poll for Battledrome T-Shirts: tinyurl.com/battledrome2017\n")
		Core.SendToUser(user,"<»TARS«> Please share stuff that you think is good for the community. Don't share C drive! ")
		--Core.SendToUser(user,"<»TARS«> Please release stuff! ")
		Core.SendToUser(user,"<»TARS«> If you want something, add it to the requests.")
		--Core.SendToUser(user," ======================================================= BattleDrome Synapse'17 ======================================================\n")
        --Core.SendToUser(user," BattleDrome Counter Strike 1.6 --> https://goo.gl/forms/raOI6uzuVpDvZ7ck1 ")
		--Core.SendToUser(user," BattleDrome DOTA 2 --> https://goo.gl/forms/Bfql8JCr4oBsd2oy1")
		--Core.SendToUser(user," BattleDrome FIFA 14 --> https://goo.gl/forms/jcfQOP6T1JBcoAuw1")
		--Core.SendToUser(user," BattleDrome NFS-MW --> https://goo.gl/forms/TTiGOT2iHtP1PgUv2")
		--Core.SendToUser(user," BattleDrome Mortal Kombat Komplete Edition --> https://goo.gl/IkE3hY")
		--Core.SendToUser(user," Want to be the next hub owner? Register here --> https://goo.gl/forms/kiM0hvfvPLuiyOI82\n") 
		--Core.SendToUser(user,"For any other queries contact:")
		--Core.SendToUser(user,"Prashant : 89801 10959")
		--Core.SendToUser(user,"Mayur : 70461 22906")
		--Core.SendToUser(user," ================================================= Last Day for Registration : 15th Feb 2016. =========================================\n")

	end
end

DoMode = function(user)
	if user.sMode then
		local Mode = "Passive"
		if user.sMode == "A" then
			Mode = "Active"
		elseif user.sMode == "S" then
			Mode = "Socks5"
		end
		return Mode
	else
		return "Unlisted Client / Mode Unavailable"
	end
end

FormatSize = function(int)
	local i,u,x = tonumber(int) or 0,{"","K","M","G","T","P"},1
	while i > 1024 do i,x = i/1024,x+1 end return string.format("%.2f %sB.",i,u[x])
end

RegConnected,OpConnected = UserConnected,UserConnected