

local att_scale = 1.2
local res_scale = 1

text_elements = {
    -- Info
        area_text = {pos = "text_offset_area", scale = 0.9},
        exph_text = {pos = "text_offset_exph", scale = 1},

        mj_text = {pos = "text_offset_mj", scale = 0.8},
        sj_text = {pos = "text_offset_sj", scale = 0.8},

        mjl_text = {pos = "text_offset_mjl", scale = 1},
        sjl_text = {pos = "text_offset_sjl", scale = 0.8},

        exp_text = {pos = "text_offset_exp", scale = 1},
        tnl_text = {pos = "text_offset_tnl", scale = 1},

    -- Combat Stats
        att_text = {pos = "text_offset_att", scale = 1},
        def_text = {pos = "text_offset_def", scale = 1},

    -- Attributes
        str_text = {pos = "text_offset_str", scale = att_scale},
        dex_text = {pos = "text_offset_dex", scale = att_scale},
        vit_text = {pos = "text_offset_vit",  scale = att_scale},
        agi_text = {pos = "text_offset_agi",  scale = att_scale},
        int_text = {pos = "text_offset_int",  scale = att_scale},
        mnd_text = {pos = "text_offset_mnd",  scale = att_scale},
        chr_text = {pos = "text_offset_chr",  scale = att_scale},

    -- Resistances
        res_fir_text = {pos = "text_offset_res_fir", scale = res_scale},
        res_win_text = {pos = "text_offset_res_win", scale = res_scale},
        res_thu_text = {pos = "text_offset_res_thu", scale = res_scale},
        res_ice_text = {pos = "text_offset_res_ice", scale = res_scale},
        res_ear_text = {pos = "text_offset_res_ear", scale = res_scale},
        res_wat_text = {pos = "text_offset_res_wat", scale = res_scale},
        res_lig_text = {pos = "text_offset_res_lig", scale = res_scale},
        res_dar_text = {pos = "text_offset_res_dar", scale = res_scale},
    }

local ui = {}

-- setup images
function setup_image(image, path)
    if (image) then
        image:SetPath(path)
        image.visible = true
    end
end

-- setup text
local function get_text_settings(theme_options)
    local font_settings = {
        box_height = 0,
        box_width = 0,
        font_alignment = texts.Alignment.Right;
        font_color = tonumber(string.format('%02x%02x%02x%02x', 255, theme_options.font_color_red, theme_options.font_color_green, theme_options.font_color_blue), 16),
        font_family = texts:get_font_available(theme_options.font) and theme_options.font or 'Arial',
        font_flags = texts.FontFlags.Bold,
        font_height = theme_options.font_size,
        gradient_color = 0x00000000,
        gradient_style = 0,

        outline_color = tonumber(string.format('%02x%02x%02x%02x', 255, theme_options.font_stroke_color_red, theme_options.font_stroke_color_green, theme_options.font_stroke_color_blue), 16),
        outline_width = theme_options.font_stroke_width,
    
        position_x = 0,
        position_y = 0,
        text = '',
    };
    return font_settings
end

function update_text(textObject, theme_options)
    if (textObject == nil) then return end

    textObject:set_font_height(theme_options.font_size * settings.Theme.Scale)
    textObject:set_outline_width(theme_options.font_stroke_width)
    textObject:set_font_color(tonumber(string.format('%02x%02x%02x%02x', 255, theme_options.font_color_red, theme_options.font_color_green, theme_options.font_color_blue), 16))
    textObject:set_font_family(texts:get_font_available(theme_options.font) and theme_options.font or 'Arial')
    textObject:set_outline_color(tonumber(string.format('%02x%02x%02x%02x', 255, theme_options.font_stroke_color_red, theme_options.font_stroke_color_green, theme_options.font_stroke_color_blue), 16))
end

-- load the images and text
function ui:load(theme_options)
    ui.background = images:new()
    ui.foreground = images:new()

    setup_image(self.background, theme_options.background)
    setup_image(self.foreground, theme_options.foreground)

    local textSettings = get_text_settings(theme_options)
    for key, element in pairs(text_elements) do
        ui[key] = texts:create_object(textSettings, false)
        ui[key]:set_font_height(theme_options.font_size * settings.Theme.Scale * element.scale)
    end

    self:position(theme_options)
end

function ui:reload(theme_options)
    setup_image(self.background, theme_options.background)
    setup_image(self.foreground, theme_options.foreground)

    for key, element in pairs(text_elements) do
        update_text(self[key], theme_options)
        ui[key]:set_font_height(theme_options.font_size * settings.Theme.Scale * text_elements[key].scale)
    end

    ui:position(theme_options)

end

-- position the images and text
function ui:position(theme_options)
    local scale = settings.Theme.Scale
    local x = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0001', 1024) - (theme_options.size[1]) + theme_options.offset[1]
    local y = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0002', 768) - (theme_options.size[2]) + theme_options.offset[2]

    self.background.position_x = x
    self.background.position_y = y
    self.foreground.position_x = self.background.position_x
    self.foreground.position_y = self.background.position_y

    for key, element in pairs(text_elements) do
        self[key]:set_position_x((x + theme_options[element.pos][1]) * scale)
        self[key]:set_position_y((y + theme_options[element.pos][2]) * scale)
    end
end

-- hide ui
function ui:hide()
    if (self.background == nil) then return end
    self.background.visible = false
    self.foreground.visible = false

    for i = 1, settings.Tarus do
        self.animations[i].visible = false
    end

    for key, element in pairs(text_elements) do
        self[key]:set_visible(false)
    end
end

-- show ui
function ui:show()
    if (self.background == nil) then return; end;
    self.background.visible = true
    self.foreground.visible = true

    for i = 1, settings.Tarus do
        self.animations[i].visible = true
    end

    for key, element in pairs(text_elements) do
        self[key]:set_visible(true)
    end
end


-- Tarus
function ui:load_tarus(theme_options)
    ui.animations = {}
    for i = 1, settings.Tarus do
        ui.animations[i] = images:new()
        setup_image(ui.animations[i], theme_options.animation)
    end
    ui:position_tarus(theme_options)
end

function ui:reload_tarus(theme_options)
    for i = 1, settings.Tarus do
        setup_image(ui.animations[i], theme_options.animation)
    end
    ui:position_tarus(theme_options)
end

function ui:position_tarus(theme_options)
    local x = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0001', 1024) - (theme_options.size[1]) + theme_options.offset[1]
    local y = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0002', 768) - (theme_options.size[2]) + theme_options.offset[2]
    if settings.Tarus and settings.Tarus > 0 then
        for i = 1, settings.Tarus do
            self.animations[i].position_x = x + theme_options.size[1] - 15 - (i * 10)
            self.animations[i].position_y = self.background.position_y - 90
        end
        original_pos_x = self.animations[1].position_x
        original_pos_y = self.animations[1].position_y
    end
end

function ui:hide_tarus()
    for i = 1, settings.Tarus do
        self.animations[i].visible = false
    end
end

-- animate
function ui.animate(dummy, anim, i, speed)
    anim.visible = false
    if anim.position_x <= -100 then
        anim.position_x = original_pos_x
    else
        anim.position_x = anim.position_x - speed
    end
    setup_image(anim, addon.path .. "animation\\frame_" .. math.floor(i/3) .. "_100px.png")
    anim.visible = true
end

return ui
