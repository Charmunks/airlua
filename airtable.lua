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
		return nil, "Headers failed to build"
	end

	local url = "https://api.airtable.com/v0/" .. base_id .. "/" .. table_name .. "/listRecords"
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
		return nil, "Headers failed to build"
	end

	local url = "https://api.airtable.com/v0/" .. base_id .. "/" .. table_name .. "/" .. record_id
	local body = {}

	local ok, res_or_err = pcall(function()
		return http.request {
			url = url,
			method = "GET",
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

	local safeValue = airtable.sanitizeFormulaValue(value)
	local formula = "{" .. field .. "} = \"" .. safeValue .. "\""

	local records, err = airtable.list(base_id, table_name, nil, {filterByFormula = formula})

	if records then
		return records.records[1]
	else 
		return err
	end


end

return airtable

