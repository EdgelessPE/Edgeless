require 'reg_helper'

System = {}
local regkey_user = 'HKEY_CURRENT_USER'
if os.getenv('USERNAME') == 'SYSTEM' then regkey_user = 'HKEY_LOCAL_MACHINE' end
local regkey_colortheme = [[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize]]

function System:GetSetting(key)
  if key == 'AppsColorTheme' then
    return (reg_read(regkey_colortheme, 'AppsUseLightTheme') or 1) | 0 -- convert to integer
  elseif key == 'SysColorTheme' then
    return (reg_read(regkey_colortheme, 'SystemUsesLightTheme') or 1) | 0
  elseif key == 'ShellColorPrevalence' then
    return (reg_read(regkey_colortheme, 'ColorPrevalence') or 1) | 0
  elseif key == 'WindowColorPrevalence' then
    local regkey = regkey_user .. [[\SOFTWARE\Microsoft\Windows\DWM]]
    return (reg_read(regkey, 'ColorPrevalence') or 1) | 0
  elseif key == 'Colors.Transparency' then
    return (reg_read(regkey_colortheme, 'EnableTransparency') or 1) | 0
  end
  return 0
end

function System:SetSetting(key, val)
  if val ~= 0 then val = 1 end
  if key == 'ShellColorPrevalence' then
    reg_write(regkey_colortheme, 'ColorPrevalence', val, winapi.REG_DWORD)
    app:call('System::ChangeColorThemeNotify')
  elseif key == 'WindowColorPrevalence' then
    local regkey = regkey_user .. [[\SOFTWARE\Microsoft\Windows\DWM]]
    reg_write(regkey, 'ColorPrevalence', val, winapi.REG_DWORD)
  elseif key == 'Colors.Transparency' then
    reg_write(regkey_colortheme, 'EnableTransparency', val, winapi.REG_DWORD)
    app:call('System::ChangeColorThemeNotify')
  end
  return 0
end

function System:SysColorTheme(mode)
    if mode == 'light' then
        reg_write(regkey_colortheme, 'SystemUsesLightTheme', 1, winapi.REG_DWORD)
    else
        reg_write(regkey_colortheme, 'SystemUsesLightTheme', 0, winapi.REG_DWORD)
    end
    app:call('System::ChangeColorThemeNotify')
end

function System:AppsColorTheme(mode)
    if mode == 'light' then
        reg_write(regkey_colortheme, 'AppsUseLightTheme', 1, winapi.REG_DWORD)
    else
        reg_write(regkey_colortheme, 'AppsUseLightTheme', 0, winapi.REG_DWORD)
    end
    app:call('System::ChangeColorThemeNotify')
end

local function power_helper(wu_param, sd_param)
  local sd = os.getenv("SystemDrive")
  if File.exists(sd ..'\\Windows\\System32\\Wpeutil.exe') then
    app:run('wpeutil.exe', wu_param, 0) -- SW_HIDE(0)
    return 0
  elseif File.exists(sd ..'\\Windows\\System32\\shutdown.exe') then
    app:run('shutdown.exe', sd_param .. ' -t 0')
    return 0
  end
  return 1
end

function System:Reboot()
  return power_helper('Reboot', '-r')
end

function System:Shutdown()
  return power_helper('Shutdown', '-s')
end

local function PinCommand(class, target, name, param, icon, index, showcmd)
  local ext = string.sub(target, -4)
  local case_ext = string.lower(ext)

  local pinned_path = [[%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\]] .. class .. '\\'
  local lnk_name = name
  if lnk_name == nil then lnk_name = string.match(target, '([^\\]+)' .. ext .. '$') end
  lnk_name = lnk_name .. '.lnk'
  if case_ext == '.lnk' then
    if app:info('isshell') ~= 0 then
      exec('/hide', 'cmd.exe /c copy /y \"' .. target .. '\" \"' .. pinned_path .. lnk_name .. '\"')
    else
      app:call(class .. '::Pin', target)
    end
    return
  end
  if case_ext ~= '.exe' then return end

  local lnk = target
  if name ~= nil or param ~= nil or icon ~= nil then
    if app:info('isshell') ~= 0 then
      lnk = pinned_path .. lnk_name
    else
      lnk = '%TEMP%\\' .. class .. 'Pinned\\' .. lnk_name
    end
    app:call('link', lnk, target, param, icon, index, showcmd)
  end
  if app:info('isshell') ~= 0 then
    if lnk == target then
      lnk = pinned_path .. lnk_name
      app:call('link', lnk, target)
    end
  else
    app:call(class .. '::Pin', lnk)
  end
