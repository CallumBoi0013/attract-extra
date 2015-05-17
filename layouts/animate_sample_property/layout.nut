fe.load_module("animate/animate");

local bg = fe.add_artwork("snap", -20, -20, fe.layout.width + 20, fe.layout.height + 20);
local text = fe.add_text("[Title]", 0, fe.layout.height - 90, fe.layout.width, 72);
text.charsize = 60;
text.red = 0;
text.green = 100;
text.blue = 100;

local size_cfg = {
    when = Transition.ToNewSelection,
    property = "scale",
    start = 1.0,
    end = 1.2,
    time = 30000
}

local move_cfg = {
    when = Transition.ToNewSelection,
    property = "position",
    start = { x = 0, y = fe.layout.height },
    end = { x = 0, y = fe.layout.height - 90 },
    time = 1000
}

local alpha_cfg = {
    when = Transition.ToNewSelection,
    property = "alpha",
    start = 0,
    end = 255,
    time = 1000
}

local color_cfg = {
    when = Transition.ToNewSelection,
    property = "color",
    start = { red = 0, green = 100, blue = 100 },
    end = { red = 0, green = 200, blue = 200 },
    time = 2000
}

animation.add( PropertyAnimation( bg, size_cfg ) );
animation.add( PropertyAnimation( text, move_cfg ) );
animation.add( PropertyAnimation( text, alpha_cfg ) );
animation.add( PropertyAnimation( text, color_cfg ) );
