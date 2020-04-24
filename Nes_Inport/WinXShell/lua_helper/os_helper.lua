require 'reg_helper'

function os_ver_info()
  return reg_read([[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion]]
    ,{'ProductName', 'CSDVersion'})
end

function cpu_info()
  return reg_read([[HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0]]
    ,{'ProcessorNameString', '~MHz'})
end

function mem_info()
  local bin = string.format([[%sc_helper_%s.exe meminfo]], HELPERPATH, ARCH)
  local prompt = io.popen(bin)
  local mem = {}
  mem[1] = prompt:read("*line")
  mem[2] = prompt:read("*line")
  mem[3] = prompt:read("*line")
  prompt:close()
  return mem
end

function localename()
  local bin = string.format([[%sc_helper_%s.exe localename]], HELPERPATH, ARCH)
  local prompt = io.popen(bin)
  local ln = prompt:read("*line")
  prompt:close()
  return ln
end

function res_str(file, id)
  local bin = string.format([[%sc_helper_%s.exe load_resstr %s %s]], HELPERPATH, ARCH, file, id)
  local prompt = io.popen(bin)
  p(bin)
  local res = prompt:read('*line')
  prompt:close()
  return res
end

function mui_str(file, id)
  LN = LN or localename()
  local mui_file = string.format('%s\\%s.mui', LN, file)
  return res_str(mui_file, id)
end

function win_copyright()
  local bin = string.format([[%sc_helper_%s.exe copyright]], HELPERPATH, ARCH)
  local prompt = io.popen(bin)
  local cr = prompt:read('*line')
  prompt:close()
  return cr
end

function call_dll(...)
  return app:call('calldll', ...)
end
