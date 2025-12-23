local airtable = require("airtable")

local bases, err = airtable.listBases()

if err then
    print("Error:", err)
else
    for _, base in ipairs(bases.bases) do
        print("Base:", base.name, "ID:", base.id)
    end

    if bases.offset then
        print("More bases available, use offset:", bases.offset)
    end
end
