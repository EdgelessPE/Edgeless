function WaitForSession(user)
    app:call('WaitForSession', user)
end

function SwitchSession(user)
    app:call('SwitchSession', user)
end

function CloseShellWindow()
  Taskbar:WaitForReady()
  app:call('closeshell')
  app:call('sleep', 500)
end

function ShellDaemon(wait, cmd)
  while (1) do
    app:print('ShellDaemon')
    if wait == true then
      Taskbar:WaitForReady()
      app:print('WaitForReady')
      app:call('sleep', 5000)
    end
    wait = false
    if Taskbar:IsReady(5) == false then
      exec('/wait', cmd)
    end
    app:call('sleep', 5000)
  end
end

function shel(cmd)
  local wait_opt = 'false'
  if os.getenv('USERNAME') ~= 'SYSTEM' then wait_opt = 'true' end
  exec('WinXShell.exe -luacode "ShellDaemon(' .. wait_opt .. ',[[' .. cmd .. ']])"')
end
