require 'winapi'

WM_SYSCOMMAND = 0x0112
SC_CLOSE      = 0xf060

function HideWindow(class, title)
  local win = winapi.find_window(class, title)
  if win ~= nil then win:show(winapi.SW_HIDE) end
end

function CloseWindow(class, title)
  local win = winapi.find_window(class, title)
  local hwnd = win:get_handle()
  app:print('CloseWindow(' .. title .. ', ' .. class .. string.format(", 0x%x", hwnd) .. ')')
  win:send_message(WM_SYSCOMMAND, SC_CLOSE, 0)
  return hwnd
end
