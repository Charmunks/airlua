local airtable = require("airtable")

local baseId = "appPuNphBk66oxD2U"

local fields = {
    {
        name = "Name",
        type = "singleLineText"
    },
    {
        name = "Notes",
        type = "multilineText"
    },
    {
        name = "Status",
        type = "singleSelect",
        options = {
            choices = {
                {name = "Todo"},
                {name = "In Progress"},
                {name = "Done"}
            }
        }
    }
}

local newTable, err = airtable.createTable(baseId, "My New Table", fields, "A table")

if err then
    print("Error:", err)
else
    pprint(newTable)
end
