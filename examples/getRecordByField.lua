local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"
local field = "Name"
local value = "Meow"

local record, err = airtable.getByField(baseID, tableName, field, value)


if err then
    print("Error:" ..err)
else 
    pprint(record)
end