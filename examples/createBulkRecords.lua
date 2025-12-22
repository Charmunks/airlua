local airtable = require("airtable")

local baseID = "appPuNphBk66oxD2U"
local tableName = "test"

local records = {
    {Name = "Bulk Record 1", Notes = "Created in bulk", Status = "Todo"},
    {Name = "Bulk Record 2", Notes = "Created in bulk", Status = "In progress"},
    {Name = "Bulk Record 3", Notes = "Created in bulk", Status = "Done"}
}

local result, err = airtable.createBulk(baseID, tableName, records)

if err then
    print(err)
else
    pprint(result)
end
