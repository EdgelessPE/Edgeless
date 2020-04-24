ProductPolicy = {}

function ProductPolicy:Load(key, item)
  app:call('ProductPolicy::Load', key, item)
end

function ProductPolicy:Get(name)
  app:call('ProductPolicy::Get', name)
end

function ProductPolicy:Set(name, value)
  app:call('ProductPolicy::Set', name, value)
end

function ProductPolicy:Save(name, value)
  if name ~= nil then
    app:call('ProductPolicy::Set', name, value)
  end
  app:call('ProductPolicy::Save')
end
