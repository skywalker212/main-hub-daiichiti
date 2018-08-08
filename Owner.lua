--[[

	Owner Script
	
	Made by Mr.Reese			08/08/2014
	
	A script to offer custom command context menus [right click]
	
	$UserCommand <type> <context> <details>|
	
	<type> What is the command?
	0 = separator
	1 = raw - Most Commands
	2 = mainchat - File Related Commands - to prevent sending command more than once in search results
	255 = erase all previous commands
	
	<context> What is the command for?
	1 = Hub Command - Hub Settings etc...
	2 = User Command - User List - commands with %[nick]
	4 = File Command - Search Window
	3 = 1 + 2 = Hub and User
	5 = 1 + 4 = Hub and File
	6 = 2 + 4 = User and File
	7 = 1 + 2 + 4 = Hub, User and File
	
	<details> Differs per <type>
	<type> 0 = leave blank
	<type> 1 = <title>$<command> or <menu>\\<title>$<command> or <menu>\\submenu\\<title>$<command>
	<type> 2 = see type 1
	<type> 255 = clear all menus

]]
tConfig = {
	Bot = "L0rD Mr.Reese", -- Name of Bot
	--Menus
	rcMenu = "Pt0KaX", -- Ptokax Commands
	rcMenu1 = "DoAction", -- +do Commands
	--SubMenus
	rcSubMenu = "Mr.Reese",
	rcSubMenu1 = "Babu",
	rcSubMenu2 = "KitKat",
	rcSubMenu3 = "Light",
	rcSubMenu4 = "Price",
	rcSubMenu5 = "BlackBurn",
	rcSubMenu6 = "G3NJ!",
	RightClick = {
		[0] = true, -- Owner
	},
}

OnStartup = function()
	Core.RegBot("","","",true)
end

