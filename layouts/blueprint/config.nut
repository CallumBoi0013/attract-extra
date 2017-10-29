local flw = fe.layout.width
local flh = fe.layout.height
//fe.layout.preserve_aspect_ratio = true

//4x3 - 640�480, 800�600, 960�720, 1024�768, 1280�960, 1400�1050, 1440�1080 , 1600�1200, 1856�1392, 1920�1440, and 2048�1536
//16x10 - 1280�800, 1440�900, 1680�1050, 1920�1200 and 2560�1600
//16x9 -  1024�576, 1152�648, 1280�720, 1366�768, 1600�900, 1920�1080, 2560�1440 and 3840�2160

::config <- {
    bg = {
        "Default": { x = 0, y = 0, width = flw, height = flh }
    },
    "Default": {
        background = {
            x = 0, y = 0, width = flw, height = flh,
            red = themes[theme].bg_1.red, green = themes[theme].bg_1.green, blue = themes[theme].bg_1.blue, alpha = themes[theme].bg_1.alpha,
        },
        fade_top = {
            x = 0, y = 0, width = flw, height = per(25, flh),
            red = themes[theme].bg_2.red, green = themes[theme].bg_2.green, blue = themes[theme].bg_2.blue, alpha = themes[theme].bg_2.alpha,
        },
        fade_bottom = {
            x = 0, y = per(77,flh), width = flw, height = per(25, flh),
            red = themes[theme].bg_2.red, green = themes[theme].bg_2.green, blue = themes[theme].bg_2.blue, alpha = themes[theme].bg_2.alpha,
        },
        list = {
            x = per(40,flw), y = per(20,flh), width = per(55,flw), height = per(60,flh),
            red = themes[theme].fg_3.red, green = themes[theme].fg_3.green, blue = themes[theme].fg_3.blue, alpha = themes[theme].fg_3.alpha,
            sel_red = themes[theme].fg_1.red, sel_green = themes[theme].fg_1.green, sel_blue = themes[theme].fg_1.blue, sel_alpha = themes[theme].fg_1.alpha,
            selbg_alpha = 0, rows = 10,
            font = "BebasNeue Book", align = Align.Left
        },
        attract_art = {
            x = per(66,flw), y = per(59,flh), width = per(33, flw), height = per(40, flh),
            preserve_aspect_ratio = true
        },
        attract_title = {
            x = per(0.5,flw), y = per(0.5,flh), width = per(98, flw), height = per(7, flh),
            red = themes[theme].fg_2.red, green = themes[theme].fg_2.green, blue = themes[theme].fg_2.blue, alpha = themes[theme].fg_2.alpha,
            font = "BebasNeue Book", align = Align.Left
        },
        fan_art = {
            x = 0, y = 0, width = flw, height = flh,
        },
        side_art = {
            x = per(5,flw), y = per(14,flh), width = per(30, flw), height = per(70, flh),
            preserve_aspect_ratio = true
        },
        infobar = {
            x = 0, y = 0, width = flw, height = per(8, flh),
            red = themes[theme].bg_3.red, green = themes[theme].bg_3.green, blue = themes[theme].bg_3.blue, alpha = themes[theme].bg_3.alpha,
        },
        info_line = {
            x = per(2.5,flw), y = per(93,flh), width = per(94,flw), height = 1,
            red = themes[theme].border_1.red, green = themes[theme].border_1.green, blue = themes[theme].border_1.blue, alpha = themes[theme].border_1.alpha,
        },
        info_one = {
            msg = "",
            x = 0, y = per(0.25,flw), width = per(50, flw), height = per(6, flh),
            red = themes[theme].fg_2.red, green = themes[theme].fg_2.green, blue = themes[theme].fg_2.blue, alpha = themes[theme].fg_2.alpha,
            font = "BebasNeue Book", align = Align.Left
        },
        info_two = {
            msg = "",
            x = per(0.5,flw), y = per(8, flh), width = per(50, flw), height = per(4, flh),
            red = themes[theme].fg_2.red, green = themes[theme].fg_2.green, blue = themes[theme].fg_2.blue, alpha = themes[theme].fg_2.alpha,
            font = "BebasNeue Book", align = Align.Left
        },
        info_three = {
            x = per(50, flw), y = per(0.25,flw), width = per(50, flw), height = per(6, flh),
            red = themes[theme].fg_2.red, green = themes[theme].fg_2.green, blue = themes[theme].fg_2.blue, alpha = themes[theme].fg_2.alpha,
            font = "BebasNeue Book", align = Align.Right
        },
        info_four = {
            x = per(50,flw), y = per(8, flh), width = per(49.5, flw), height = per(4, flh),
            red = themes[theme].fg_2.red, green = themes[theme].fg_2.green, blue = themes[theme].fg_2.blue, alpha = themes[theme].fg_2.alpha,
            font = "BebasNeue Book", align = Align.Right
        },
        info_five = {
            msg = "",
            x = per(0.5,flw), y = per(86,flh), width = flw, height = per(6, flh),
            red = themes[theme].fg_1.red, green = themes[theme].fg_1.green, blue = themes[theme].fg_1.blue, alpha = themes[theme].fg_1.alpha,
            font = "BebasNeue Book", align = Align.Left
        },
        info_six = {
            msg = "",
            x = per(1,flw), y = per(93,flh), width = flw, height = per(5, flh),
            red = themes[theme].fg_2.red, green = themes[theme].fg_2.green, blue = themes[theme].fg_2.blue, alpha = themes[theme].fg_2.alpha,
            font = "BebasNeue Book", align = Align.Left
        },
        info_seven = {
            msg = "",
            x = per(50,flw), y = per(94,flh), width = per(48,flw), height = per(4, flh),
            red = themes[theme].fg_2.red, green = themes[theme].fg_2.green, blue = themes[theme].fg_2.blue, alpha = themes[theme].fg_2.alpha,
            font = "BebasNeue Book", align = Align.Right
        },
        artwork = {
            art = "snap",
            x = 0, y = 0, width = flw, height = flh,
        },
        flyer = {
            art = "flyer",
            x = per(5, flw), y = per(12, flh), width = per(33, flw), height = per(60, flh),
        },
        //custom objects
        select_bg = {
            x = 0, y = 0, width = flw, height = flh,
            red = themes[theme].bg_3.red, green = themes[theme].bg_3.green, blue = themes[theme].bg_3.blue, alpha = themes[theme].bg_3.alpha,
        },
        select_overlay = {
            x = 0, y = per(50, flh), width = flw, height = per(25, flh),
            red = themes[theme].bg_3.red, green = themes[theme].bg_3.green, blue = themes[theme].bg_3.blue, alpha = themes[theme].bg_3.alpha,
        },
        wheel = {
            slots = 5, slot_width = per(18, flw), slot_height = per(50, flh), orientation = "horizontal",
            x = per(0, flw), y = per(38, flh), width = flw, height = per(50, flh)
        },
        search = {
            x = 0, y = per(8,flh), width = per(40, flw), height = per(92,flh),
            text_pos = [ 0.05, 0.15, 1, 0.1 ],
            key_pos = [ 0.1, 0.4, 0.8, 0.5 ],
            bg_red = themes[theme].bg_1.red, bg_green = themes[theme].bg_1.green, bg_blue = themes[theme].bg_1.blue, bg_alpha = themes[theme].bg_1.alpha,
            red = themes[theme].fg_2.red, green = themes[theme].fg_2.green, blue = themes[theme].fg_2.blue, alpha = themes[theme].fg_2.alpha,
            sel_red = themes[theme].fg_1.red, sel_green = themes[theme].fg_1.green, sel_blue = themes[theme].fg_1.blue, sel_alpha = themes[theme].fg_1.alpha,
            font = "BebasNeue Book"
        },
        system_bg = {
            red = themes[theme].bg_1.red, green = themes[theme].bg_1.green, blue = themes[theme].bg_1.blue
        },
        system_menu_bg = {
            x = 0, y = 0, width = per(25, flw), height = flh,
            red = themes[theme].bg_3.red, green = themes[theme].bg_3.green, blue = themes[theme].bg_3.blue,
        },
        system_title = {
            msg = "System Selection",
            x = per(25, flw), y = 0, width = per(75, flw), height = per(10, flh),
            red = themes[theme].fg_1.red, green = themes[theme].fg_1.green, blue = themes[theme].fg_1.blue,
            font = "BebasNeue Bold", charsize = 48, align = Align.Left
        },
        system_breadcrumb = {
            msg = "System Selection > [DisplayName]",
            x = per(25.2, flw), y = per(8, flh), width = per(75, flw), height = per(10, flh),
            red = themes[theme].fg_2.red, green = themes[theme].fg_2.green, blue = themes[theme].fg_2.blue,
            font = "BebasNeue Book", charsize = 42, align = Align.Left
        },
        system_list = {
            slots = 11,
            x = per(1, flw), y = per(5, flh), width = per(23, flw), height = per(33, flh),
            red = themes[theme].fg_1.red, green = themes[theme].fg_1.green, blue = themes[theme].fg_1.blue,
        },
        system_most_played = {
            msg = "Most Played",
            x = per(26.5, flw), y = per(17, flh), width = per(75, flw), height = per(10, flh),
            red = themes[theme].fg_3.red, green = themes[theme].fg_3.green, blue = themes[theme].fg_3.blue,
            font = "BebasNeue Bold", charsize = 36, align = Align.Left
        },
        system_most_played_1 = {
            art = "flyer",
            x = per(28, flw), y = per(27, flh), width = per(14, flw), height = per(33, flh),
        },
        system_most_played_2 = {
            art = "flyer",
            x = per(28, flw), y = per(63, flh), width = per(14, flw), height = per(33, flh),
        },
        system_last_played = {
            msg = "Last Played",
            x = per(46.5, flw), y = per(17, flh), width = per(75, flw), height = per(10, flh),
            red = themes[theme].fg_3.red, green = themes[theme].fg_3.green, blue = themes[theme].fg_3.blue,
            font = "BebasNeue Bold", charsize = 36, align = Align.Left
        },
        system_last_played_1 = {
            art = "flyer",
            x = per(48, flw), y = per(27, flh), width = per(14, flw), height = per(33, flh),
        },
        system_last_played_2 = {
            art = "flyer",
            x = per(48, flw), y = per(63, flh), width = per(14, flw), height = per(33, flh),
        },
    }
}