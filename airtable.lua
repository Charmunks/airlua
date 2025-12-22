local http = require("http")
local json = require("serde").json
local airtable = {}

local dangerousPatterns = {
	"IF%s*%(",
	"SWITCH%s*%(",
	"ERROR%s*%(",
	"RECORD_ID%s*%(",
	"CREATED_TIME%s*%(",
	"LAST_MODIFIED_TIME%s*%(",
	"REGEX_MATCH%s*%(",
	"REGEX_REPLACE%s*%(",
	"REGEX_EXTRACT%s*%(",
}

function airtable.sanitizeFormulaValue(value)
	if type(value) ~= "string" then
		return tostring(value)
	end
	local sanitized = value:gsub('"', '\\"')
	sanitized = sanitized:gsub("'", "\\'")
	sanitized = sanitized:gsub("%(", "")
	sanitized = sanitized:gsub("%)", "")
	return sanitized
end

function airtable.validateFormula(formula)
	if type(formula) ~= "string" then
		return false, "formula must be a string"
	end
	local upper = formula:upper()
	for _, pattern in ipairs(dangerousPatterns) do
		if upper:match(pattern:upper()) then
			return false, "potentially dangerous formula pattern detected: " .. pattern
		end
	end
	return true
end

local function get_api_key()
	local key = os.getenv("AIRTABLE_API_KEY")
	if not key or key == "" then
		return nil, "AIRTABLE_API_KEY not set in environment or .env file"
	end
	return key
end


local function build_headers()
	local api_key, err = get_api_key()
	if not api_key then
		pprint({ error = "missing_airtable_api_key", message = err })
		return nil, err
	end

	return {
		["Authorization"] = "Bearer " .. api_key,
		["Content-Type"] = "application/json"
	}
end

local function validateInput(input)
	if type(input) ~= "string" or input == "" then
		return nil
	else 
		return true
	end
end

