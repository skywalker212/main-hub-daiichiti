--[[ 
FreshStuff3 v5
This is the common script that gets loaded by host apps, then takes care of everything else :-D
Distributed under the terms of the Common Development and Distribution License (CDDL) Version 1.0.
See docs/license.txt for details.
]]
AllStuff,NewestStuff,Engine,Bot,Commands,Levels = {},{},{},{},{},{}
Bot.version="FreshStuff3 5.0.1"
ModulesLoaded = {}

do -- detect the host app
-- This is done by detecting global tables that are specific to the host app.
local Host=
  {
    ["frmHub"]= {func = "GetPtokaXLocation", param = "frmHub", path = "scripts/freshstuff/?.lua", mod = "ptokax"},
--     ["DC"]="bcdc",
--     ["VH"]="verli",
    ["Core"] = {func = "GetPtokaXPath", path = "scripts/freshstuff/?.lua", mod = "ptokaxnew"},
  }

local c
  for glob, loader in pairs(Host) do
    if _G[glob] then
      if loader.param then
        package.path = _G[glob][loader.func](_G[loader.param])..loader.path
      else
        package.path = _G[glob][loader.func]()..loader.path
      end
      require (loader.mod)
      c = true
      break
    end
  end
  assert(c,"FATAL: This script does not support your host application. :-(")
end

require "tables"
require "kernel"

local hostloader =
  {
    ["ptokax"] = -- This is for old PtokaX
      function()
        package.cpath = frmHub:GetPtokaXLocation().."/scripts/freshstuff/lib/?.dll" -- Set the path for C libs.
        require "pxlfs" 
        package.path = frmHub:GetPtokaXLocation().."/scripts/freshstuff/components/?.lua" -- Set the path for Lua libs.
        for entry in lfs.dir(  frmHub:GetPtokaXLocation().."/scripts/freshstuff/components" ) do -- open the components directory
          local filename, ext = entry:match("([^%.]+)%.(%w%w%w)") -- search for Lua files
          if ext == "lua" then
            require (filename) -- and load them
          end
        end
      end,
    ["ptokaxnew"] = 
      function()
        package.path = Core.GetPtokaXPath().."scripts/freshstuff/components/?.lua"
        if os.getenv("windir") then -- we are running on Windows
          package.cpath = Core.GetPtokaXPath().."scripts/freshstuff/libnew/?.dll"
          require "pxlfs"
          for entry in lfs.dir( Core.GetPtokaXPath().."scripts/freshstuff/components" ) do
            local filename, ext = entry:match("([^%.]+)%.lua$")
            if filename then require (filename) end
          end
        else
          local f = io.popen("which ls")
          local ls = f:read("*l")
          f:close()
          f = io.popen(ls.." -1 "..Core.GetPtokaXPath().."scripts/freshstuff/components/")
          for line in f:lines() do
            local filename, ext = line:match("([^%.]+)%.lua$")
            if filename then require (filename) end
          end
		  f:close()
        end
      end,
  }

for k,v in pairs(hostloader) do
  if package.loaded[k] then v() break end
end

Functions={}
