fe.load_module("animate2");
fe.load_module("objects/coverflow");

//fe.add_image("debug.png", 0, 0);
//fe.add_artwork("snap", 0, 0, fe.layout.width, fe.layout.height);
local bg = fe.add_image("pixel.png", 0, 0);
bg.set_rgb(10, 10, 10 );

//fe.load_module("objects/gallery");

//CoverFlow("flyer", 100, 400, 1180, 250);
Gallery("flyer");
fe.add_text("[Title]", 0, 0, 1920, 80);

fe.add_signal_handler("on_signal");
function on_signal(str) {
    if ( str == "up" ) {
        return false;
    } else if ( str == "down" ) {
        return false;
    } else if ( str == "custom1" ) {
        fe.signal("reload");
        return true;
    }
    return false;
}
