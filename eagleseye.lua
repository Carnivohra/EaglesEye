eagleseye = {
    version = "0.1.1",
    supports = { "1.0.1.4" }
}

function eagleseye:start()
    print("EaglesEye is checking for updates ...")
    self:update_check()

    if not self:supported(_CS2DVERSION) then
        print("Cannot start EaglesEye. This EaglesEye version does not support CS2D version '" .. _CS2DVERSION .. "'.\n" ..
        "Please update your EaglesEye or CS2D version.")
        return
    end

    self:parse_hooks()
    --self:save_demo()
end

function eagleseye:update_check()
    local latest_cs2d_version = self:latest_cs2d_version()

    if latest_cs2d_version == nil then 
        print("Cannot check for the latest CS2D version. Is CS2D.com online?\n" ..
        "Please report this issue if CS2D.com is still online.\n" .. 
        "My Discord: carnivohra")
    else
        if _CS2DVERSION ~= latest_cs2d_version then
            print("New CS2D update found. Version '" .. latest_cs2d_version .. "' is live now.")
            -- cs2d update menu
        end
    end

    local latest_eagleseye_version = self:latest_eagleseye_version()

    if latest_eagleseye_version == nil then
        print("Cannot check for the latest EaglesEye version. Is the repository online?\n" ..
        "Please report this issue if github.com/Carnivohra/EaglesEye is still online.\n" .. 
        "My Discord: carnivohra")
    else 
        if eagleseye.version ~= latest_eagleseye_version then
            print("New EaglesEye update found: Version '" .. latest_eagleseye_version .. "' is live now.")
            -- it is highly recommended to use the latest eagleseye version for more security and features.
            -- eagleseye update menu
        end
    end
end

function eagleseye:latest_cs2d_version()
    local lines = self:download("https://cs2d.com/download")

    if lines == nil then return nil end

    local needed_start = "<h2>Latest Version: "
    local version = nil

    for i = 1, #lines do
        if self:starts_with(lines[i], needed_start) then
            version = string.gsub(lines[i], needed_start, "", 1)
            version = string.gsub(version, "</h2>", "", 1)
        end
    end 

    return version
end

