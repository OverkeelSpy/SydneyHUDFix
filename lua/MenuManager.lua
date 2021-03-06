local is_dlc_latest_locked_original = MenuCallbackHandler.is_dlc_latest_locked
function MenuCallbackHandler:is_dlc_latest_locked(...)
    return SydneyHUD:GetOption("remove_ads") and false or is_dlc_latest_locked_original(self, ...)
end

local pos =
{
    ["sydneyhud_hud_tweaks_waypoint"] = 0.125,
    ["sydneyhud_hud_tweaks_interact"] = 0.335,
    ["sydneyhud_hud_lists_options_enemy_color"] = 0.125,
    ["sydneyhud_hud_lists_options_civilian_color"] = 0.125,
    ["sydneyhud_gadget_options_sniper"] = 0.175
}

local col =
{
    ["sydneyhud_hud_tweaks_waypoint"] = "waypoint_color",
    ["sydneyhud_hud_tweaks_interact"] = "interaction_color",
    ["sydneyhud_hud_lists_options_enemy_color"] = "enemy_color",
    ["sydneyhud_hud_lists_options_civilian_color"] = "civilian_color",
    ["sydneyhud_gadget_options_sniper"] = "laser_color",
    ["sydneyhud_gadget_options_turret"] = "laser_color"
}

local col_ext =
{
    ["sydneyhud_gadget_options_sniper"] = "_snipers",
    ["sydneyhud_gadget_options_turret"] = "_turret"
}

--[[
    Load our localization keys for our menu, and menu items.
]]
Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_sydneyhud", function(loc)
    for _, filename in pairs(file.GetFiles(SydneyHUD._path .. "lang/")) do
        local str = filename:match('^(.*).json$')
        -- if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
        local langid = SydneyHUD:GetOption("language")
        -- log(SydneyHUD.dev..langid)
        if str == SydneyHUD._language[langid] then
            loc:load_localization_file(SydneyHUD._path .. "lang/" .. filename)
            log(SydneyHUD.info.."language: "..filename)
            break
        end
    end
    loc:load_localization_file(SydneyHUD._path .. "lang/english.json", false)
    loc:load_localization_file(SydneyHUD._path .. "lang/languages.json")
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_sydneyhud", function(menu_manager, nodes)
    if nodes.main then
        MenuHelper:AddMenuItem(nodes.main, "crimenet_contract_special", "menu_cn_premium_buy", "menu_cn_premium_buy_desc", "crimenet", "after")
    end
end)

