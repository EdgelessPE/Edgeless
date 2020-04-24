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
