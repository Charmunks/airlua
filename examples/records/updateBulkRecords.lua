local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"

local records = {
    {id = "recXXXXXXXXX1", fields = {Status = "Done"}},
    {id = "recXXXXXXXXX2", fields = {Status = "Done"}},
    {id = "recXXXXXXXXX3", fields = {Status = "Done"}}
}

local result, err = airtable.updateBulk(baseID, tableName, records)

if err then
    print(err)
else
    pprint(result)
end
