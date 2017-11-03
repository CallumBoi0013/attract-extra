fe.load_module("animate2");

fe.layout.width = 800;
fe.layout.height = 600;
fe.add_image("debug.png", 0, 0, 1920, 1080);
local text = fe.add_text("[Title]", 0, 10, fe.layout.width, 50);
    text.set_rgb(30, 30, 30);
    text.charsize = 28;
local art1 = fe.add_artwork("snap", 250, 200, 320, 240 );

local anim = PropertyAnimation(art1).key("x").from(250).to(50);
local anim2 = PropertyAnimation(art1).key("y").to(100);

//local tl = TimelineAnimation().add(anim).add(anim2);

fe.add_signal_handler(this, "on_signal");

function on_signal(str) {
    if ( str == "custom1" ) {
        fe.signal("reload")
        return true;
    } else if ( str == "prev_page" ) {
        anim.play();
        return true;
    } else if ( str == "next_page" ) {
        anim2.play();
        return true;
    }
    return false;
}
