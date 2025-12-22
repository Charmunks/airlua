<div align="center">

# Airlua

[![Hackatime Badge](https://hackatime-badge.hackclub.com/U07UV4R2G4T/airlua)](https://hackatime.hackclub.com/) [![Hack Club Badge](https://img.shields.io/badge/Hack%20Club-EC3750?logo=Hack%20Club&logoColor=white)](https://flavortown.hackclub.com/projects/356) 

WIP Airtable API client for Lua
</div>

## Features

- We aim to support **all** Airtable API features natively
- Built in protection against Airtable injections
- Support for modifying/getting records using field values, not just record IDs

## Installation

Airlua requires [Astra](https://astra.arkforge.net/), a modern lua runtime with built in support for HTTP requests, and many other useful functions. Astra allows Airlua to be 100% written in Lua.

Once you have Astra installed, simply download airtable.lua and add it to your project folder. (Luarocks support coming soon)

## Progress

| Type |  Percent | Completed | To-do |
|------|----------|-----------|-------|
| Records | 100% | All routes supported | - |
| Tables | 0% | Not started | Implement table management |
| Fields | 0% | Not started | Implement field management |
| Comments | 0% | Not started | Implement comment management | 
| Bases | 0% | Not started | Implement base management
| Webhooks | 0% | Not started | Implement webhook management

## Docs

### Functions

#### `airtable.list(base_id, table_name, view, params)`

Lists records from a table.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `view` (string, optional) - The name of a view to filter by
- `params` (table, optional) - Additional parameters (e.g., `filterByFormula`, `maxRecords`, `sort`)

**Returns:** Table containing `records` array, or `nil` and error message

```lua
local records, err = airtable.list("appXXXXXXXXXX", "Tasks", "Grid view", {maxRecords = 10})
```

---

#### `airtable.get(base_id, table_name, record_id)`

Retrieves a single record by its ID.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `record_id` (string) - The ID of the record to retrieve

**Returns:** Record object, or `nil` and error message

```lua
local record, err = airtable.get("appXXXXXXXXXX", "Tasks", "recXXXXXXXXXX")
```

---

#### `airtable.getByField(base_id, table_name, field, value)`

Retrieves the first record matching a field value.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `field` (string) - The field name to search by
- `value` (string) - The value to match

**Returns:** First matching record, or `nil`/error message

```lua
local record = airtable.getByField("appXXXXXXXXXX", "Users", "Email", "user@example.com")
```

---

#### `airtable.create(base_id, table_name, fields)`

Creates a new record in the table.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `fields` (table, optional) - The field values for the new record

**Returns:** Created record object, or `nil` and error message

```lua
local record, err = airtable.create("appXXXXXXXXXX", "Tasks", {Name = "New Task", Status = "Todo"})
```

---

#### `airtable.update(base_id, table_name, record_id, fields)`

Updates an existing record by its ID.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `record_id` (string) - The ID of the record to update
- `fields` (table) - The field values to update

**Returns:** Updated record object, or `nil` and error message

```lua
local record, err = airtable.update("appXXXXXXXXXX", "Tasks", "recXXXXXXXXXX", {Status = "Done"})
```

---

#### `airtable.updateByField(base_id, table_name, field, value, updatedFields)`

Updates the first record matching a field value.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `field` (string) - The field name to search by
- `value` (string) - The value to match
- `updatedFields` (table) - The field values to update

**Returns:** Updated record object, or `nil` and error message

```lua
local record, err = airtable.updateByField("appXXXXXXXXXX", "Users", "Email", "user@example.com", {Name = "Updated Name"})
```

---

#### `airtable.delete(base_id, table_name, record_id)`

Deletes a record by its ID.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `record_id` (string) - The ID of the record to delete

**Returns:** Deletion confirmation object, or `nil` and error message

```lua
local result, err = airtable.delete("appXXXXXXXXXX", "Tasks", "recXXXXXXXXXX")
```

---

### Bulk Operations

#### `airtable.createBulk(base_id, table_name, recordsArray)`

Creates multiple records in a single request (max 10 per request).

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `recordsArray` (table) - Array of field tables for each record

**Returns:** Table containing `records` array with created records, or `nil` and error message

```lua
local result, err = airtable.createBulk("appXXXXXXXXXX", "Tasks", {
    {Name = "Task 1", Status = "Todo"},
    {Name = "Task 2", Status = "In Progress"},
    {Name = "Task 3", Status = "Done"}
})
```

---

#### `airtable.updateBulk(base_id, table_name, recordsArray)`

Updates multiple records in a single request (max 10 per request).

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `recordsArray` (table) - Array of tables, each with `id` and `fields` properties

**Returns:** Table containing `records` array with updated records, or `nil` and error message

```lua
local result, err = airtable.updateBulk("appXXXXXXXXXX", "Tasks", {
    {id = "recXXXXXXXXX1", fields = {Status = "Done"}},
    {id = "recXXXXXXXXX2", fields = {Status = "Done"}},
})
```

---

#### `airtable.deleteBulk(base_id, table_name, recordIds)`

Deletes multiple records in a single request (max 10 per request).

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `recordIds` (table) - Array of record IDs to delete

**Returns:** Table containing `records` array with deletion confirmations, or `nil` and error message

```lua
local result, err = airtable.deleteBulk("appXXXXXXXXXX", "Tasks", {
    "recXXXXXXXXX1",
    "recXXXXXXXXX2",
    "recXXXXXXXXX3"
})
```

---

### Utility Functions

#### `airtable.sanitizeFormulaValue(value)`

Sanitizes a value for safe use in Airtable formulas by escaping quotes and removing parentheses.

**Parameters:**
- `value` (any) - The value to sanitize

**Returns:** Sanitized string

---

#### `airtable.validateFormula(formula)`

Validates a formula string to ensure it doesn't contain potentially dangerous patterns.

**Parameters:**
- `formula` (string) - The formula to validate

**Returns:** `true` if valid, or `false` and error message