local function url_encode(str)
	return str:gsub("([^%w%-_%.~])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
end

function airtable.list(base_id, table_name, view, params)
	if not validateInput(table_name) then
		return nil, "Invalid table_name"
	end

	if not base_id then
		return nil, "Missing base_id"
	end

	local headers, herr = build_headers()
	if not headers then
		return nil, herr
	end

	local url = "https://api.airtable.com/v0/" .. base_id .. "/" .. url_encode(table_name) .. "/listRecords"
	local body = {}
	if params and type(params) == "table" then
		for k, v in pairs(params) do
			body[k] = v
		end
		if body.filterByFormula then
			local valid, err = airtable.validateFormula(body.filterByFormula)
			if not valid then
				return nil, "Invalid filter by formula"
			end
		end
	end
	if view and type(view) == "string" and view ~= "" then
		body["view"] = view
	end

	local ok, res_or_err = pcall(function()
		return http.request {
			url = url,
			method = "POST",
			headers = headers,
			body = json.encode(body)
		}:execute()
	end)

	if not ok then
		return nil, res_or_err
	end

	local res = res_or_err

	if not res then
		return nil, "No response from airtable"
	end

	local status = res:status_code()
	local body_text = nil
	local ok2, dec = pcall(function()
		body_text = res:body() and res:body():text() or nil
		return body_text and json.decode(body_text) or nil
	end)

	if status >= 400 then
		return ok2 and dec or nil, status
	end

	return ok2 and dec or nil
end

function airtable.get(base_id, table_name, record_id)
	if not validateInput(table_name) then
		return nil, "Invalid table_name"
	end

	if not validateInput(record_id) then
		return nil, "Invalid record_id (must be a string)"
	end

	if not base_id then
		return nil, "Missing base_id"
	end

	local headers, herr = build_headers()
	if not headers then
		return nil, herr
	end

	local url = "https://api.airtable.com/v0/" .. base_id .. "/" .. url_encode(table_name) .. "/" .. url_encode(record_id)

	local ok, res_or_err = pcall(function()
		return http.request {
			url = url,
			method = "GET",
			headers = headers,
		}:execute()
	end)

	if not ok then
		return nil, res_or_err
	end

	local res = res_or_err

	if not res then
		return nil, "No response from airtable"
	end

	local status = res:status_code()
	local body_text = nil
	local ok2, dec = pcall(function()
		body_text = res:body() and res:body():text() or nil
		return body_text and json.decode(body_text) or nil
	end)

	if status >= 400 then
		return ok2 and dec or nil, status
	end

	return ok2 and dec or nil
end

function airtable.getByField(base_id, table_name, field, value)
	if not validateInput(table_name) then
		return nil, "Invalid table_name"
	end

	if not validateInput(field) then
		return nil, "Invalid field"
	end

	if not validateInput(value) then
		return nil, "Invalid value"
	end

	if not base_id then
		return nil, "Missing base_id"
	end

	local safeField = airtable.sanitizeFormulaValue(field)
	local safeValue = airtable.sanitizeFormulaValue(value)
	local formula = "{" .. safeField .. "} = \"" .. safeValue .. "\""

	local records, err = airtable.list(base_id, table_name, nil, {filterByFormula = formula})

	if records then
		return records.records[1]
	else 
		return nil, err
	end


end

function airtable.update(base_id, table_name, record_id, fields)
	if not validateInput(table_name) then
		return nil, "Invalid table_name"
	end

	if not validateInput(record_id) then
		return nil, "Invalid record_id (must be a string)"
	end

	if not base_id then
		return nil, "Missing base_id"
	end

	local headers, herr = build_headers()
	if not headers then
		return nil, herr
	end

	local body = {fields = fields}

	local url = "https://api.airtable.com/v0/" .. base_id .. "/" .. url_encode(table_name) .. "/" .. url_encode(record_id)

	local ok, res_or_err = pcall(function()
		return http.request {
			url = url,
			method = "PATCH",
			headers = headers,
			body = json.encode(body)
		}:execute()
	end)

	if not ok then
		return nil, res_or_err
	end

	local res = res_or_err

	if not res then
		return nil, "No response from airtable"
	end

	local status = res:status_code()
	local body_text = nil
	local ok2, dec = pcall(function()
		body_text = res:body() and res:body():text() or nil
		return body_text and json.decode(body_text) or nil
	end)

	if status >= 400 then
		return ok2 and dec or nil, status
	end

	return ok2 and dec or nil
end

function airtable.updateByField(base_id, table_name, field, value, updatedFields)
	if not validateInput(table_name) then
		return nil, "Invalid table_name"
	end

	if not validateInput(field) then
		return nil, "Invalid field"
	end

	if not validateInput(value) then
		return nil, "Invalid value"
	end

	if not base_id then
		return nil, "Missing base_id"
	end

	if not updatedFields then
		return nil, "Missing fields to update"
	end

	local safeField = airtable.sanitizeFormulaValue(field)
	local safeValue = airtable.sanitizeFormulaValue(value)
	local formula = "{" .. safeField .. "} = \"" .. safeValue .. "\""

	local records, err = airtable.list(base_id, table_name, nil, {filterByFormula = formula})
	local recId 
	if records and records.records and records.records[1] then
		recId = records.records[1].id
	else 
		return nil, err or "No record found"
	end

	local record, err2 = airtable.update(base_id, table_name, recId, updatedFields) 

	if err2 then
		return nil, err2
	else 
		return record 
	end
	
end

function airtable.create(base_id, table_name, fields)
	if not validateInput(table_name) then
		return nil, "Invalid table_name"
	end

	if not base_id then
		return nil, "Missing base_id"
	end

	local headers, herr = build_headers()
	if not headers then
		return nil, herr
	end

	local body = {}

	if fields then
		body = {fields = fields}
	end

	local url = "https://api.airtable.com/v0/" .. base_id .. "/" .. url_encode(table_name)

	local ok, res_or_err = pcall(function()
		return http.request {
			url = url,
			method = "POST",
			headers = headers,
			body = json.encode(body)
		}:execute()
	end)

	if not ok then
		return nil, res_or_err
	end

	local res = res_or_err

	if not res then
		return nil, "No response from airtable"
	end

	local status = res:status_code()
	local body_text = nil
	local ok2, dec = pcall(function()
		body_text = res:body() and res:body():text() or nil
		return body_text and json.decode(body_text) or nil
	end)

	if status >= 400 then
		return ok2 and dec or nil, status
	end

	return ok2 and dec or nil
end

function airtable.delete(base_id, table_name, record_id)
	if not validateInput(table_name) then
		return nil, "Invalid table_name"
	end

	if not validateInput(record_id) then
		return nil, "Invalid record_id (must be a string)"
	end

	if not base_id then
		return nil, "Missing base_id"
	end

	local headers, herr = build_headers()
	if not headers then
		return nil, herr
	end

	local url = "https://api.airtable.com/v0/" .. base_id .. "/" .. url_encode(table_name) .. "/" .. url_encode(record_id)

	local ok, res_or_err = pcall(function()
		return http.request {
			url = url,
			method = "DELETE",
			headers = headers
		}:execute()
	end)

	if not ok then
		return nil, res_or_err
	end

	local res = res_or_err

	if not res then
		return nil, "No response from airtable"
	end

	local status = res:status_code()
	local body_text = nil
	local ok2, dec = pcall(function()
		body_text = res:body() and res:body():text() or nil
		return body_text and json.decode(body_text) or nil
	end)

	if status >= 400 then
		return ok2 and dec or nil, status
	end

	return ok2 and dec or nil
end

function airtable.createBulk(base_id, table_name, recordsArray)
	if not validateInput(table_name) then
		return nil, "Invalid table_name"
	end

	if not base_id then
		return nil, "Missing base_id"
	end

	if not recordsArray or type(recordsArray) ~= "table" or #recordsArray == 0 then
		return nil, "recordsArray must be a non-empty array"
	end

	if #recordsArray > 10 then
		return nil, "Airtable API allows a maximum of 10 records per request"
	end

	local headers, herr = build_headers()
	if not headers then
		return nil, herr
	end

	local records = {}
	for _, fields in ipairs(recordsArray) do
		table.insert(records, {fields = fields})
	end

	local body = {records = records}
	local url = "https://api.airtable.com/v0/" .. base_id .. "/" .. url_encode(table_name)

	local ok, res_or_err = pcall(function()
		return http.request {
			url = url,
			method = "POST",
			headers = headers,
			body = json.encode(body)
		}:execute()
	end)

	if not ok then
		return nil, res_or_err
	end

	local res = res_or_err

	if not res then
		return nil, "No response from airtable"
	end

	local status = res:status_code()
	local body_text = nil
	local ok2, dec = pcall(function()
		body_text = res:body() and res:body():text() or nil
		return body_text and json.decode(body_text) or nil
	end)

	if status >= 400 then
		return ok2 and dec or nil, status
	end

	return ok2 and dec or nil
end

function airtable.updateBulk(base_id, table_name, recordsArray)
	if not validateInput(table_name) then
		return nil, "Invalid table_name"
	end

	if not base_id then
		return nil, "Missing base_id"
	end

	if not recordsArray or type(recordsArray) ~= "table" or #recordsArray == 0 then
		return nil, "recordsArray must be a non-empty array"
	end

	if #recordsArray > 10 then
		return nil, "Airtable API allows a maximum of 10 records per request"
	end

	local headers, herr = build_headers()
	if not headers then
		return nil, herr
	end

	local records = {}
	for _, record in ipairs(recordsArray) do
		if not record.id or not record.fields then
			return nil, "Each record must have 'id' and 'fields' properties"
		end
		table.insert(records, {id = record.id, fields = record.fields})
	end

	local body = {records = records}
	local url = "https://api.airtable.com/v0/" .. base_id .. "/" .. url_encode(table_name)

	local ok, res_or_err = pcall(function()
		return http.request {
			url = url,
			method = "PATCH",
			headers = headers,
			body = json.encode(body)
		}:execute()
	end)

	if not ok then
		return nil, res_or_err
	end

	local res = res_or_err

	if not res then
		return nil, "No response from airtable"
	end

	local status = res:status_code()
	local body_text = nil
	local ok2, dec = pcall(function()
		body_text = res:body() and res:body():text() or nil
		return body_text and json.decode(body_text) or nil
	end)

	if status >= 400 then
		return ok2 and dec or nil, status
	end

	return ok2 and dec or nil
end

function airtable.deleteBulk(base_id, table_name, recordIds)
	if not validateInput(table_name) then
		return nil, "Invalid table_name"
	end

	if not base_id then
		return nil, "Missing base_id"
	end

	if not recordIds or type(recordIds) ~= "table" or #recordIds == 0 then
		return nil, "recordIds must be a non-empty array"
	end

	if #recordIds > 10 then
		return nil, "Airtable API allows a maximum of 10 records per request"
	end

	local headers, herr = build_headers()
	if not headers then
		return nil, herr
	end

	local queryParams = {}
	for _, id in ipairs(recordIds) do
		if not validateInput(id) then
			return nil, "Invalid record_id in array"
		end
		table.insert(queryParams, "records[]=" .. url_encode(id))
	end

	local url = "https://api.airtable.com/v0/" .. base_id .. "/" .. url_encode(table_name) .. "?" .. table.concat(queryParams, "&")

	local ok, res_or_err = pcall(function()
		return http.request {
			url = url,
			method = "DELETE",
			headers = headers
		}:execute()
	end)

	if not ok then
		return nil, res_or_err
	end

	local res = res_or_err

	if not res then
		return nil, "No response from airtable"
	end

	local status = res:status_code()
	local body_text = nil
	local ok2, dec = pcall(function()
		body_text = res:body() and res:body():text() or nil
		return body_text and json.decode(body_text) or nil
	end)

	if status >= 400 then
		return ok2 and dec or nil, status
	end

	return ok2 and dec or nil
end

return airtable

