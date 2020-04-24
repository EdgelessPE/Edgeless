function string.dump(self)
  local i = 1
  local out = ''
    while true do
      local num1=self:byte(i)
      local hex
      if num1 == nil then break end
      hex = string.format("%0x ", num1)
      out = out .. hex
      if i % 8 == 0 then
        p(out)
        out = ''
      end
      i = i + 1
    end
    if out ~= '' then
      p(out)
    end
end
