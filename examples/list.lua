local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"
local view = "Grid view"

local records, err = airtable.list(baseID, tableName, view)

if err then
    print("Error:" ..err)
else 
    pprint(records)
end