function eagleseye:download(url)
    local file_name = ".cache"
    self:download_file(url, file_name)

    if not self:file_exist(file_name) then return nil end

    local content = {}

    for line in io.lines(file_name) do
        content[#content + 1] = line
    end 

    self:delete_file(file_name)
    return content
end

function eagleseye:download_file(url, file_name)
    os.execute("CURL -O " .. file_name .. " " .. url)
end

function eagleseye:file_exist(file_name)
    local file = io.open(file_name, "r")

    if file == nil then return false end

    file:close()
    return true 
end

function eagleseye:starts_with(chars, starts_with)
    local index = string.find(chars, starts_with)
    return index == 1
end

function eagleseye:delete_file(file_name)
    os.execute("DEL " .. file_name)
end

function eagleseye:latest_eagleseye_version()
    local lines = self:download("https://raw.githubusercontent.com/carnivohra/eagleseye/refs/heads/main/data/version")

    if lines == nil then return nil end
    if lines[1] == nil then return nil end

    return lines[1]
end

function eagleseye:supported(version)
    for i = 1, #self.supports do
        if self.supports[i] == version then return true end
    end
    return false
end

eagleseye.hooks = {
    ["always"] = { },
    ["assist"] = { "assist", "victim", "killer" },
    ["attack"] = { "id" },
    ["attack2"] = { "id", "mode" },
    ["bombdefuse"] = { "id" },
    ["bombexplode"] = { "id", "x", "y" },
    ["bombplant"] = { "id", "x", "y" },
    ["break"] = { "x", "y", "player" },
    ["build"] = { "id", "type", "x", "y", "mode", "objectid" },
    ["buildattempt"] = { "id", "type", "x", "y", "mode" },
    ["buy"] = { "id", "weapon" },
    ["clientdata"] = { "id", "mode", "data1", "data2" },
    ["clientsetting"] = { "id", "setting", "value1", "value2" },
    ["collect"] = { "id", "iid", "type", "ain", "a", "mode" },
    ["connect"] = { "id" },
    ["connect_attempt"] = { "name", "ip", "port", "usgnID", "usgnName", "steamID", "steamName" },
    ["connect_initplayer"] = { "id" },
    ["die"] = { "victim", "killer", "weapon", "x", "y", "killerobject" },
    ["disconnect"] = { "id", "reason" },
    ["dominate"] = { "id", "team", "x", "y" },
    ["drop"] = { "id", "iid", "ammoin", "ammo", "mode", "xpos", "ypos" },
    ["endround"] = { "mode", "delay" },
    ["flagcapture"] = { "id", "team", "x", "y" },
    ["flagtake"] = { "id", "team", "x", "y" },
    ["flashlight"] = { "id", "state" },
    ["hit"] = { "id", "source", "weapon", "hpdmg", "apdmg", "rawdmg", "object" },
    ["hitzone"] = { "image_id", "player_id", "object_id", "weapon", "impact_x", "impact_y", "damage"},
    ["hostagedamage"] = { "id", "hostageid", "damage" },
    ["hostagekill"] = { "id", "hostageid", "damage" },
    ["hostagerescue"] = { "id", "x", "y" },
    ["hostageuse"] = { "id", "hostageid", "mode" },
    ["httpdata"] = { "requestid", "state", "data" },
    ["itemfadeout"] = { "iid", "type", "xpos", "ypos" },
    ["join"] = { "id" },
    ["key"] = { "id", "key", "state" },
    ["kill"] = { "killer", "victim", "weapon", "x", "y", "killerobject", "assistant" },
    ["leave"] = { "id", "reason" },
    ["log"] = { "text" },
    ["mapchange"] = { "newmap" },
    ["menu"] = { "id", "title", "button" },
    ["minute"] = { },
    ["move"] = { "id", "x", "y", "walk" },
    ["movetile"] = { "id", "x", "y" },
    ["ms100"] = { },
    ["name"] = { "id", "oldname", "newname", "forced" },
    ["objectdamage"] = { "id", "damage", "player" },
    ["objectkill"] = { "id", "player" },
    ["objectupgrade"] = { "id", "player", "progress", "total" },
    ["parse"] = { "text" },
    ["projectile"] = { "id", "weapon", "x", "y", "projectileid" },
    ["projectile_impact"] = { "id", "weapon", "x", "y", "mode", "projectileid" },
    ["radio"] = { "id", "message" },
    ["rcon"] = { "cmds", "id", "ip", "port" },
    ["reload"] = { "id", "mode" },
    ["say"] = { "id", "message" },
    ["sayteam"] = { "id", "message" },
    ["sayteamutf8"] = { "id", "message" },
    ["sayutf8"] = { "id", "message" },
    ["second"] = { },
    ["select"] = { "id", "type", "mode" },
    ["serveraction"] = { "id", "action" },
    ["shieldhit"] = { "id", "source", "weapon", "attackdirection", "attacker_object_id", "damage" },
    ["shutdown"] = { },
    ["spawn"] = { "id" },
    ["specswitch"] = { "id", "target" },
    ["spray"] = { "id" },
    ["startround"] = { "mode" },
    ["startround_prespawn"] = { "mode" },
    ["suicide"] = { "id" },
    ["team"] = { "id", "team", "look" },
    ["trigger"] = { "trigger", "source" },
    ["triggerentity"] = { "x", "y" },
    ["turretscan"] = { "turret_object_id", "turret_team", "turret_x_position", "turret_y_position" },
    ["use"] = { "id", "event", "data", "x", "y" },
    ["usebutton"] = { "id", "x", "y" },
    ["vipescape"] = { "id", "x", "y" },
    ["voice"] = { "id" },
    ["vote"] = { "id", "mode", "param" },
    ["walkover"] = { "id", "iid", "type", "ain", "a", "mode" },
}

function eagleseye:parse_hooks()
    for name, hook in pairs(self.hooks) do
        local parameter_string = ""
    
        for i, parameter in ipairs(hook) do
            if i ~= 1 then parameter_string = parameter_string .. ", " end
            parameter_string = parameter_string .. parameter
        end

        local values_string = ""

        for i, parameter in ipairs(hook) do
            if i ~= 1 then values_string = values_string .. ", " end
            values_string = values_string .. parameter .. " = " .. parameter
        end

        local line = 'function eagleseye.on_' .. name .. '(' .. parameter_string .. ') \n'
        line = line .. '   eagleseye:action(\'hook\', \'' .. name .. '\', { ' .. values_string .. ' }) \n'
        line = line .. 'end \n'
        line = line .. 'addhook(\'' .. name .. '\', \'eagleseye.on_' .. name .. '\')'            
        parse('lua "' .. line .. '"')
    end
end

eagleseye.ticks = {}
eagleseye.first_tick_time = nil

function eagleseye:action(source, type, values)
    if source == "hook" and type == "always" then self:tick() end
    if #self.ticks == 0 then self:tick() end
    
    local tick = self.ticks[#self.ticks]
    local action = { source = source, type = type, values = values }
    tick.actions[#tick.actions + 1] = action
end

function eagleseye:tick()
    local tick = { time = os.clock(), actions = {} }
    self.ticks[#self.ticks + 1] = tick

    if self.first_tick_time == nil then self.first_tick_time = os.date() end
end

function eagleseye:save_demo()
    self:create_dir("demos")

    local demo = self:encode(self.first_tick_time)
    self.first_tick_time = nil

    for i = 1, #self.ticks do
    end
end

function eagleseye:encode(field)
    return #field .. field
end

function eagleseye:create_dir(dir)
    os.execute("MKDIR " .. dir)
end

eagleseye:start()