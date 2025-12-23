local airtable = require("airtable")

local baseId = "appPuNphBk66oxD2U"
local tableId = "tbl4XMBrxtT8OHFpH"

local field, err = airtable.createField(baseId, tableId, "singleLineText", {
    name = "New Field",
    description = "A new text field"
})

if err then
    print("Error:", err)
else
    pprint(field)
end
