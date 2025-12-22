local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"

local recordIds = {
    "recXXXXXXXXX1",
    "recXXXXXXXXX2",
    "recXXXXXXXXX3"
}

local result, err = airtable.deleteBulk(baseID, tableName, recordIds)

if err then
    print(err)
else
    pprint(result)
end
