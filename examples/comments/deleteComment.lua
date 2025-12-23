local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"
local recordId = "rec1ZhDKCYyKtdYV9"
local commentId = "comXXXXXXXXXXXXXX"

local result, err = airtable.deleteComment(baseID, tableName, recordId, commentId)

if err then
    print("Error:" .. err)
else 
    pprint(result)
end
