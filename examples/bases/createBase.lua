local airtable = require("airtable")

local workspaceId = "wspXXXXXXXXXX"

local tables = {
    {
        name = "Tasks",
        fields = {
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
    }
}

local newBase, err = airtable.createBase(workspaceId, "My New Base", tables)

if err then
    print("Error:", err)
else
    print("Created base:", newBase.id)
    pprint(newBase)
end
