require 'winapi'

function reg_read(key, values)
  local res = {}
  local data = nil
  k,err = winapi.open_reg_key(key, true)
  if not k then return nil end

  if not (type(values) == 'table') then
    data = k:get_value(values)
    k:close()
    return data
  end

  for i,v in ipairs(values) do
    data = k:get_value(v)
    res[v] = data
  end

  k:close()
  return res
end

function reg_write(key, name, value, type)
  k,err = winapi.open_reg_key(key, true)
  if not k then -- create the key if the key isn't exists
    winapi.create_reg_key(key)
    k,err = winapi.open_reg_key(key, true) -- open again
    if not k then return nil end
  end
  if type == nil then type = winapi.REG_SZ end
  k:set_value(name, value, type)
  k:close()
  return 1
end

function reg_delete(key, name)
  k,err = winapi.open_reg_key(key, true)
  if not k then return nil end
  if name == nil then
    k:delete()
  else
    k:del_value(name)
  end
  k:close()
  return 0
end
