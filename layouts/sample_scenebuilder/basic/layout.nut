//local path = fe.script_dir + "basic/";.
//print("**************** " + path + " *************\n")
SceneBuilder
    .scene("basic")
        .options({ alpha = 0 })
        .add("image", { file_name = "basic/bg.png", x = 0, y = 0, width = fe.layout.width, height = fe.layout.height })
        .add("artwork", { label = "snap", x = 348, y = 152, width = 262, height = 262, trigger = Transition.EndNavigation })
        .add("artwork", { label = "marquee", x = 348, y = 64, width = 262, height = 72, trigger = Transition.EndNavigation })
        .add("listbox", { x = 32, y = 64, width = 262, height = 352, charsize = 16, bg_red = 255, bg_green = 255, bg_blue = 255, sel_red = 0, sel_green = 0, sel_blue = 0, sel_style = Style.Bold })
        .add("text", { msg = "[DisplayName]", x = 0, y = 15, width = 640, height = 30 })
        //left side
        .add("text", { msg = "[Title]", x = 30, y = 424, width = 320, height = 16, align = Align.Left })
        .add("text", { msg = "[Year] [Manufacturer]", x = 30, y = 441, width = 320, height = 16, red = 200, green = 200, blue = 70, align = Align.Left })
        .add("text", { msg = "[Category]", x = 30, y = 458, width = 320, height = 16, red = 200, green = 200, blue = 70, align = Align.Left })
        //right side
        .add("text", { msg = "[ListEntry]/[ListSize]", x = 320, y = 424, width = 290, height = 16, red = 200, green = 200, blue = 70, align = Align.Right })
        .add("text", { msg = "[Category]", x = 320, y = 441, width = 290, height = 16, red = 200, green = 200, blue = 70, align = Align.Right })
