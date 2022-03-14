if json4lua == nil then json4lua = {} end
if json4lua.internal == nil then json4lua.internal = {} end

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
  
  ["table"] = function(tab, out)
    local i = 0
    for _ in pairs(tab) do
      i = i + 1
      if tab[i] == nil then 
        json4lua.internal.write_object(tab, out)
        return
      end
    end
    json4lua.internal.write_array(tab, out)
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

json4lua.internal.write_array = function(arr, out)
  table.insert(out, "[")
  first = true
  for k, v in ipairs(arr) do
    encoder = json4lua.internal.encoder[type(v)]
    if encoder == nil then
      goto next
    end
    
    if first == false then
      table.insert(out, ",")
    else
      first = false;
    end
    
    encoder(v, out)
    ::next::
  end
  table.insert(out, "]")
end

json4lua.internal.write_object = function(obj, out)
  table.insert(out, "{")
  first = true
  for k, v in pairs(obj) do
    if type(k) ~= "string" then
      goto next
    end
    
    encoder = json4lua.internal.encoder[type(v)]
    if encoder == nil then
      goto next
    end
    
    if first == false then
      table.insert(out, ",")
    else
      first = false;
    end
    
    table.insert(out, "\"")
    table.insert(out, json4lua.internal.escape(k))
    table.insert(out, "\"")
    
    encoder(v, out)
    ::next::
  end
  table.insert(out, "}")
end

-- [[ Public API ]] --
json4lua.encode = function(obj) 
  if obj == nil then return nil end
  if type(obj) ~= "table" then
    error(string.format("json4lua.encode expected type 'table', found '%s'", type(obj)))
  end
  
  local out = {""}
  json4lua.internal.encoder["table"](obj, out)
  return table.concat(out)
end


data = {e1={{a={str="str", num=1, bool=true, arr={1, 2, 4, 8}}},{a={str="str", num=1, bool=true, arr={1, 2, 4, 8}}},{a={str="str", num=1, bool=true, arr={1, 2, 4, 8}}},{a={str="str", num=1, bool=true, arr={1, 2, 4, 8}}},{a={str="str", num=1, bool=true, arr={1, 2, 4, 8}}}}, e2={{a={str="str", num=1, bool=true, arr={1, 2, 4, 8}}},{a={str="str", num=1, bool=true, arr={1, 2, 4, 8}}},{a={str="str", num=1, bool=true, arr={1, 2, 4, 8}}},{a={str="str", num=1, bool=true, arr={1, 2, 4, 8}}},{a={str="str", num=1, bool=true, arr={1, 2, 4, 8}}}}}
for i=1, 50000 do
  json4lua.encode(data)
end
print(json4lua.encode(data))