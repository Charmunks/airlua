local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"
local field = "Name"
local value = "Meow"
local updatedFields = {Name = "Ts worked yipee"}


local record, err = airtable.updateByField(baseID, tableName, field, value, updatedFields)


if err then
    print("Error:" ..err)
else 
    pprint(record)
end