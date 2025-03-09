local theme = {}

theme.apply = function (settings)
    local options = {}
    theme_path = ('%sthemes\\%s\\'):fmt(addon.path, settings.Theme.Name)

    options.size = settings.Theme.Size
    options.scale = settings.Theme.Scale

    options.offset = settings.Theme.Offset

    options.animation = settings.animation or theme_path .. "animation\\frame_1.png"

    options.background = settings.background or theme_path .. "background.png"
    options.foreground = settings.foreground or theme_path .. "foreground.png"

    options.font = settings.Texts.Font
    options.font_size = settings.Texts.Size
    options.font_color_red = settings.Texts.Color.Red
    options.font_color_green = settings.Texts.Color.Green
    options.font_color_blue = settings.Texts.Color.Blue
    options.font_stroke_width = settings.Texts.Stroke.Width
    options.font_stroke_color_red = settings.Texts.Stroke.Red
    options.font_stroke_color_green = settings.Texts.Stroke.Green
    options.font_stroke_color_blue = settings.Texts.Stroke.Blue

-- Jobs / EXP / area
    options.text_offset_mj  = settings.Texts.Offset.MJ
    options.text_offset_mjl = settings.Texts.Offset.MJL
    options.text_offset_sj  = settings.Texts.Offset.SJ
    options.text_offset_sjl = settings.Texts.Offset.SJL
    options.text_offset_exp = settings.Texts.Offset.EXP
    options.text_offset_tnl = settings.Texts.Offset.TNL
    options.text_offset_area = settings.Texts.Offset.AREA
    options.text_offset_exph = settings.Texts.Offset.EXPH

-- Att / def
    options.text_offset_att = settings.Texts.Offset.ATT
    options.text_offset_def = settings.Texts.Offset.DEF

-- Attributes
    options.text_offset_str = settings.Texts.Offset.STR
    options.text_offset_dex = settings.Texts.Offset.DEX
    options.text_offset_vit = settings.Texts.Offset.VIT
    options.text_offset_agi = settings.Texts.Offset.AGI
    options.text_offset_int = settings.Texts.Offset.INT
    options.text_offset_mnd = settings.Texts.Offset.MND
    options.text_offset_chr = settings.Texts.Offset.CHR

-- Resistances
    options.text_offset_res_fir = settings.Texts.Offset.RES_FIR
    options.text_offset_res_win = settings.Texts.Offset.RES_WIN
    options.text_offset_res_thu = settings.Texts.Offset.RES_THU
    options.text_offset_res_ice = settings.Texts.Offset.RES_ICE
    options.text_offset_res_ear = settings.Texts.Offset.RES_EAR
    options.text_offset_res_wat = settings.Texts.Offset.RES_WAT
    options.text_offset_res_lig = settings.Texts.Offset.RES_LIG
    options.text_offset_res_dar = settings.Texts.Offset.RES_DAR

    options.screen_x = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0001', 1024) - 15 - (options.size[1])
    options.screen_y = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0002', 768) - 15 - (options.size[2])

    return options
end

return theme
