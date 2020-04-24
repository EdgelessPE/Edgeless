--local app = _G.app

function has_option(opt, cmd)
    if cmd == nil then cmd = app:info('cmdline') end
    return (string.find(cmd, opt) and true or false)
end

function get_option(opt, cmd)
    local val, val2
    if cmd == nil then cmd = app:info('cmdline') end
    val = string.match(cmd, opt .. '%s(.+)$')
    if val == nil then return nil end

    --  -xyz 'v a l u e' -abc
    val2 = string.match(val, '[\'](.+)[\']%s')
    if val2 ~= nil then return val2 end
    --  -xyz "v a l u e" -abc
    val2 = string.match(val, '[\"](.+)[\"]%s')
    if val2 ~= nil then return val2 end

    --  -xyz abc -abc
    val2 = string.match(val, '([^%s]+)%s')
    if val2 ~= nil then return val2 end

    return val
end

function parse_option(opt_str)
    local opt = {}
    opt.wait = false
    opt.showcmd = 1
    if opt_str == nil then return opt end
    opt_str = opt_str .. ' '
    if string.find(opt_str, '/nowait ') then opt.wait = false end
    if string.find(opt_str, '/wait ') then opt.wait = true end
    if string.find(opt_str, '/hide ') then
        opt.hide = 1
        opt.showcmd = 0
    end
    if string.find(opt_str, '/min ') then
        opt.min = 1
        opt.showcmd = 2
    end
    if string.find(opt_str, '/max ') then
        opt.max = 1
        opt.showcmd = 3
    end
    return opt
end


function exec(option, cmd)
    if cmd == nil then
        cmd = option
        option = nil
    end
    local opt = parse_option(option)
    return app:call('exec', cmd, opt.wait, opt.showcmd)
end


function link(lnk, target, param, icon, index, showcmd)
    local opt = parse_option(showcmd)
    return app:call('link', lnk, target, param, icon, index, opt.showcmd)
end


--[[
-- test
print(parse_option('/wait /hide').wait)
print(parse_option('/hide').wait)
print(parse_option('/wait /hide').showcmd)
print(parse_option('/wait').showcmd)
print(parse_option('/wait /min').showcmd)
print(parse_option('/wait /max').showcmd)
print(parse_option(nil).showcmd)
--]]
