-- Built on the base framwork of the reworked xivbar by Tirem (SirEdeonX original)
-- Addon description
addon.name = 'Sidebar'
addon.author = 'MrMaelu'
addon.version = '0.0.1'

-- Libs
local settingsLib = require('settings')
images = require('libs/sprites')
texts  = require('libs/gdifonts/include')
exp_calc = require('exp_calculator')

local configMenu = require('config')

-- Slider debounce variables
local scaleUpdateTimer = 0
local scaleUpdateDelay = 200  -- Adjust delay (in ms)
local pendingScale = nil

local bLoggedIn = false
local playerIndex = AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0)
if playerIndex ~= 0 then
    local entity = AshitaCore:GetMemoryManager():GetEntity()
    local flags = entity:GetRenderFlags0(playerIndex)
    if (bit.band(flags, 0x200) == 0x200) and (bit.band(flags, 0x4000) == 0) then
        bLoggedIn = true
	end
end

local pGameMenu = ashita.memory.find('FFXiMain.dll', 0, "8B480C85C974??8B510885D274??3B05", 16, 0)
local pEventSystem = ashita.memory.find('FFXiMain.dll', 0, "A0????????84C0741AA1????????85C0741166A1????????663B05????????0F94C0C3", 0, 0)
local pInterfaceHidden = ashita.memory.find('FFXiMain.dll', 0, "8B4424046A016A0050B9????????E8????????F6D81BC040C3", 0, 0)

local function GetMenuName()
    local subPointer = ashita.memory.read_uint32(pGameMenu)
    local subValue = ashita.memory.read_uint32(subPointer)
    if (subValue == 0) then
        return ''
    end
    local menuHeader = ashita.memory.read_uint32(subValue + 4)
    local menuName = ashita.memory.read_string(menuHeader + 0x46, 16)
    return string.gsub(tostring(menuName), '\x00', '')
end

local function GetEventSystemActive()
    if (pEventSystem == 0) then
        return false
    end
    local ptr = ashita.memory.read_uint32(pEventSystem + 1)
    if (ptr == 0) then
        return false
    end

    return (ashita.memory.read_uint8(ptr) == 1)

end

local function GetInterfaceHidden()
    if (pEventSystem == 0) then
        return false
    end
    local ptr = ashita.memory.read_uint32(pInterfaceHidden + 10)
    if (ptr == 0) then
        return false
    end

    return (ashita.memory.read_uint8(ptr + 0xB4) == 1)
end

local function GetGameInterfaceHidden()

	if (GetEventSystemActive()) then
		return true
	end
	if (string.match(GetMenuName(), 'map')) then
		return true
	end
    if (GetInterfaceHidden()) then
        return true
    end
	if (bLoggedIn == false) then
		return true
	end
    return false
end

-- Load theme options according to settings
-- User settings
local defaults = require('defaults')
settings = settingsLib.load(defaults)
local theme = require('theme')
local sidebar = require('variables')
local original_package_path = package.path

local function update_theme_settings(settings, theme_settings)
    for key, value in pairs(theme_settings) do
        if type(value) == "table" then
            if type(settings[key]) == "table" then
                update_theme_settings(settings[key], value)
            else
                settings[key] = value
            end
        else
            settings[key] = value
        end
    end
end

function refresh_settings()
    package.path = addon.path .. 'themes\\' .. settings.Theme.Name .. '\\?.lua;' .. original_package_path
    settings_file = io.open(addon.path .. 'themes\\' .. settings.Theme.Name .. '\\theme_settings.lua', "r")

    if settings_file then
        settings_file:close()
        theme_settings = require('themes.' .. settings.Theme.Name .. '.theme_settings')
        update_theme_settings(settings, theme_settings)
    end
    gTheme_options = theme.apply(settings)
end

refresh_settings()

-- Addon Dependencies
local ui = require('ui')

-- initialize addon
local function re_initialize()
    if sidebar.initialized == true then
        gTheme_options = theme.apply(settings)
        ui:reload(gTheme_options)
    end
end

local function initialize()
    if sidebar.initialized == true then return end
    gTheme_options = theme.apply(settings)
    ui:load(gTheme_options)
    sidebar.initialized = true
end

function onSliderChange(newScale)
    pendingScale = newScale
    scaleUpdateTimer = ashita.time.clock().ms + scaleUpdateDelay
end

function OnSettingsUpdated()
    if sidebar.initialized == true then
        re_initialize()
    else
        initialize()
    end
end

local speed = {}
function OnTarusUpdated()
    ui:load_tarus(gTheme_options)
    for i = 1, settings.Tarus do
        speed[i] = math.random(settings.Taru_speed[1], settings.Taru_speed[2])
    end
end


function UpdateSettings(s)
    if (s ~= nil) then
        settings = s
    end
    refresh_settings()
    OnSettingsUpdated()
    settingsLib.save()
end

settingsLib.register('settings', 'settings_update', function (s)
    UpdateSettings(s)
end)

-- hide the addon
local function hide()
    ui:hide()
    sidebar.ready = false
end

-- show the addon
local function show()
    --OnSettingsUpdated()
    if sidebar.initialized == false then
        initialize()
    end
    ui:show()
    sidebar.ready = true
end

-- Bind Events
-- ON LOAD
ashita.events.register('load', 'load_cb', function ()
    if GetGameInterfaceHidden() == false then
        show()
    end
end)