--[[
    Setup our menu callbacks and build the menu from our json file.
]]
Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_sydneyhud", function(menu_manager)
    --[[
        Setup our callbacks as defined in our item callback keys, and perform our logic on the data retrieved.
    ]]
    MenuCallbackHandler.SydneyHUDChangedFocus = function(node, focus)
        if focus then
            SydneyHUD:CreatePanel()
            SydneyHUD:CreateBitmaps()
            SydneyHUD:CreateTexts()
        end
    end

    MenuCallbackHandler.SydneyHUDPanelFocus = function(node, focus)
        SydneyHUD:SetVisibility(focus)
        if focus then
            SydneyHUD:SetTop(pos[node:parameters()["menu_id"]] or 0.10)
            SydneyHUD:SetBoxColor(col[node:parameters()["menu_id"]] or nil, col_ext[node:parameters()["menu_id"]] or nil) -- Nil colors are always resolved as White in SydneyHUD
        end
        if node:parameters()["menu_id"] == "sydneyhud_gadget_options_turret" then
            SydneyHUD:SetVisibility(focus, SydneyHUD.color_box_2)
            SydneyHUD:SetVisibility(focus, SydneyHUD.color_box_3)
            SydneyHUD:SetVisibility(focus, SydneyHUD.text_box)
            SydneyHUD:SetVisibility(focus, SydneyHUD.text_box_2)
            SydneyHUD:SetVisibility(focus, SydneyHUD.text_box_3)
            if focus then
                SydneyHUD:SetBoxColor("laser_color", "_turretr", SydneyHUD.color_box_2)
                SydneyHUD:SetBoxColor("laser_color", "_turretm", SydneyHUD.color_box_3)
            end
        end
    end

    MenuCallbackHandler.SydneyHUD_HUDTweaks_ChangedFocus = function(node, focus)
        if BAI then
            node:item("sydneyhud_hud_tweaks_assault"):set_enabled(false)
            node:item("sydneyhud_hud_tweaks_assault"):set_parameter("help_id", "sydneyhud_show_assault_states_disabled_desc")
        end
    end

    -- Screen skipping
    MenuCallbackHandler.callback_skip_black_screen = function(self, item)
        SydneyHUD._data.skip_black_screen = item:value() == "on"
    end
    MenuCallbackHandler.callback_skip_stat_screen = function(self, item)
        SydneyHUD._data.skip_stat_screen = item:value() == "on"
    end
    MenuCallbackHandler.callback_stat_screen_skip = function(self, item)
        SydneyHUD._data.stat_screen_skip = item:value()
    end
    MenuCallbackHandler.callback_skip_card_picking = function(self, item)
        SydneyHUD._data.skip_card_picking = item:value() == "on"
    end
    MenuCallbackHandler.callback_skip_loot_screen = function(self, item)
        SydneyHUD._data.skip_loot_screen = item:value() == "on"
    end
    MenuCallbackHandler.callback_loot_screen_skip = function(self, item)
        SydneyHUD._data.loot_screen_skip = item:value()
    end

    -- HUD panel
    MenuCallbackHandler.callback_counter_font_size = function(self, item)
        SydneyHUD._data.counter_font_size = item:value()
    end

    MenuCallbackHandler.callback_improved_ammo_count = function(self, item)
        SydneyHUD._data.improved_ammo_count = item:value() == "on"
    end

    MenuCallbackHandler.callback_right_list_scale = function(self, item)
        SydneyHUD._data.right_list_scale = item:value()
    end
    MenuCallbackHandler.callback_left_list_scale = function(self, item)
        SydneyHUD._data.left_list_scale = item:value()
    end
    MenuCallbackHandler.callback_buff_list_scale = function(self, item)
        SydneyHUD._data.buff_list_scale = item:value()
    end

    -- HUD Lists (Timers)
    MenuCallbackHandler.callback_show_timers = function(self, item)
        SydneyHUD._data.show_timers = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_equipment = function(self, item)
        SydneyHUD._data.show_equipment = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_sentries = function(self, item)
        SydneyHUD._data.show_sentries = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_ecms = function(self, item)
        SydneyHUD._data.show_ecms = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_ecm_retrigger = function(self, item)
        SydneyHUD._data.show_ecm_retrigger = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_minions = function(self, item)
        SydneyHUD._data.show_minions = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_pagers = function(self, item)
        SydneyHUD._data.show_pagers = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_tape_loop = function(self, item)
        SydneyHUD._data.show_tape_loop = item:value() == "on"
    end

    -- HUD Lists (Counters)
    MenuCallbackHandler.callback_show_enemies = function(self, item)
        SydneyHUD._data.show_enemies = item:value() == "on"
    end
    MenuCallbackHandler.callback_aggregate_enemies = function(self, item)
        SydneyHUD._data.aggregate_enemies = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_turrets = function(self, item)
        SydneyHUD._data.show_turrets = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_civilians = function(self, item)
        SydneyHUD._data.show_civilians = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_hostages = function(self, item)
        SydneyHUD._data.show_hostages = item:value() == "on"
    end
    MenuCallbackHandler.callback_aggregate_hostages = function(self, item)
        SydneyHUD._data.aggregate_hostages = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_minion_count = function(self, item)
        SydneyHUD._data.show_minion_count = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_pager_count = function(self, item)
        SydneyHUD._data.show_pager_count = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_camera_count = function(self, item)
        SydneyHUD._data.show_camera_count = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_loot = function(self, item)
        SydneyHUD._data.show_loot = item:value() == "on"
    end
    MenuCallbackHandler.callback_aggregate_loot = function(self, item)
        SydneyHUD._data.aggregate_loot = item:value() == "on"
    end
    MenuCallbackHandler.callback_separate_bagged_loot = function(self, item)
        SydneyHUD._data.separate_bagged_loot = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_gage_packages = function(self, item)
        SydneyHUD._data.show_gage_packages = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_special_pickups = function(self, item)
        SydneyHUD._data.show_special_pickups = item:value() == "on"
    end

    -- HUD Lists (Buffs)
    MenuCallbackHandler.callback_show_buffs = function(self, item)
        SydneyHUD._data.show_buffs = item:value() == "on"
    end

    MenuCallbackHandler.callback_enemy_color_r = function(self, item)
        SydneyHUD._data.enemy_color_r = item:value()
        SydneyHUD:SetBoxColor("enemy_color")
    end
    MenuCallbackHandler.callback_enemy_color_g = function(self, item)
        SydneyHUD._data.enemy_color_g = item:value()
        SydneyHUD:SetBoxColor("enemy_color")
    end
    MenuCallbackHandler.callback_enemy_color_b = function(self, item)
        SydneyHUD._data.enemy_color_b = item:value()
        SydneyHUD:SetBoxColor("enemy_color")
    end
    MenuCallbackHandler.callback_civilian_color_r = function(self, item)
        SydneyHUD._data.civilian_color_r = item:value()
        SydneyHUD:SetBoxColor("civilian_color")
    end
    MenuCallbackHandler.callback_civilian_color_g = function(self, item)
        SydneyHUD._data.civilian_color_g = item:value()
        SydneyHUD:SetBoxColor("civilian_color")
    end
    MenuCallbackHandler.callback_civilian_color_b = function(self, item)
        SydneyHUD._data.civilian_color_b = item:value()
        SydneyHUD:SetBoxColor("civilian_color")
    end

    -- Kill counter
    MenuCallbackHandler.callback_enable_kill_counter = function(self, item)
        SydneyHUD._data.enable_kill_counter = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_special_kills = function(self, item)
        SydneyHUD._data.show_special_kills = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_headshot_kills = function(self, item)
        SydneyHUD._data.show_headshot_kills = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_ai_kills = function(self, item)
        SydneyHUD._data.show_ai_kills = item:value() == "on"
    end

    -- HPS Meter
    MenuCallbackHandler.callback_enable_hps_meter = function(self, item)
        SydneyHUD._data.enable_hps_meter = item:value() == "on"
    end
    MenuCallbackHandler.callback_hps_refresh_rate = function(self, item)
        SydneyHUD._data.hps_refresh_rate = item:value()
    end
    MenuCallbackHandler.callback_show_hps_current = function(self, item)
        SydneyHUD._data.show_hps_current = item:value() == "on"
    end
    MenuCallbackHandler.callback_current_hps_timeout = function(self, item)
        SydneyHUD._data.current_hps_timeout = item:value()
    end
    MenuCallbackHandler.callback_show_hps_total = function(self, item)
        SydneyHUD._data.show_hps_total = item:value() == "on"
    end

    -- Flashlight extender
    MenuCallbackHandler.callback_enable_flashlight_extender = function(self, item)
        SydneyHUD._data.enable_flashlight_extender = item:value() == "on"
    end
    MenuCallbackHandler.callback_flashlight_range = function(self, item)
        SydneyHUD._data.flashlight_range = item:value()
    end
    MenuCallbackHandler.callback_flashlight_angle = function(self, item)
        SydneyHUD._data.flashlight_angle = item:value()
    end

    -- Laser options
    MenuCallbackHandler.callback_auto_laser = function(self, item)
        SydneyHUD._data.auto_laser = item:value() == "on"
    end
    MenuCallbackHandler.callback_set_gadget_id_on = function(self, item)
        SydneyHUD._data.set_gadget_id_on = item:value()
    end

    MenuCallbackHandler.callback_enable_laser_options_snipers = function(self, item)
        SydneyHUD._data.enable_laser_options_snipers = item:value() == "on"
    end
    MenuCallbackHandler.callback_laser_color_r_snipers = function(self, item)
        SydneyHUD._data.laser_color_r_snipers = item:value()
        SydneyHUD:SetBoxColor("laser_color", "_snipers")
    end
    MenuCallbackHandler.callback_laser_color_g_snipers = function(self, item)
        SydneyHUD._data.laser_color_g_snipers = item:value()
        SydneyHUD:SetBoxColor("laser_color", "_snipers")
    end
    MenuCallbackHandler.callback_laser_color_b_snipers = function(self, item)
        SydneyHUD._data.laser_color_b_snipers = item:value()
        SydneyHUD:SetBoxColor("laser_color", "_snipers")
    end
    MenuCallbackHandler.callback_laser_color_rainbow_snipers = function(self, item)
        SydneyHUD._data.laser_color_rainbow_snipers = item:value() == "on"
    end
    MenuCallbackHandler.callback_laser_color_a_snipers = function(self, item)
        SydneyHUD._data.laser_color_a_snipers = item:value()
    end
    MenuCallbackHandler.callback_laser_glow_snipers = function(self, item)
        SydneyHUD._data.laser_glow_snipers = item:value()
    end
    MenuCallbackHandler.callback_laser_light_snipers = function(self, item)
        SydneyHUD._data.laser_light_snipers = item:value()
    end
    MenuCallbackHandler.callback_enable_laser_options_turret = function(self, item)
        SydneyHUD._data.enable_laser_options_turret = item:value() == "on"
    end
    MenuCallbackHandler.callback_laser_color_r_turret = function(self, item)
        SydneyHUD._data.laser_color_r_turret = item:value()
        SydneyHUD:SetBoxColor("laser_color", "_turret")
    end
    MenuCallbackHandler.callback_laser_color_g_turret = function(self, item)
        SydneyHUD._data.laser_color_g_turret = item:value()
        SydneyHUD:SetBoxColor("laser_color", "_turret")
    end
    MenuCallbackHandler.callback_laser_color_b_turret = function(self, item)
        SydneyHUD._data.laser_color_b_turret = item:value()
        SydneyHUD:SetBoxColor("laser_color", "_turret")
    end
    MenuCallbackHandler.callback_laser_color_rainbow_turret = function(self, item)
        SydneyHUD._data.laser_color_rainbow_turret = item:value() == "on"
    end
    MenuCallbackHandler.callback_laser_color_a_turret = function(self, item)
        SydneyHUD._data.laser_color_a_turret = item:value()
    end
    MenuCallbackHandler.callback_laser_glow_turret = function(self, item)
        SydneyHUD._data.laser_glow_turret = item:value()
    end
    MenuCallbackHandler.callback_laser_light_turret = function(self, item)
        SydneyHUD._data.laser_light_turret = item:value()
    end
    MenuCallbackHandler.callback_enable_laser_options_turretr = function(self, item)
        SydneyHUD._data.enable_laser_options_turretr = item:value() == "on"
    end
    MenuCallbackHandler.callback_laser_color_r_turretr = function(self, item)
        SydneyHUD._data.laser_color_r_turretr = item:value()
        SydneyHUD:SetBoxColor("laser_color", "_turretr", SydneyHUD.color_box_2)
    end
    MenuCallbackHandler.callback_laser_color_g_turretr = function(self, item)
        SydneyHUD._data.laser_color_g_turretr = item:value()
        SydneyHUD:SetBoxColor("laser_color", "_turretr", SydneyHUD.color_box_2)
    end
    MenuCallbackHandler.callback_laser_color_b_turretr = function(self, item)
        SydneyHUD._data.laser_color_b_turretr = item:value()
        SydneyHUD:SetBoxColor("laser_color", "_turretr", SydneyHUD.color_box_2)
    end
    MenuCallbackHandler.callback_laser_color_rainbow_turretr = function(self, item)
        SydneyHUD._data.laser_color_rainbow_turretr = item:value() == "on"
    end
    MenuCallbackHandler.callback_laser_color_a_turretr = function(self, item)
        SydneyHUD._data.laser_color_a_turretr = item:value()
    end
    MenuCallbackHandler.callback_laser_glow_turretr = function(self, item)
        SydneyHUD._data.laser_glow_turretr = item:value()
    end
    MenuCallbackHandler.callback_laser_light_turretr = function(self, item)
        SydneyHUD._data.laser_light_turretr = item:value()
    end
    MenuCallbackHandler.callback_enable_laser_options_turretm = function(self, item)
        SydneyHUD._data.enable_laser_options_turretm = item:value() == "on"
    end
    MenuCallbackHandler.callback_laser_color_r_turretm = function(self, item)
        SydneyHUD._data.laser_color_r_turretm = item:value()
        SydneyHUD:SetBoxColor("laser_color", "_turretm", SydneyHUD.color_box_3)
    end
    MenuCallbackHandler.callback_laser_color_g_turretm = function(self, item)
        SydneyHUD._data.laser_color_g_turretm = item:value()
        SydneyHUD:SetBoxColor("laser_color", "_turretm", SydneyHUD.color_box_3)
    end
    MenuCallbackHandler.callback_laser_color_b_turretm = function(self, item)
        SydneyHUD._data.laser_color_b_turretm = item:value()
        SydneyHUD:SetBoxColor("laser_color", "_turretm", SydneyHUD.color_box_3)
    end
    MenuCallbackHandler.callback_laser_color_rainbow_turretm = function(self, item)
        SydneyHUD._data.laser_color_rainbow_turretm = item:value() == "on"
    end
    MenuCallbackHandler.callback_laser_color_a_turretm = function(self, item)
        SydneyHUD._data.laser_color_a_turretm = item:value()
    end
    MenuCallbackHandler.callback_laser_glow_turretm = function(self, item)
        SydneyHUD._data.laser_glow_turretm = item:value()
    end
    MenuCallbackHandler.callback_laser_light_turretm = function(self, item)
        SydneyHUD._data.laser_light_turretm = item:value()
    end

    -- Interact Tweak
    MenuCallbackHandler.callback_push_to_interact = function(self, item)
        SydneyHUD._data.push_to_interact = item:value() == "on"
    end
    MenuCallbackHandler.callback_push_to_interact_delay = function(self, item)
        SydneyHUD._data.push_to_interact_delay = item:value()
    end
    MenuCallbackHandler.callback_equipment_interrupt = function(self, item)
        SydneyHUD._data.equipment_interrupt = item:value() == "on"
    end

    MenuCallbackHandler.callback_hold_to_pick = function(self, item)
        SydneyHUD._data.hold_to_pick = item:value() == "on"
    end
    MenuCallbackHandler.callback_hold_to_pick_delay = function(self, item)
        SydneyHUD._data.hold_to_pick_delay = item:value()
    end
    MenuCallbackHandler.callback_interact_time_hint = function(self, item)
        SydneyHUD._data.interact_time_hint = item:value() == "on"
    end
    -- Other
    MenuCallbackHandler.callback_tab_font_size = function(self, item)
        SydneyHUD._data.tab_font_size = item:value()
    end

    MenuCallbackHandler.callback_auto_sentry_ap = function(self, item)
        SydneyHUD._data.auto_sentry_ap = item:value() == "on"
    end

    MenuCallbackHandler.callback_show_enemy_health = function(self, item)
        SydneyHUD._data.show_enemy_health = item:value() == "on"
    end
    MenuCallbackHandler.callback_health_bar_color = function(self, item)
        SydneyHUD._data.health_bar_color = item:value()
    end

    MenuCallbackHandler.callback_show_damage_popup = function(self, item)
        SydneyHUD._data.show_damage_popup = item:value() == "on"
    end

    MenuCallbackHandler.callback_remove_ads = function(self, item)
        SydneyHUD._data.remove_ads = item:value() == "on"
    end
    MenuCallbackHandler.callback_move_lpi_lobby_box = function(self, item)
        SydneyHUD._data.move_lpi_lobby_box = item:value() == "on"
        if managers.menu_component._contract_gui and managers.menu_component._contract_gui.UpdateTeamBox then
            managers.menu_component._contract_gui:UpdateTeamBox()
        end
    end
    MenuCallbackHandler.callback_lobby_skins_mode = function(self, item)
        SydneyHUD._data.lobby_skins_mode = item:value()
    end
    MenuCallbackHandler.callback_enable_buy_all_assets = function(self, item)
        SydneyHUD._data.enable_buy_all_assets = item:value() == "on"
    end
    MenuCallbackHandler.callback_remove_answered_pager_contour = function(self, item)
        SydneyHUD._data.remove_answered_pager_contour = item:value() == "on"
    end
    MenuCallbackHandler.callback_enable_pacified = function(self, item)
        SydneyHUD._data.enable_pacified = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_suspicion_text = function(self, item)
        SydneyHUD._data.show_suspicion_text = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_melee_interaction = function(self, item)
        SydneyHUD._data.show_melee_interaction = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_reload_interaction = function(self, item)
        SydneyHUD._data.show_reload_interaction = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_interaction_circle = function(self, item)
        SydneyHUD._data.show_interaction_circle = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_interaction_text = function(self, item)
        SydneyHUD._data.show_interaction_text = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_text_borders = function(self, item)
        SydneyHUD._data.show_text_borders = item:value() == "on"
    end
    MenuCallbackHandler.callback_truncate_name_tags = function(self, item)
        SydneyHUD._data.truncate_name_tags = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_client_ranks = function(self, item)
        SydneyHUD._data.show_client_ranks = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_own_rank = function(self, item)
        SydneyHUD._data.show_own_rank = item:value() == "on"
    end
    MenuCallbackHandler.callback_colorize_names = function(self, item)
        SydneyHUD._data.colorize_names = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_detection_rate = function(self, item)
        SydneyHUD._data.show_detection_rate = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_downs_left = function(self, item)
        SydneyHUD._data.show_downs_left = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_stamina_meter = function(self, item)
        SydneyHUD._data.show_stamina_meter = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_armor_timer = function(self, item)
        SydneyHUD._data.show_armor_timer = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_inspire_timer = function(self, item)
        SydneyHUD._data.show_inspire_timer = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_underdog_aced = function(self, item)
        SydneyHUD._data.show_underdog_aced = item:value() == "on"
    end
    MenuCallbackHandler.callback_anti_stealth_grenades = function(self, item)
        SydneyHUD._data.anti_stealth_grenades = item:value() == "on"
    end

    MenuCallbackHandler.callback_center_assault_banner = function(self, item)
        SydneyHUD._data.center_assault_banner = item:value() == "on"
    end
    MenuCallbackHandler.callback_enable_enhanced_assault_banner = function(self, item)
        SydneyHUD._data.enable_enhanced_assault_banner = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_assault_states = function(self, item)
        SydneyHUD._data.show_assault_states = item:value() == "on"
    end
    MenuCallbackHandler.callback_enhanced_assault_spawns = function(self, item)
        SydneyHUD._data.enhanced_assault_spawns = item:value() == "on"
    end
    MenuCallbackHandler.callback_enhanced_assault_time = function(self, item)
        SydneyHUD._data.enhanced_assault_time = item:value() == "on"
    end
    MenuCallbackHandler.callback_time_format = function(self, item)
        SydneyHUD._data.time_format = item:value()
    end
    MenuCallbackHandler.callback_enhanced_assault_count = function(self, item)
        SydneyHUD._data.enhanced_assault_count = item:value() == "on"
    end

    MenuCallbackHandler.callback_interaction_color_r = function(self, item)
        SydneyHUD._data.interaction_color_r = item:value()
        SydneyHUD:SetBoxColor("interaction_color")
    end
    MenuCallbackHandler.callback_interaction_color_g = function(self, item)
        SydneyHUD._data.interaction_color_g = item:value()
        SydneyHUD:SetBoxColor("interaction_color")
    end
    MenuCallbackHandler.callback_interaction_color_b = function(self, item)
        SydneyHUD._data.interaction_color_b = item:value()
        SydneyHUD:SetBoxColor("interaction_color")
    end

    MenuCallbackHandler.callback_anti_bobble = function(self, item)
        SydneyHUD._data.anti_bobble = item:value() == "on"
    end

    -- Chat Info
    MenuCallbackHandler.callback_show_heist_time = function(self, item)
        SydneyHUD._data.show_heist_time = item:value() == "on"
    end
    MenuCallbackHandler.callback_24h_format = function(self, item)
        SydneyHUD._data._24h_format = item:value() == "on"
    end
    MenuCallbackHandler.callback_chat_time_format = function(self, item)
        SydneyHUD._data.chat_time_format = item:value()
    end

    MenuCallbackHandler.callback_assault_phase_chat_info = function(self, item)
        SydneyHUD._data.assault_phase_chat_info = item:value() == "on"
    end
    MenuCallbackHandler.callback_assault_phase_chat_info_feed = function(self, item)
        SydneyHUD._data.assault_phase_chat_info_feed = item:value() == "on"
    end

    MenuCallbackHandler.callback_ecm_battery_chat_info = function(self, item)
        SydneyHUD._data.ecm_battery_chat_info = item:value() == "on"
    end
    MenuCallbackHandler.callback_ecm_battery_chat_info_feed = function(self, item)
        SydneyHUD._data.ecm_battery_chat_info_feed = item:value() == "on"
    end

    MenuCallbackHandler.callback_inspire_ace_chat_info = function(self, item)
        SydneyHUD._data.inspire_ace_chat_info = item:value() == "on"
    end

    MenuCallbackHandler.callback_down_warning_chat_info = function(self, item)
        SydneyHUD._data.down_warning_chat_info = item:value() == "on"
    end
    MenuCallbackHandler.callback_critical_down_warning_chat_info = function(self, item)
        SydneyHUD._data.critical_down_warning_chat_info = item:value() == "on"
    end

    MenuCallbackHandler.callback_down_warning_chat_info_feed = function(self, item)
        SydneyHUD._data.down_warning_chat_info_feed = item:value() == "on"
    end
    MenuCallbackHandler.callback_critical_down_warning_chat_info_feed = function(self, item)
        SydneyHUD._data.critical_down_warning_chat_info_feed = item:value() == "on"
    end

    MenuCallbackHandler.callback_replenished_chat_info = function(self, item)
        SydneyHUD._data.replenished_chat_info = item:value() == "on"
    end
    MenuCallbackHandler.callback_replenished_chat_info_feed = function(self, item)
        SydneyHUD._data.replenished_chat_info_feed = item:value() == "on"
    end

    -- Corpse Remover Plus
    MenuCallbackHandler.callback_enable_corpse_remover_plus = function(self, item)
        SydneyHUD._data.enable_corpse_remover_plus = item:value() == "on"
    end
    MenuCallbackHandler.callback_remove_shield = function(self, item)
        SydneyHUD._data.remove_shield = item:value() == "on"
    end
    MenuCallbackHandler.callback_remove_body = function(self, item)
        SydneyHUD._data.remove_body = item:value() == "on"
    end
    MenuCallbackHandler.callback_remove_interval = function(self, item)
        SydneyHUD._data.remove_interval = item:value()
    end

    -- EXPERIMENTAL
    MenuCallbackHandler.callback_waypoint_color_r = function(self, item)
        SydneyHUD._data.waypoint_color_r = item:value()
        SydneyHUD:SetBoxColor("waypoint_color")
    end
    MenuCallbackHandler.callback_waypoint_color_g = function(self, item)
        SydneyHUD._data.waypoint_color_g = item:value()
        SydneyHUD:SetBoxColor("waypoint_color")
    end
    MenuCallbackHandler.callback_waypoint_color_b = function(self, item)
        SydneyHUD._data.waypoint_color_b = item:value()
        SydneyHUD:SetBoxColor("waypoint_color")
    end
    MenuCallbackHandler.callback_show_deployable_waypoint = function(self, item)
        SydneyHUD._data.show_deployable_waypoint = item:value() == "on"
    end
    MenuCallbackHandler.callback_show_timer_waypoint = function(self, item)
        SydneyHUD._data.show_timer_waypoint = item:value() == "on"
    end
    MenuCallbackHandler.callback_custom_waypoint_offscreen_type = function(self, item)
        SydneyHUD._data.offscreen_type = item:value()
    end
    MenuCallbackHandler.callback_custom_waypoint_offscreen_radius_scale = function(self, item)
        SydneyHUD._data.offscreen_radius_scale = item:value()
    end
    MenuCallbackHandler.callback_custom_waypoint_transit_speed = function(self, item)
        SydneyHUD._data.transit_speed = item:value()
    end

    MenuCallbackHandler.callback_civilian_spot = function(self, item)
        SydneyHUD._data.civilian_spot = item:value() == "on"
    end
    MenuCallbackHandler.callback_civilian_spot_voice = function(self, item)
        SydneyHUD._data.civilian_spot_voice = item:value() == "on"
    end

    MenuCallbackHandler.callback_new_icon = function(self, item)
        SydneyHUD._data.new_icon = item:value() == "on"
    end

    MenuCallbackHandler.callback_swansong_effect = function(self, item)
        SydneyHUD._data.swansong_effect = item:value() == "on"
    end

    -- SydneyHUD
    MenuCallbackHandler.callback_sydneyhud_language = function(self, item)
        SydneyHUD._data.language = item:value()
    end

    MenuCallbackHandler.callback_sydneyhud_reset = function(self, item)
        local menu_title = managers.localization:text("sydneyhud_reset")
        local menu_message = managers.localization:text("sydneyhud_reset_message")
        local menu_options = {
            [1] = {
                text = managers.localization:text("sydneyhud_reset_yes"),
                callback = function()
                    SydneyHUD:LoadDefaults()
                    SydneyHUD:ForceReloadAllMenus()
                    
                end,
            },
            [2] = {
                text = managers.localization:text("sydneyhud_reset_cancel"),
                is_cancel_button = true,
            },
        }
        QuickMenu:new(menu_title, menu_message, menu_options, true)
    end
    
    MenuCallbackHandler.SydneyHUDSave = function(this, item)
        SydneyHUD:Save()
        SydneyHUD:DestroyPanel()
    end

    --[[
        Load our previously saved data from our save file.
    ]]
    SydneyHUD:InitAllMenus()
end)