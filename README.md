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

Once you have Astra installed, simply download airtable.lua and add it to your project folder, or run:
```bash
luarocks install airtable-lua
```
Note: for installation with luarocks, use "airtable-lua" instead of airtable for imports

## Progress

| Type |  Percent | Completed | To-do |
|------|----------|-----------|-------|
| Records | 100% | All routes supported | - |
| Tables | 0% | Not started | Implement table management |
| Fields | 100% | All routes supported | - |
| Comments | 100% | All routes supported | Implement comment management | 
| Bases | 0% | Not started | Implement base management
| Webhooks | 0% | Not started | Implement webhook management

## Docs

### Records

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

### Bulk Records

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

### Fields

#### `airtable.createField(base_id, table_id, fieldtype, options)`

Creates a new field in a table.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_id` (string) - The ID of the table
- `fieldtype` (string) - The type of field to create (e.g., `"singleLineText"`, `"number"`, `"checkbox"`)
- `options` (table) - Field options:
  - `name` (string) - The name of the field
  - `description` (string, optional) - Field description (max 20,000 characters)

**Returns:** Created field object, or `nil` and error message

```lua
local field, err = airtable.createField("appXXXXXXXXXX", "tblXXXXXXXXXX", "singleLineText", {
    name = "New Field",
    description = "A description of this field"
})
```

---

#### `airtable.updateField(base_id, table_id, field_id, options)`

Updates an existing field in a table.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_id` (string) - The ID of the table
- `field_id` (string) - The ID of the field to update
- `options` (table) - Field options to update:
  - `name` (string, optional) - The new name of the field
  - `description` (string, optional) - New field description (max 20,000 characters)

**Returns:** Updated field object, or `nil` and error message

```lua
local field, err = airtable.updateField("appXXXXXXXXXX", "tblXXXXXXXXXX", "fldXXXXXXXXXX", {
    name = "Renamed Field",
    description = "Updated description"
})
```

---

### Comments

#### `airtable.listComments(base_id, table_name, record_id)`

Lists all comments on a record.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `record_id` (string) - The ID of the record

**Returns:** Table containing `comments` array, or `nil` and error message

```lua
local comments, err = airtable.listComments("appXXXXXXXXXX", "Tasks", "recXXXXXXXXXX")
```

---

#### `airtable.createComment(base_id, table_name, record_id, text, parentCommentId)`

Creates a new comment on a record.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `record_id` (string) - The ID of the record
- `text` (string) - The comment text
- `parentCommentId` (string, optional) - The ID of a parent comment for replies

**Returns:** Created comment object, or `nil` and error message

```lua
local comment, err = airtable.createComment("appXXXXXXXXXX", "Tasks", "recXXXXXXXXXX", "This is a comment")
```

---

#### `airtable.updateComment(base_id, table_name, record_id, comment_id, content)`

Updates an existing comment.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `record_id` (string) - The ID of the record
- `comment_id` (string) - The ID of the comment to update
- `content` (string) - The new comment text

**Returns:** Updated comment object, or `nil` and error message

```lua
local comment, err = airtable.updateComment("appXXXXXXXXXX", "Tasks", "recXXXXXXXXXX", "comXXXXXXXXXX", "Updated comment")
```

---

#### `airtable.deleteComment(base_id, table_name, record_id, comment_id)`

Deletes a comment.

**Parameters:**
- `base_id` (string) - The ID of the Airtable base
- `table_name` (string) - The name or ID of the table
- `record_id` (string) - The ID of the record
- `comment_id` (string) - The ID of the comment to delete

**Returns:** Deletion confirmation object, or `nil` and error message

```lua
local result, err = airtable.deleteComment("appXXXXXXXXXX", "Tasks", "recXXXXXXXXXX", "comXXXXXXXXXX")
```

---

### Utilities

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


