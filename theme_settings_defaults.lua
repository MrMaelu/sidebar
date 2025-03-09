local theme_settings = T{}

theme_settings.Sidebar = true

theme_settings.Theme = {}
theme_settings.Theme.Name = 'Default'
theme_settings.Theme.Size = {175, 366}
theme_settings.Theme.Offset = {0, 0}

local base_x = theme_settings.Theme.Offset[1]
local base_y = theme_settings.Theme.Offset[2]

theme_settings.Texts = {}
theme_settings.Texts.Font = 'Rockwell'

theme_settings.Texts.Size = 16

theme_settings.Texts.Offset = {}

-- Att / def
theme_settings.Texts.Offset.ATT = {base_x + 114, base_y + 9}
theme_settings.Texts.Offset.DEF = {theme_settings.Texts.Offset.ATT[1],   theme_settings.Texts.Offset.ATT[2] + 17}

-- Attributes
local attributes_y_offset = 50
local attributes_x = base_x + 155
theme_settings.Texts.Offset.STR = {attributes_x, base_y + 25}
theme_settings.Texts.Offset.DEX = {attributes_x, theme_settings.Texts.Offset.STR[2] + (attributes_y_offset * 1)}
theme_settings.Texts.Offset.VIT = {attributes_x, theme_settings.Texts.Offset.STR[2] + (attributes_y_offset * 2)}
theme_settings.Texts.Offset.AGI = {attributes_x, theme_settings.Texts.Offset.STR[2] + (attributes_y_offset * 3)}
theme_settings.Texts.Offset.INT = {attributes_x, theme_settings.Texts.Offset.STR[2] + (attributes_y_offset * 4)}
theme_settings.Texts.Offset.MND = {attributes_x, theme_settings.Texts.Offset.STR[2] + (attributes_y_offset * 5)}
theme_settings.Texts.Offset.CHR = {attributes_x, theme_settings.Texts.Offset.STR[2] + (attributes_y_offset * 6)}

-- Resistances
local column_1_x = base_x + 58
theme_settings.Texts.Offset.RES_FIR = {column_1_x,  base_y + 73} --Fire
theme_settings.Texts.Offset.RES_THU = {column_1_x,  base_y + 91} --Lightning (thunder)
theme_settings.Texts.Offset.RES_EAR = {column_1_x,  base_y + 108} --Earth
theme_settings.Texts.Offset.RES_LIG = {column_1_x,  base_y + 125} --Light

local column_2_x = base_x + 114
theme_settings.Texts.Offset.RES_WIN = {column_2_x, base_y + 73} --Wind
theme_settings.Texts.Offset.RES_ICE = {column_2_x, base_y + 91} --Ice
theme_settings.Texts.Offset.RES_WAT = {column_2_x, base_y + 108} --Water
theme_settings.Texts.Offset.RES_DAR = {column_2_x, base_y + 125} --Dark

-- Others
theme_settings.Texts.Offset.MJ  = {base_x + 88, base_y + 159} --main job
theme_settings.Texts.Offset.SJ  = {base_x + 88, base_y + 176} --sub job

theme_settings.Texts.Offset.MJL = {theme_settings.Texts.Offset.MJ[1] + 26, theme_settings.Texts.Offset.MJ[2] - 2} --main job level
theme_settings.Texts.Offset.SJL = {theme_settings.Texts.Offset.SJ[1] + 26, theme_settings.Texts.Offset.SJ[2] - 2} --sub job level

theme_settings.Texts.Offset.EXP = {base_x + 114, base_y + 208} --exp
theme_settings.Texts.Offset.TNL = {base_x + 114, base_y + 225} --tnl

theme_settings.Texts.Offset.AREA = {base_x + 112, base_y + 274} --area

return theme_settings
