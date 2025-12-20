local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"
local recordId = "recPZxJUNA5qsfBLr"

local record, err = airtable.getRecord(baseID, tableName, recordId) 

if err then
    print("Error:" ..err)
else 
    pprint(record)
end