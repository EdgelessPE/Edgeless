File = {}
Folder = {}

function File.exists(path)
  return app:call('file::exists', path) == 1
end

function File.delete(path)
  local f = app:call('envstr', path)
  return os.remove(f)
end

File.remove = File.delete

function Folder.exists(path)
  return app:call('folder::exists', path) == 1
end
