local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"
local recordId = "reczqG1dv6Bwz5Dye"

local deletion, err = airtable.delete(baseID, tableName, recordId) 

if err then
    print("Error:" ..err)
else 
    pprint(deletion)
end