UserConnected = function(user)
	if tConfig.RightClick[user.iProfile] then
		
		local msg="Lord Mr.Reese of the Dark Side has arrived."
		Core.SendToAll(""..msg.."\n")
		Core.SendToUser(user, ""..msg.."\n")
		
		--Pt0KaX Commands
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu.."\\Full Ban User$<%[mynick]> !fullban %[nick] %[line:Reason]&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu.."\\Full Ban IP$<%[mynick]> !fullbanip %[IP] %[line:Reason]&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu.."\\Ban User's Nick$<%[mynick]> !nickban %[nick] %[line:Reason]&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu.."\\Get Bans$<%[mynick]> !getbans&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu.."\\Get Perm Bans$<%[mynick]> !getpermbans&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu.."\\Get Temp Bans$<%[mynick]> !gettempbans&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu.."\\Clear Perm Bans$<%[mynick]> !clrpermbans&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu.."\\Clear Temp Bans$<%[mynick]> !clrtempbans&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu.."\\Gag User$<%[mynick]> !gag %[nick]&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu.."\\UnGag User$<%[mynick]> !ungag %[nick]&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu.."\\Mass Message$<%[mynick]> !massmsg %[line:Message]&#124;|")
		
		--DoAction Commands
			--Random Attacks
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\Random Attacks\\brk1!$<%[mynick]> +do brk1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\Random Attacks\\brk2!$<%[mynick]> +do brk2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\Random Attacks\\krb1!$<%[mynick]> +do krb1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\Random Attacks\\krb2!$<%[mynick]> +do krb2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\Random Attacks\\brp1!$<%[mynick]> +do brp1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\Random Attacks\\brp2!$<%[mynick]> +do brp2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\Random Attacks\\krp1!$<%[mynick]> +do krp1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\Random Attacks\\krp2!$<%[mynick]> +do krp2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\Random Attacks\\prb1!$<%[mynick]> +do prb1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\Random Attacks\\prk1!$<%[mynick]> +do prk1&#124;|")
		
			--Babu
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu1.."\\Room!$<%[mynick]> +do b1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu1.."\\Sad Person!$<%[mynick]> +do b2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu1.."\\Horny!$<%[mynick]> +do b3&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu1.."\\Love!$<%[mynick]> +do b4&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu1.."\\HubLove!$<%[mynick]> +do b5&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu1.."\\Song Time!$<%[mynick]> +do b6&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu1.."\\Naked!$<%[mynick]> +do b7&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu1.."\\Think!$<%[mynick]> +do b8&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu1.."\\Attack!\\Beat Shit!$<%[mynick]> +do mrb1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu1.."\\Attack!\\Bazooka!$<%[mynick]> +do mrb2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu1.."\\Attack!\\Diaper Slap!$<%[mynick]> +do mrb3&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu1.."\\Attack!\\Stuff!$<%[mynick]> +do mrb4&#124;|")
		
			--KitKat
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu2.."\\Room!$<%[mynick]> +do k1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu2.."\\Sad Person!$<%[mynick]> +do k2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu2.."\\Horny!$<%[mynick]> +do k3&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu2.."\\Love!$<%[mynick]> +do k4&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu2.."\\HubLove!$<%[mynick]> +do k5&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu2.."\\Song Time!$<%[mynick]> +do k6&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu2.."\\Naked!$<%[mynick]> +do k7&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu2.."\\Think!$<%[mynick]> +do k8&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu2.."\\Attack!\\Beat Shit!$<%[mynick]> +do mrk1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu2.."\\Attack!\\Bazooka!$<%[mynick]> +do mrk2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu2.."\\Attack!\\Diaper Slap!$<%[mynick]> +do mrk3&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu2.."\\Attack!\\Stuff!$<%[mynick]> +do mrk4&#124;|")
		
			--Price
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu4.."\\Room!$<%[mynick]> +do p1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu4.."\\Sad Person!$<%[mynick]> +do p2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu4.."\\Horny!$<%[mynick]> +do p3&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu4.."\\Love!$<%[mynick]> +do p4&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu4.."\\HubLove!$<%[mynick]> +do p5&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu4.."\\Song Time!$<%[mynick]> +do p6&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu4.."\\Naked!$<%[mynick]> +do p7&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu4.."\\Think!$<%[mynick]> +do p8&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu4.."\\Attack!\\Beat Shit!$<%[mynick]> +do mrp1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu4.."\\Attack!\\Bazooka!$<%[mynick]> +do mrp2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu4.."\\Attack!\\Diaper Slap!$<%[mynick]> +do mrp3&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu4.."\\Attack!\\Stuff!$<%[mynick]> +do mrp4&#124;|")
		
			--BlackBurn
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu5.."\\Room!$<%[mynick]> +do bb1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu5.."\\Sad Person!$<%[mynick]> +do bb2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu5.."\\Horny!$<%[mynick]> +do bb3&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu5.."\\Love!$<%[mynick]> +do bb4&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu5.."\\HubLove!$<%[mynick]> +do bb5&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu5.."\\Song Time!$<%[mynick]> +do bb6&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu5.."\\Naked!$<%[mynick]> +do bb7&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu5.."\\Think!$<%[mynick]> +do bb8&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu5.."\\Attack!\\Beat Shit!$<%[mynick]> +do mrbb1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu5.."\\Attack!\\Bazooka!$<%[mynick]> +do mrbb2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu5.."\\Attack!\\Diaper Slap!$<%[mynick]> +do mrbb3&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu5.."\\Attack!\\Stuff!$<%[mynick]> +do mrbb4&#124;|")
		
			--G3NJ!
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu6.."\\Room!$<%[mynick]> +do l1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu6.."\\Sad Person!$<%[mynick]> +do l2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu6.."\\Horny!$<%[mynick]> +do l3&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu6.."\\Love!$<%[mynick]> +do l4&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu6.."\\HubLove!$<%[mynick]> +do l5&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu6.."\\Song Time!$<%[mynick]> +do l6&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu6.."\\Naked!$<%[mynick]> +do l7&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu6.."\\Think!$<%[mynick]> +do l8&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu6.."\\Attack!\\Beat Shit!$<%[mynick]> +do mrl1&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu6.."\\Attack!\\Bazooka!$<%[mynick]> +do mrl2&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu6.."\\Attack!\\Diaper Slap!$<%[mynick]> +do mrl3&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu6.."\\Attack!\\Stuff!$<%[mynick]> +do mrl4&#124;|")
		
		
			--Mr.Reese
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Abduction by Aliens!$<%[mynick]> +do abducted&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Away From Keyboard!$<%[mynick]> +do afk&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Crappy Day!$<%[mynick]> +do bad&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Will Be Back!$<%[mynick]> +do bbl&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Beer Time!$<%[mynick]> +do beer&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Beer's Out!$<%[mynick]> +do beers&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Left Back!$<%[mynick]> +do blb&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\BRB!$<%[mynick]> +do brb&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Chocs!$<%[mynick]> +do choc&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Lappy$<%[mynick]> +do lappy&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Cat!$<%[mynick]> +do cat&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Coffee++!$<%[mynick]> +do coffee&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Coca Cola!$<%[mynick]> +do cola&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Dead!$<%[mynick]> +do dead&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Dog!$<%[mynick]> +do dog&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Drunk!$<%[mynick]> +do drunk&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Eating Now!$<%[mynick]> +do eat&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Elvis!$<%[mynick]> +do elvis&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Not Evil!$<%[mynick]> +do evil&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Hub Fire!$<%[mynick]> +do fire&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Cafe Time!$<%[mynick]> +do food&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Sad Person!$<%[mynick]> +do funtalk&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Game!$<%[mynick]> +do game&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Summer Holiday!$<%[mynick]> +do holiday&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Horny!$<%[mynick]> +do horny&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Ignore!$<%[mynick]> +do ignore&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Building!$<%[mynick]> +do in&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Love!$<%[mynick]> +do inlove&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Hub Love!$<%[mynick]> +do lovehub&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Good Mood!$<%[mynick]> +do mood&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Crappy Program!$<%[mynick]> +do msn&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Murder!$<%[mynick]> +do murder&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\No Smoking!$<%[mynick]> +do nosmoke&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Make Faces!$<%[mynick]> +do pull&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Rain Play!$<%[mynick]> +do rain&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Relaxing!$<%[mynick]> +do relax&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Return!$<%[mynick]> +do return&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Scream!$<%[mynick]> +do scream&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Song Time!$<%[mynick]> +do sing&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Smoke!$<%[mynick]> +do smoke&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Strip Off!$<%[mynick]> +do strips&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Stare At Sun!$<%[mynick]> +do sun&#124;|")
		--Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Think!$<%[mynick]> +do think&#124;|")
		Core.SendToNick(user.sNick,"$UserCommand 1 3 ReeseCmds\\"..tConfig.rcMenu1.."\\"..tConfig.rcSubMenu.."\\Tired!$<%[mynick]> +do tired&#124;|")
		
	end
end

OpConnected = UserConnected

--UserDisconnected = function(user)
--	Msg="Lord Mr.Reese walks out from the darkness."
--		Core.SendToAll(""..Msg.."")
--		Core.SendToUser(user,""..Msg.."")
--end

--OpDisconnected = UserDisconnected