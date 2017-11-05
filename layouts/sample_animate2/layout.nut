fe.load_module("animate2");

fe.layout.width = 1024;
fe.layout.height = 768;
fe.add_image("debug.png", 0, 0, 1920, 1080);
local text = fe.add_text("[Title]", 0, 10, fe.layout.width, 50);
    text.set_rgb(30, 30, 30);
    text.charsize = 28;
local art1 = fe.add_image("dvd.png", 50, 200, 320, 320 );
local art2 = fe.add_artwork("snap", 400, 200, 320, 240 );
local art3 = fe.add_image("joystick-move.png", 800, 200, 128, 128);

Animation.GLOBALS.DEBUG = false;

local anim = PropertyAnimation(art1)
                .debug(false)
                .key("rotation")
                .center_rotation()
                .from(0).to(359)
                .speed(1)
                .loops(-1)
                //.interpolator( CubicBezierInterpolator("ease-in-out-back") )
                //.play()
local anim2 = PropertyAnimation(art2)
                .debug(false)
                .key("scale")
                .center_scale()
                .from(1).to(2)
                .triggers([ Transition.FromOldSelection ])

local anim3 = SpriteAnimation(art3)
                .debug(false)
                .sprite_width(128)
                .sprite_height(128)
                .sprite_order([ 0, 1, 0, 2 ])
                .sprite_frame(3)
                .loops(-1)
                .speed(0.25)

//local tl = TimelineAnimation().add(anim).add(anim2);

fe.add_signal_handler(this, "on_signal");

function on_signal(str) {
    if ( str == "custom1" ) {
        fe.signal("reload")
        return true;
    } else if ( str == "prev_page" ) {
        anim.play();
        //anim.step(anim.progress - 0.01);
        return true;
    } else if ( str == "next_page" ) {
        anim3.play();
        //anim.step(anim.progress + 0.01);
        return true;
    } else if ( str == "prev_display" ) {
        return true;
    } else if ( str == "next_display" ) {
        return true;
    } else if ( str == "displays_menu" ) {
        anim.cancel("to");
        return true;
    }
    return false;
}
