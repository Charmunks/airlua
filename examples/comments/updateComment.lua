local airtable = require("airtable")

local baseId = "appPuNphBk66oxD2U"
local tableName = "test"
local recordId = "rec1ZhDKCYyKtdYV9"
local commentId = "comYSy28uCqy0Yt9D"
local newContent = "This is the updated comment text"

local result, err = airtable.updateComment(baseId, tableName, recordId, commentId, newContent)

if err then
    print("Error: " .. err)
else
    pprint(result)
end
