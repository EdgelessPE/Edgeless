require('io_helper')

function wxsUI(ui, jcfg, opt, app_path)
  if jcfg == nil then jcfg = 'main.jcfg' end
  if opt == nil then opt = '' else opt = ' ' .. opt end
  if app_path == nil then app_path = app:info('path') end
  if File.exists(app_path .. '\\wxsUI\\' .. ui .. '.zip') then
    ui = ui .. '.zip'
  end
  app:run(app_path .. '\\WinXShell.exe', ' -ui -jcfg wxsUI\\' .. ui .. '\\' .. jcfg .. opt)
end


function wxs_ui(url)
    app:print(url)
    if string.find(url, 'wxs-ui:', 1, true) then
      url = url:gsub('wxs[-]ui:', '')
    end

    local exe = app_path .. '\\WinXShell.exe'
    if url == "systeminfo" then
      wxsUI('UI_SystemInfo')
    elseif url == "settings" then
      wxsUI('UI_Settings', 'main.jcfg', '-fixscreen')
    elseif url == "wifi" then
      wxsUI('UI_WIFI')
    elseif url == "volume" then
      wxsUI('UI_Volume')
    end
end

function wxs_open(url)
    app:print(url)
    if string.find(url, 'wxs-open:', 1, true) == nil then
      url = url:gsub('wxs[-]open:', '')
    end

    if url == 'controlpanel' then
      local sd = os.getenv('SystemDrive')
      if not File.exists(sd .. '\\Windows\\explorer.exe') then return end
      app:run('control.exe')
    elseif url == 'system' then
      app:call('wxs_open', 'system')
    elseif url == 'networkconnections' then
      app:call('wxs_open', 'networkconnections')
    elseif url == 'printers' then
      app:call('wxs_open', 'printers')
    elseif url == 'userslibraries' then
      app:call('wxs_open', 'userslibraries')
    elseif url == 'devices' then
      app:call('wxs_open', 'devicesandprinters')
    elseif url == 'wifi' then
      wxsUI('UI_WIFI')
    elseif url == 'volume' then
      wxsUI('UI_Volume')
    end
end

function ms_settings(url)
    app:print(url)
    if string.find(url, 'ms-settings:', 1, true) == nil then return end
    url = url:gsub('ms[-]settings:', '')

    if url == 'taskbar' then
      wxsUI('UI_Settings', 'main.jcfg', '-fixscreen')
    elseif url == 'dateandtime' then
      app:run('timedate.cpl')
    elseif url == 'display' then
      --wxsUI('UI_Resolution', 'main.jcfg')
      wxsUI('UI_Settings', 'main.jcfg', '-display -fixscreen')
    elseif url == 'personalization' then
      wxsUI('UI_Settings', 'main.jcfg', '-colors -fixscreen')
    elseif url == 'personalization-background' then
      wxsUI('UI_Settings', 'main.jcfg', '-colors -fixscreen')
    elseif url == 'sound' then
      wxsUI('UI_Volume')
    elseif url == 'network' then
      wxs_open('networkconnections')
    else
       wxs_open('controlpanel')
    end
end

function wxs_protocol(url)
  app:print(url)
  if url == 'ms-availablenetworks:' then
    wxsUI('UI_WIFI')
  else
    ms_settings(url)
  end
end

function regist_folder_shell()
  local sd = os.getenv("SystemDrive")
  if File.exists(sd .. '\\Windows\\explorer.exe') then return end

  local key = [[HKEY_CLASSES_ROOT\Folder\shell]]
  local val = reg_read(key, 'WinXShell_Registered')

  if val ~= nil then return end
  reg_write(key, 'WinXShell_Registered', 'done')

  key = [[HKEY_CLASSES_ROOT\Folder\shell\open\command]]
  val = reg_read(key, 'DelegateExecute')
  if val ~= nil then reg_write(key, 'DelegateExecute_Backup', val) end
  reg_delete(key, 'DelegateExecute')
  reg_write(key, '', '"' .. app_path .. '\\WinXShell.exe" "%1"')

  -- explore,opennewprocess,opennewtab
end

local function regist_protocol(protocol, type)
  local key = 'HKEY_CLASSES_ROOT\\' .. protocol
  local val = reg_read(key .. [[\Shell\Open\Command]], 'DelegateExecute')
  app:print(val)
  if val == nil or val ~= '{C59C9814-F038-4B71-A341-6024882458AF}' then
    reg_write(key, '', 'URL:' .. protocol)
    reg_write(key, 'URL Protocol', '')
    reg_write(key .. [[\Shell\Open\Command]], 'DelegateExecute', '{C59C9814-F038-4B71-A341-6024882458AF}')

    if type == 'App' then
      reg_write(key .. [[\Application]], 'AppUserModelId', '')
      reg_write(key .. [[\Shell\Open]], 'PackageId', '')
    end
  end
end

