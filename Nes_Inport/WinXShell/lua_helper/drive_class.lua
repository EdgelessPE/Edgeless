require 'lua_helper.lua_helper'
require 'winapi'

print = app.print

Drives = {}

function Drives:get_letters()
  return winapi.get_logical_drives()
end


function Drives:detect(file)
  local letters = Drives:get_letters()
  for _, l in ipairs(letters) do
    if File.exists(l .. file) then
      return Drive:new(l)
    end
  end
end

Drive = {letter = '', type = '?'}

function Drive:new(letter, o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.letter = letter or ''
  self.type = winapi.get_drive_type(letter)
  return o
end


function Drive:set_letter(new_letter)
    if app:call('Drive::ChangeLetter', self.letter, new_letter) then
        self.letter = new_letter
        return true
    end
end


local function main()
  local drive = Drives:detect('bootmgr.efi')
  if drive then
    print(drive.letter)
    drive:set_letter('Y:')
  end
  app:call('sleep', 2000)
end

main()