end

Taskbar = {}
local regkey_setting = [[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]]

function Taskbar:IsReady(sec)
  local sh_win = winapi.find_window('Shell_TrayWnd', nil)
  local n = -1
  while (n <= sec and (sh_win == nil or sh_win:get_handle() == 0)) do
    app:print(string.format("shell Handle:0x%x", sh_win:get_handle()))
    app:call('sleep', 1000)
    sh_win = winapi.find_window('Shell_TrayWnd', nil)
    if sec ~= -1 then n = n + 1 end
  end
  if sh_win == nil or sh_win:get_handle() == 0 then
    return false
  end
  return true
end

function Taskbar:WaitForReady()
  Taskbar:IsReady(-1)
end

function Taskbar:GetSetting(key)
  if key == 'AutoHide' then return app:call('Taskbar::AutoHideState') end
  return reg_read(regkey_setting, key)
end

function Taskbar:SetSetting(key, value, type)
  return reg_write(regkey_setting, key, value, type)
end

function Taskbar:CombineButtons(value, update)
  if value == 'always' then value = 0
  elseif value == 'auto' then value = 1
  else value = 2 end --never

  Taskbar:SetSetting('TaskbarGlomLevel', value, winapi.REG_DWORD)
  if update ~= 0 then app:call('Taskbar::ChangeNotify') end
end

function Taskbar:UseSmallIcons(value, update)
  Taskbar:SetSetting('TaskbarSmallIcons', value, winapi.REG_DWORD)
  if update ~= 0 then app:call('Taskbar::ChangeNotify') end
end

function Taskbar:AutoHide(value)
  app:call('Taskbar::AutoHide', value)
end

function Taskbar:Pin(target, name, param, icon, index, showcmd)
  PinCommand('Taskbar',target, name, param, icon, index, showcmd)
end

function Taskbar:UnPin(name)
  app:call('Taskbar::UnPin', name)
end

Startmenu = {}
function Startmenu:Pin(target, name, param, icon, index, showcmd)
  PinCommand('Startmenu',target, name, param, icon, index, showcmd)
end

function Startmenu:UnPin(target)
  app:call('startmenu::unpin', target)
end

Screen = {}

local function fixscreen()
  app:call('Desktop::UpdateWallpaper')
  app:call('sleep', 200)
  app:call('Taskbar::ChangeNotify')
end

function  Screen:Get(...)
  return app:call('Screen::Get', ...)
end

function Screen:GetX()
  return app:call('Screen::Get', 'x')
end

function Screen:GetY()
  return app:call('Screen::Get', 'y')
end

function Screen:GetRotation()
  return app:call('Screen::Get', 'rotation')
end

function Screen:Disp(w, h)
  local ret = app:call('Screen::Set', 'resolution', w, h)
  if ret == 0 then
    fixscreen()
  end
  return ret
end

-- arr = {'1152x864', '1366x768', '1024x768'}
function Screen:DispTest(arr)
  local i, w, h, ret = 0
  for i = 1, #arr do
    w, h = string.match(arr[i], '(%d+)[x*](%d+)')
    if h ~= nil then
      app:print(w, h)
      if Screen:Disp(tonumber(w), tonumber(h)) == 0 then return end
    end
  end
end

FolderOptions = {}

-- Opt =
--   'ShowAll'     - Show the hidden files / folders
--   'ShowExt'     - Show the known extension
--   'ShowSuperHidden' - Always hide the system files / folders

function FolderOptions:Set(opt, val)
  app:call('FolderOptions::Set', opt, val)
end

function FolderOptions:Get(opt)
  return app:call('FolderOptions::Get', opt)
end

-- Helper(alias)
function PinToTaskbar(target, name, param, icon, index, showcmd)
  Taskbar:Pin(target, name, param, icon, index, showcmd)
end

function PinToStartMenu(target, name, param, icon, index, showcmd)
  Startmenu:Pin(target, name, param, icon, index, showcmd)
end

function LINK(lnk, target, param, icon, index, showcmd)
  link(lnk, target, param, icon, index, showcmd)
end
