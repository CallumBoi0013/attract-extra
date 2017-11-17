fe.load_module("animate2");
fe.load_module("objects/coverflow");

class MyFlow extends CoverFlow {
    opts = {
        COUNT = 7,
        SELECTED_PAD = 10,
        SELECTED_PRESERVE = true,
        SELECTED_WIDTH = 0.22,
        SELECTED_HEIGHT = 1.5,
        SELECTED_YOFFSET = 0,
        SELECTED_PINCH_Y = 0,
        UNSELECTED_PAD = 10,
        UNSELECTED_PRESERVE = true,
        UNSELECTED_YOFFSET = - 0,
        UNSELECTED_HEIGHT = 1
        UNSELECTED_PINCH_Y = 0,
    }
}

fe.add_image("debug.png", 0, 0);
//fe.add_artwork("snap", 0, 0, fe.layout.width, fe.layout.height);
local bg = fe.add_image("pixel.png", 0, 0);
bg.set_rgb(10, 10, 10 );

//CoverFlow("flyer", fe.layout.width * 0.1, fe.layout.height * 0.15, fe.layout.width * 0.8, fe.layout.height * 0.35);
//CustomFlow("flyer", fe.layout.width * 0.1, fe.layout.height * 0.35, fe.layout.width * 0.8, fe.layout.height * 0.35);
MyFlow("flyer", fe.layout.width * 0.05, fe.layout.height * 0.35, fe.layout.width * 0.95, fe.layout.height * 0.35);
//Gallery("flyer");

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
