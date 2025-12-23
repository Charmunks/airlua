local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"
local recordId = "recPZxJUNA5qsfBLr"
local fields = {Name = "Ts worked yipee"}

local record, err = airtable.update(baseID, tableName, recordId, fields) 

if err then
    print(err)
else 
    pprint(record)
end