function regist_protocols()
  if tonumber(win_ver) < 10 then return end
  regist_protocol('ms-settings')
  regist_protocol('ms-availablenetworks', 'App')
  app:run(app_path .. '\\WinXShell.exe', '-Embedding')
end

function regist_system_property() -- handle This PC's property menu
    if not is_x then return end
    --if File.exists('X:\\Windows\\explorer.exe') then return end

    if handle_system_property == nil then return end
    if handle_system_property == '' then return end
    if handle_system_property == 'auto' then
        -- 'control system' works in x86_x64 with explorer.exe
        if ARCH == 'x64' and File.exists('X:\\Windows\\explorer.exe') and
            File.exists('X:\\Windows\\SysWOW64\\wow32.dll') then
            return
        elseif ARCH == 'x86' and File.exists('X:\\Windows\\explorer.exe') then
            return
        end
    end

    local key = [[HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\properties]]
    if reg_read(key, '') then return end -- already exists
    -- show This PC on the Desktop
    reg_write([[HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel]], '{20D04FE0-3AEA-1069-A2D8-08002B30309D}', 0, winapi.REG_DWORD)
    -- handle Property menu to UI_SystemInfo
    reg_write(key, '', '@shell32.dll,-33555')
    reg_write(key, 'Position', 'Bottom')

    if handle_system_property == 'ui_systemInfo' then
      reg_write(key ..'\\command', '', app_path .. '\\WinXShell.exe wxs-ui:systeminfo')
    else
      reg_write(key ..'\\command', '', app_path .. '\\WinXShell.exe wxs-open:system')
    end
end

function regist_shortcut_ocf() -- handle shortcut's OpenContainingFolder menu
    if not is_x then return end
    if File.exists('X:\\Windows\\explorer.exe') then
      if File.exists('X:\\Windows\\System32\\ieframe.dll') then return end
    end

    local key = [[HKEY_CLASSES_ROOT\lnkfile\shell\OpenContainingFolderMenu_wxsStub]]
    if reg_read(key, '') then return end -- already exists
    reg_write([[HKEY_CLASSES_ROOT\lnkfile\shell\OpenContainingFolderMenu_wxsStub]], '', 'Open Containing Folder Menu Wrap')
    reg_write([[HKEY_CLASSES_ROOT\lnkfile\shell\OpenContainingFolderMenu_wxsStub]], '#MUIVerb', '@shell32.dll,-1033')
    reg_write([[HKEY_CLASSES_ROOT\lnkfile\shell\OpenContainingFolderMenu_wxsStub]], 'Extended', '')
    reg_write([[HKEY_CLASSES_ROOT\lnkfile\shell\OpenContainingFolderMenu_wxsStub]], 'Position', 'Bottom')
    local explorer_opt = ''
    -- if File.exists('X:\\Windows\\explorer.exe') then explorer_opt = '-explorer' end
    reg_write([[HKEY_CLASSES_ROOT\lnkfile\shell\OpenContainingFolderMenu_wxsStub\command]], '', app_path .. '\\WinXShell.exe '.. explorer_opt ..' -ocf \"%1\"')

    reg_write([[HKEY_CLASSES_ROOT\lnkfile\shellex\ContextMenuHandlers\OpenContainingFolderMenu]], '', 'disable-{37ea3a21-7493-4208-a011-7f9ea79ce9f5}')
    reg_write([[HKEY_CLASSES_ROOT\lnkfile\shellex\ContextMenuHandlers\OpenContainingFolderMenu_wxsStub]], '', '{B1FD8E8F-DC08-41BC-AF14-AAC87FE3073B}')
    reg_write([[HKEY_CLASSES_ROOT\lnkfile\shellex\PropertySheetHandlers\wxsStub]], '', '{B1FD8E8F-DC08-41BC-AF14-AAC87FE3073B}')

    reg_write([[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\{B1FD8E8F-DC08-41BC-AF14-AAC87FE3073B}]], '', 'wxsStub')
    local stub_dll = 'wxsStub.dll'
    if ARCH ~= 'x64' then stub_dll = 'wxsStub32.dll' end
    reg_write([[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\{B1FD8E8F-DC08-41BC-AF14-AAC87FE3073B}\InProcServer32]], '', app_path .. '\\' .. stub_dll)
    reg_write([[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\{B1FD8E8F-DC08-41BC-AF14-AAC87FE3073B}\InProcServer32]], 'ThreadingModel', 'Apartment')

    if ARCH == 'x64' then
      reg_write([[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Classes\CLSID\{B1FD8E8F-DC08-41BC-AF14-AAC87FE3073B}]], '', 'wxsStub')
      reg_write([[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Classes\CLSID\{B1FD8E8F-DC08-41BC-AF14-AAC87FE3073B}\InProcServer32]], '', app_path .. '\\wxsStub32.dll')
      reg_write([[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Classes\CLSID\{B1FD8E8F-DC08-41BC-AF14-AAC87FE3073B}\InProcServer32]], 'ThreadingModel', 'Apartment')
    end

end
