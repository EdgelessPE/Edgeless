i18n = {}

i18n.loaded = false

function i18n.load(lang)
  if lang == nil then lang = app:info('locale') end
  if File.exists('locales\\' .. lang .. '.lua') then
    require('locales.' .. lang)
  end
  i18n.loaded = true
end

function i18n.t(key)
  if not i18n.loaded then i18n.load() end
  if i18n_str == nil then return key end
  return i18n_str[key] or key
end

