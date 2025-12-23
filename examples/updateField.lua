local airtable = require("airtable")

local baseId = "appPuNphBk66oxD2U"
local tableId = "tbl4XMBrxtT8OHFpH"
local fieldId = "fldAELKtX4Jq9oXja"

local field, err = airtable.updateField(baseId, tableId, fieldId, {
    name = "Meow Mrrp",
    description = "meowing"
})

if err then
    print("Error:", err)
else
    pprint(field)
end