local function CheckStats()
    local ashitaParty = AshitaCore:GetMemoryManager():GetParty()
    local ashitaPlayer = AshitaCore:GetMemoryManager():GetPlayer()

    if ashitaPlayer ~= nil then
        player = {
            area = AshitaCore:GetResourceManager():GetString("zones.names_abbr", ashitaParty:GetMemberZone(0)),
            mj   = AshitaCore:GetResourceManager():GetString("jobs.names_abbr",ashitaPlayer:GetMainJob()),
            mjl  = ashitaPlayer:GetMainJobLevel(),
            sj   = AshitaCore:GetResourceManager():GetString("jobs.names_abbr",ashitaPlayer:GetSubJob()),
            sjl  = ashitaPlayer:GetSubJobLevel(),
            exp  = ashitaPlayer:GetExpCurrent(),
            tnl  = ashitaPlayer:GetExpNeeded(),

            attack  = ashitaPlayer:GetAttack(),
            defense = ashitaPlayer:GetDefense(),

            str = ashitaPlayer:GetStat(0) + ashitaPlayer:GetStatModifier(0),
            dex = ashitaPlayer:GetStat(1) + ashitaPlayer:GetStatModifier(1),
            vit = ashitaPlayer:GetStat(2) + ashitaPlayer:GetStatModifier(2),
            agi = ashitaPlayer:GetStat(3) + ashitaPlayer:GetStatModifier(3),
            int = ashitaPlayer:GetStat(4) + ashitaPlayer:GetStatModifier(4),
            mnd = ashitaPlayer:GetStat(5) + ashitaPlayer:GetStatModifier(5),
            chr = ashitaPlayer:GetStat(6) + ashitaPlayer:GetStatModifier(6),

            res_fir = ashitaPlayer:GetResist(0),
            res_ice = ashitaPlayer:GetResist(1),
            res_win = ashitaPlayer:GetResist(2),
            res_ear = ashitaPlayer:GetResist(3),
            res_thu = ashitaPlayer:GetResist(4),
            res_wat = ashitaPlayer:GetResist(5),
            res_lig = ashitaPlayer:GetResist(6),
            res_dar = ashitaPlayer:GetResist(7)
            }
            xpm_1m, xph_1m, xpm_10m, xph_10m = update_exp_history(player.exp, player.tnl, player.mjl)
    end
end

previous_stats = {
    exph = 0,
    area = 0,
    mj   = 0,
    mjl  = 0,
    sj   = 0,
    sjl  = 0,
    exp  = 0,
    tnl  = 0,
    att  = 0,
    def  = 0,
    str  = 0,
    dex  = 0,
    vit  = 0,
    agi  = 0,
    int  = 0,
    mnd  = 0,
    chr  = 0,

    res_fir = 0,
    res_win = 0,
    res_thu = 0,
    res_lig = 0,
    res_ice = 0,
    res_ear = 0,
    res_wat = 0,
    res_dar = 0
}


local frame_no = 0

ashita.events.register('d3d_present', 'present_cb', function ()
    if sidebar.hide == false and GetGameInterfaceHidden() == true then
        sidebar.hide = true
        hide()
    elseif sidebar.hide == true and GetGameInterfaceHidden() == false then
        sidebar.hide = false
        show()
    end

    if settings.Tarus > 0 then
        frame_no = frame_no + 1
        if frame_no >= 120 then
            frame_no = 0
        end
        for i = 1, settings.Tarus do
            if ui.animations[i].position_x < 0 then
                speed[i] = math.random(settings.Taru_speed[1], settings.Taru_speed[2])
            end
            ui:animate(ui.animations[i], frame_no, speed[i])
        end
    end

    CheckStats()

    if sidebar.ready == false then return end

    local p_stats = {
        exph = xph_10m,
        area = player.area,
        mj   = player.mj,
        mjl  = player.mjl,
        sj   = player.sj,
        sjl  = player.sjl,
        exp  = player.exp,
        tnl  = player.tnl - player.exp,
        att  = player.attack,
        def  = player.defense,
        str  = player.str,
        dex  = player.dex,
        vit  = player.vit,
        agi  = player.agi,
        int  = player.int,
        mnd  = player.mnd,
        chr  = player.chr,

        res_fir = player.res_fir,
        res_win = player.res_win,
        res_thu = player.res_thu,
        res_lig = player.res_lig,
        res_ice = player.res_ice,
        res_ear = player.res_ear,
        res_wat = player.res_wat,
        res_dar = player.res_dar
    }

    for stat, new_value in pairs(p_stats) do
        if new_value ~= nil and previous_stats[stat] ~= new_value then
            ui[stat .. "_text"]:set_text(tostring(new_value))
            previous_stats[stat] = new_value
        end
    end

    if pendingScale and ashita.time.clock().ms >= scaleUpdateTimer then
        settings.Theme.Scale = pendingScale
        OnSettingsUpdated()
        pendingScale = nil
    end
end)

ashita.events.register('packet_in', '__sidebar_packet_in_cb', function (e)
    -- Track our logged in status
    if (e.id == 0x00A) then
        bLoggedIn = true
	elseif (e.id == 0x00B) then
        bLoggedIn = false
    end
end)

ashita.events.register('unload', 'load_cb', function ()
    texts:destroy_interface()
end)

