local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"
local recordId = "rec1ZhDKCYyKtdYV9"

local record, err = airtable.listComments(baseID, tableName, recordId) 

if err then
    print("Error:" ..err)
else 
    pprint(record)
end