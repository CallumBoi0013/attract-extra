fe.load_module("spritesheet");

fe.add_image("bg.png", 0, 0, fe.layout.width, fe.layout.height);

local logo = fe.add_image("logo.png");
    logo.set_pos(fe.layout.width / 2 - logo.texture_width / 2, 20);

local joy = fe.add_image("joystick-move.png");
    joy.set_pos(fe.layout.width / 2 - 64, logo.texture_height + 20 + 30);    
local sprite = SpriteSheet(joy, 128);
    //sprite.orientation = "vertical"; //default is horizontal
    sprite.order = [ 0, 3, 0, 3, 0, 4, 0, 4, 0, 1, 0, 2, 0, 1, 0, 2, 0];
    sprite.repeat = "loop";
    sprite.spf = 0.25;
    sprite.frame(0);
    sprite.start();

local joy2 = fe.add_image("joystick-move-vert.png");
    joy2.set_pos(fe.layout.width / 2 - 64, joy.y + 128 + 30);
local sprite2 = SpriteSheet(joy2, 128);
    sprite2.orientation = "vertical"; //default is horizontal
    sprite2.repeat = "yoyo";
    sprite2.spf = 1;
    sprite2.frame(0);
    sprite2.start();
