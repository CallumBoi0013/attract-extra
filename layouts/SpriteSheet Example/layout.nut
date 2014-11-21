fe.load_module("spritesheet");

local bg = fe.add_image("bg.png", 0, 0, fe.layout.width, fe.layout.height);
local logo = fe.add_image("logo.png");
    logo.set_pos(fe.layout.width / 2 - logo.texture_width / 2, 20);
local list = fe.add_listbox(fe.layout.width / 2, logo.y + logo.texture_height, fe.layout.width / 2, fe.layout.height);
    list.charsize = 18;

local joy = fe.add_image("joystick-move.png");
    joy.set_pos(logo.x, logo.texture_height + 50);    
local sprite = SpriteSheet(joy, 128);
    //sprite.orientation = "vertical"; //default is horizontal
    sprite.order = [ 0, 3, 0, 3, 0, 4, 0, 4, 0, 1, 0, 2, 0, 1, 0, 2, 0];
    sprite.repeat = "loop";
    sprite.spf = 0.25;
    sprite.frame(0);
    sprite.start();

local button = fe.add_image("button-press-white.png");
    button.set_pos(logo.x + 128 + 50, joy.y + 10);
local sprite2 = SpriteSheet(button, 128);
    sprite2.repeat = "yoyo";
    sprite2.order = [ 0, 0, 1, 2, 3, 4, 5, 5 ];
    sprite2.spf = 0.2;
    sprite2.frame(0);
    sprite2.start();

local button2 = fe.add_image("button-press-red.png");
    button2.set_pos(button.x + 96, button.y);
local sprite3 = SpriteSheet(button2, 128);
    sprite3.frame(0);
    sprite3.repeat = "loop";
    sprite3.spf = 0.5;
    sprite3.order = [ 0, 5, 0, 5, 0, 0, 5 ];
    sprite3.start();
