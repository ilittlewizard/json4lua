if json4lua == nil then json4lua = {} end
if json4lua.internal == nil then json4lua.internal = {} end
if json4lua.config == nil then json4lua.config = {} end

-- [[ Default Configuration ]] --
json4lua.config.ignore_unsupported_datatypes = true;
json4lua.config.ignore_nonstring_keys = true;
json4lua.config.ignore_nontable_inputs = false;


-- [[ Internal API ]] --
json4lua.internal.escape_sequence = {
  [ "\\" ] = "\\\\",
  [ "\"" ] = "\\\"",
  [ "\b" ] = "\\b",
  [ "\f" ] = "\\f",
  [ "\n" ] = "\\n",
  [ "\r" ] = "\\r",
  [ "\t" ] = "\\t"
}

json4lua.internal.escape = function(str)
  local res = str:gsub("[\\\"\b\f\n\r\t]", json4lua.internal.escape_sequence)
  return res
end

json4lua.internal.encoder = {
  ["nil"] = function(val, out)
    out.write("null") 
  end,
  
  ["table"] = function(tab, out, dejavu)
    if dejavu[tab] then
      error("Circular reference found")
    end
    dejavu[tab] = 0
    local i = 0
    for _ in pairs(tab) do
      i = i + 1
      if tab[i] == nil then 
        json4lua.internal.write_object(tab, out, dejavu)
        return
      end
    end
    json4lua.internal.write_array(tab, out, dejavu)
  end,
  
  ["string"] = function(str, out)
    table.insert(out, "\"" .. json4lua.internal.escape(str) .. "\"")
  end,
  
  ["number"] = function(num, out)
    if num ~= num or num <= -math.huge or num >= math.huge then
      error("NaN or Inf found")
    end
    table.insert(out, string.format("%.14g", num))
  end,
  
  ["boolean"] = function(b, out)
    table.insert(out, "\"" .. tostring(b) .. "\"")
  end,
}

json4lua.internal.write_array = function(arr, out, dejavu)
  table.insert(out, "[")
  first = true
  for k, v in ipairs(arr) do
    encoder = json4lua.internal.encoder[type(v)]
    if encoder == nil then
      if json4lua.config.ignore_unsupported_datatypes == false then
        error("Unsupported Datatype: " .. type(v))
      end
      goto next
    end
    
    if first == false then
      table.insert(out, ",")
    else
      first = false;
    end
    
    encoder(v, out, dejavu)
    ::next::
  end
  table.insert(out, "]")
end

json4lua.internal.write_object = function(obj, out, dejavu)
  table.insert(out, "{")
  first = true
  for k, v in pairs(obj) do
    if type(k) ~= "string" then
      if json4lua.config.ignore_nonstring_keys == false then
        error("Non-string key found: type = " .. type(v))
      end
      goto next
    end
    
    encoder = json4lua.internal.encoder[type(v)]
    if encoder == nil then
      if json4lua.config.ignore_unsupported_datatypes == false then
        error("Unsupported Datatype: " .. type(v))
      end
      goto next
    end
    
    if first == false then
      table.insert(out, ",")
    else
      first = false;
    end
    
    table.insert(out, "\"")
    table.insert(out, json4lua.internal.escape(k))
    table.insert(out, "\":")
    
    encoder(v, out, dejavu)
    ::next::
  end
  table.insert(out, "}")
end

-- [[ Public API ]] --
json4lua.encode = function(obj) 
  if type(obj) ~= "table" then
    if json4lua.config.ignore_nontable_inputs == false then
      error(string.format("json4lua.encode expected type 'table', found '%s'", type(obj)))
    end
  end
  
  local out = {""}
  json4lua.internal.encoder["table"](obj, out, {})
  return table.concat(out)
end

test = {}
test.test = test
print(json4lua.encode(test))