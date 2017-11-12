Animation.GLOBALS.DEBUG = false;

local pixel = fe.add_image("resources/pixel.png", -1, -1, 1, 1);
function create( type, props ) {
    local obj;
    if ( type == "text" ) obj = fe.add_text("", -1, -1, 1, 1);
    if ( type == "image" ) obj = fe.add_image("resources/pixel.png", -1, -1, 1, 1);
    if ( type == "artwork" ) obj = fe.add_artwork(props.label, -1, -1, 1, 1);
    if ( type == "surface" ) obj = fe.add_surface(props.width, props.height);
    if ( type == "listbox" ) obj = fe.add_listbox(-1, -1, 1, 1);
    if ( type == "pixel" ) obj = fe.add_clone(pixel);
    setProps(obj, props);
    return obj;
}

function setProps(obj, props) {
    foreach( key, val in props)
        try {
            if ( key == "rgb" ) {
                obj.set_rgb(val[0],val[1],val[2]);
                if ( val.len() > 3 ) obj.alpha = val[3];
            } else if ( key == "bg_rgb" ) {
                obj.set_bg_rgb(val[0],val[1],val[2]);
                if ( val.len() > 3 ) obj.bg_alpha = val[3];
            } else if ( key == "sel_rgb" ) {
                obj.set_sel_rgb(val[0],val[1],val[2]);
                if ( val.len() > 3 ) obj.sel_alpha = val[3];
            } else if ( key == "selbg_rgb" ) {
                obj.set_selbg_rgb(val[0],val[1],val[2]);
                if ( val.len() > 3 ) obj.selbg_alpha = val[3];
            } else if ( key == "label" ) {
                //ignore
            } else {
                obj[key] = val;
            }
        } catch(e) {}
}

//objects are set to visible as needed
local visible = false
::OBJECTS <- {
    bg = create("image", { file_name = "resources/debug.png", x = 0, y =  0, width = 1920, height = 1080 }),
    surface = create("surface", { visible = visible, width = fe.layout.width, height = fe.layout.height }),
    snap = create("artwork", { visible = visible, label = "snap", x = 650, y = 200, width = 320, height = 240, preserve_aspect_ratio = true, video_flags = Vid.NoAudio }),
    wheel = create("artwork", { visible = visible, label = "wheel", x = fe.layout.width - 400, y = 50, width = 300, height = 200, preserve_aspect_ratio = true }),
    marquee = create("artwork", { visible = visible, label = "marquee", x = 170, y = 360, width = 400, height = 100, preserve_aspect_ratio = true }),
    list = create( "listbox", { visible = visible, x = 0, y = 0, width = 450, height =fe.layout.height, charsize = 16, rgb = [ 220, 220, 220 ], bg_rgb = [ 30, 30, 30, 255 ], selbg_rgb = [ 50, 160, 50 ] }),    
    title = create("text", { visible = visible, msg = "[Title]", x = 0, y = 15, width = fe.layout.width, height = 72, rgb = [ 255, 255, 0 ], charsize = 32 }),
    box = create("image", { visible = visible, file_name = "resources/box.png", x = 900, y = 100, width = 100, height = 100, rgb = [ 240, 0, 240, 100 ] }),
    pixel = create("pixel", { visible = visible, x = -1, y = -1, width = 1, height = 1 }),
    tutorialbg = create("pixel", { visible = true, x = 0, y = fe.layout.height - 128, width = fe.layout.width, height = 128, rgb = [ 20, 20, 20, 220 ] }),
    tutorial1 = create("text", { visible = true, msg = "", x = 20, y = fe.layout.height - 118, width = fe.layout.width, height = 30, charsize = 24, style = Style.Bold, align = Align.Left, rgb = [ 230, 230, 230 ] }),
    tutorial2 = create("text", { visible =true, x = 20, y = fe.layout.height - 100, width = fe.layout.width, height = 60, charsize = 22, align = Align.Left, word_wrap = true, rgb = [ 150, 150, 150 ] }),
    tutorial3 = create("text", { visible = true, msg = "Use up/down to navigate examples, left/right to change games", x = 0, y = fe.layout.height - 40, width = fe.layout.width, height = 30, charsize = 22, style = Style.Bold, rgb = [ 200, 200, 50 ] }),
    tutorial_bar = create("pixel", { visible = true, x = 0, y = fe.layout.height - 152, width = fe.layout.width, height = 24, rgb = [ 220, 100, 30 ] }),
    tutorial_bar_progress = create("pixel", { visible = true, x = 0, y = fe.layout.height - 152, width = 0, height = 24, rgb = [ 240, 60, 0 ] }),
    tutorial_bar_text = create("text", { visible = true, x = 0, y = fe.layout.height - 152, width = fe.layout.width, height = 24, charsize = 14, align = Align.Left, msg = "     Intro           Property     Transform    Interpolate        Events           Sprite         Timeline          States            Macro          Particle         Practice" }),
    tutorial_instructions = create("text", { visible = true, x = 50, y = 100, width = fe.layout.width / 2, height = 300, rgb = [ 20, 20, 20 ], charsize = 18, align = Align.Left, word_wrap = true }),
    cd = create("image", { visible = visible, file_name = "resources/cd.png", x = 50, y = 200, width = 320, height = 320 }),
    joystick = create("image", { visible = visible, file_name = "resources/joystick-move.png", x = 1100, y = 518, width = 128, height = 128, subimg_width = 128, subimg_height = 128 }),
    joy_text = create("text", { visible = visible, x = 160, y = 567, width = 925, height = 24, rgb = [ 20, 20, 20 ], charsize = 20, align = Align.Right, msg = "LEFT / RIGHT TO NAVIGATE GAMES" }),
    logo = create("image", { visible = visible, file_name = "resources/logo-verion.png", x = 400, y = 400, width = 432, height = 160 }),
}
