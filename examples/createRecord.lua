local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"
local fields = {Name = "New record wahoo", Notes = "meow", Status = "Done"}

local record, err = airtable.create(baseID, tableName, fields) 

if err then
    print(err)
else 
    pprint(record)
end

