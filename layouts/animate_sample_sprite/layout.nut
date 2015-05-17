fe.load_module("animate/animate");

local text = fe.add_text("[Title]", 0, 25, fe.layout.width, 72);
local joystick = fe.add_image("joystick-move.png", (fe.layout.width / 2) - 296, fe.layout.height - 128, 128, 128);
local joy_text = fe.add_text("Use joystick to move up/down list", joystick.x + 96, fe.layout.height - 80, 600, 30 );
joy_text.charsize = 36;

local sprite_cfg = {
    when = When.Always,
    width = 128,
    frame = 0,
    time = 3000,
    order = [ 0, 3, 0, 3, 0, 4, 0, 4 ],
    loop = true
}

animation.add( SpriteAnimation( joystick, sprite_cfg ) );