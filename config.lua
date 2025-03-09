local ui = require('ui');

require('common')
local imgui = require('imgui')
local chat = require('chat');

local showConfig = { false };
local configInitialized = false;

-- find all our layouts and strip _alliance and file extensions
-- return a list of all sub directories
---@return table theme_paths
local function get_theme_paths()
    local path = ('%s\\themes'):fmt(addon.path);
    return ashita.fs.get_directory(path);
end

local function DrawConfigMenu()
	if (showConfig[1]) then
		if (configInitialized == false) then
			imgui.SetNextWindowPos({
				(gTheme_options.screen_x + gTheme_options.offset[1]) * settings.Theme.Scale,
				(gTheme_options.screen_y + gTheme_options.offset[2]) * settings.Theme.Scale
			});
			imgui.SetNextWindowSize({1,1});
			configInitialized = true;
		end

		imgui.PushStyleColor(ImGuiCol_WindowBg, {1,1,0,1});
		imgui.PushStyleVar(ImGuiStyleVar_WindowBorderSize, 3);
		imgui.Begin(("sidebar: move"), showConfig, bit.bor(ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoDecoration))
		local posX, posY = imgui.GetWindowPos();
		posX = (posX / settings.Theme.Scale) - gTheme_options.screen_x;
		posY = (posY / settings.Theme.Scale) - gTheme_options.screen_y;
		if (settings.Theme.Offset[1] ~= posX or settings.Theme.Offset[2] ~= posY) then
			settings.Theme.Offset[1] = posX;
			settings.Theme.Offset[2] = posY;
			OnSettingsUpdated();
		end
		imgui.End();
		imgui.PopStyleColor(1);
		imgui.PopStyleVar(1);

		if(imgui.Begin(("sidebar config"), showConfig, ImGuiWindowFlags_AlwaysAutoResize)) then

			-- Use tabs for this config menu
			imgui.BeginTabBar('sidebar Settings Tabs');

			-- General
			if imgui.BeginTabItem('General') then

				-- theme
				local theme_paths = get_theme_paths();
				if (imgui.BeginCombo('Theme', settings.Theme.Name)) then
					for i = 1,#theme_paths,1 do
						local is_selected = i == settings.Theme.Name;

						if (imgui.Selectable(theme_paths[i], is_selected) and theme_paths[i] ~= settings.Theme.Name) then
							settings.Theme.Name = theme_paths[i];
							OnSettingsUpdated();
						end

						if (is_selected) then
							imgui.SetItemDefaultFocus();
						end
					end
					imgui.EndCombo();
				end
				imgui.ShowHelp('The theme to use for bar images [sidebar/themes]');

				imgui.Separator();

				if scaleFactor == nil then
					scaleFactor = { settings.Theme.Scale * 100 };
				end
				if (imgui.SliderInt('Scale', scaleFactor, 50, 150)) then
					onSliderChange(scaleFactor[1] / 100);
				end

				imgui.Separator();

				-- Stroke Settings
				local fontSize = { settings.Texts.Size };
				if (imgui.SliderInt('Font size', fontSize, 8, 32)) then
					settings.Texts.Size = fontSize[1];
					OnSettingsUpdated();
				end
				-- Stroke Settings
				local strokeWidth = { settings.Texts.Stroke.Width };
				if (imgui.SliderInt('Stroke Width', strokeWidth, 0, 8)) then
					settings.Texts.Stroke.Width = strokeWidth[1];
					OnSettingsUpdated();
				end

				imgui.Separator();

				local fontRed = { settings.Texts.Color.Red };
				if (imgui.SliderInt('Font Red', fontRed, 0, 255)) then
					settings.Texts.Color.Red = fontRed[1];
					OnSettingsUpdated();
				end
				
				local fontGreen = { settings.Texts.Color.Green };
				if (imgui.SliderInt('Font Green', fontGreen, 0, 255)) then
					settings.Texts.Color.Green = fontGreen[1];
					OnSettingsUpdated();
				end
				
				local fontBlue = { settings.Texts.Color.Blue };
				if (imgui.SliderInt('Font Blue', fontBlue, 0, 255)) then
					settings.Texts.Color.Blue = fontBlue[1];
					OnSettingsUpdated();
				end

				imgui.Separator();

				local strokeRed = { settings.Texts.Stroke.Red };
				if (imgui.SliderInt('stroke Red', strokeRed, 0, 255)) then
					settings.Texts.Stroke.Red = strokeRed[1];
					OnSettingsUpdated();
				end
				
				local strokeGreen = { settings.Texts.Stroke.Green };
				if (imgui.SliderInt('stroke Green', strokeGreen, 0, 255)) then
					settings.Texts.Stroke.Green = strokeGreen[1];
					OnSettingsUpdated();
				end
				
				local strokeBlue = { settings.Texts.Stroke.Blue };
				if (imgui.SliderInt('stroke Blue', strokeBlue, 0, 255)) then
					settings.Texts.Stroke.Blue = strokeBlue[1];
					OnSettingsUpdated();
				end

				imgui.EndTabItem();
			end
			-- Tarus?
			if imgui.BeginTabItem('Tarus?') then
				local tarus = { settings.Tarus };
				if (imgui.SliderInt('Tarus??', tarus, 0, 20)) then
					ui:hide_tarus();
					settings.Tarus = tarus[1];
					OnTarusUpdated();
				end

				local speed = { settings.Taru_speed[2] };
				if settings.Tarus > 0 then
					if (imgui.SliderInt('Speed', speed, 5, 20)) then
						settings.Taru_speed[2] = speed[1];
						OnSettingsUpdated();
					end
				end
				imgui.EndTabItem();
			end

			imgui.EndTabBar();
			imgui.End();
		end
		if (showConfig[1] == false) then
			UpdateSettings();
		end
	end
end

ashita.events.register('d3d_present', '__config_present_cb', function ()
    if (showConfig[1]) then
        DrawConfigMenu();
    end
end);

ashita.events.register('command', '__config_command_cb', function (e)
	-- Parse the command arguments
	local command_args = e.command:lower():args()
    if table.contains({'/sidebar', '/sbar'}, command_args[1]) then
		-- Toggle the config menu
		configInitialized = false;
		showConfig[1] = not showConfig[1];
		if (not showConfig[1]) then
			UpdateSettings();
		else
			print(chat.header(addon.name)..'Config opened (/sbar or /sidebar)')
			print(chat.header(addon.name)..'Retype the command to save and close')
			print(chat.header(addon.name)..'To move bar click and drag the yellow box')
		end
		e.blocked = true;
	end
end);
