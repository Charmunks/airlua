package = "airtable-lua"
version = "scm-1"
source = {
   url = "git://github.com/Charmunks/airlua.git"
}
description = {
   summary = "Airtable API client for Lua",
   detailed = [[
      Airtable API client for Lua with the goal of supporting 100% of Airtable API methods. Made for the Astra lua runtime.
   ]],
   homepage = "https://github.com/Charmunks/airlua",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      airtable = "airtable.lua"
   }
}
