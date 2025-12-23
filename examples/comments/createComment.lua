local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"
local recordId = "rec1ZhDKCYyKtdYV9"
local content = "test comment :3"

local comment, err = airtable.createComment(baseID, tableName, recordId, content)

if err then
    print("Error:" .. err)
else 
    pprint(comment)
end
