local airtable = require("airtable")

local baseId = "appPuNphBk66oxD2U"

local schema, err = airtable.getBaseSchema(baseId)

if err then
    print("Error:", err)
else
    for _, tbl in ipairs(schema.tables) do
        print("Table:", tbl.name, "ID:", tbl.id)
        for _, field in ipairs(tbl.fields) do
            print("  Field:", field.name, "Type:", field.type)
        end
    end
end
