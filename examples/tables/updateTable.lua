local airtable = require("airtable")

local baseId = "appPuNphBk66oxD2U"
local tableId = "tbl4XMBrxtT8OHFpH"

local updatedTable, err = airtable.updateTable(baseId, tableId, {
    name = "Renamed Table",
    description = "Updated description for this table"
})

if err then
    print("Error:", err)
else
    pprint(updatedTable)
end
