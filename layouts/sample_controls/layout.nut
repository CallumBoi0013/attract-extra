/////////////////////
// Example Controls module layout
////////////////////
fe.load_module("objects/controls");
fe.load_module("animate2");

local flw = fe.layout.width;
local flh = fe.layout.height;

local bg = fe.add_image("debug.png", 0, 0, 1920, 1080);

//side menu
local menu = fe.add_surface(flw * 0.2, flh);
local menu_bg = menu.add_text("", 0, 0, flw * 0.2, flh);
menu_bg.set_bg_rgb(150, 150, 150);

local art_bg = fe.add_text("", flw * 0.2, flh *0.1, flw * 0.8, flh);
art_bg.set_bg_rgb(20, 20, 20);

//bottom bar
local bottom_bar = fe.add_surface(flw, flh * 0.2);
bottom_bar.set_pos(flw * 0.2, flh * 0.8);
local bottom_bar_bg = bottom_bar.add_text("", 0, 0, flw, flh * 0.2);
bottom_bar_bg.set_bg_rgb(175, 175, 175);

//game title
local title = fe.add_text("[Title]", flw * 0.2, 0, flw * 0.8, flh * 0.1);
title.set_bg_rgb(30, 30 , 175);
title.set_rgb(200, 200, 200);
title.charsize = 40;
title.align = Align.Left;

local art = fe.add_artwork("flyer", flw * 0.2, flh *0.1, flw * 0.8, flh * 0.7);
art.preserve_aspect_ratio = true;
//art.trigger = Transition.EndNavigation;

//variables for animation
local barAnim = PropertyAnimation(bottom_bar).key("y");
local barVisible = true;

//Create Controls Manager
local manager = FeControls({
    selected = "lblDisplays"
});

// ADD CONTROLS //
manager.add(FeLabel("lblDisplays", flw * 0.025, flh * 0.05, 200, 50, {
    surface = menu,
    up = function() { if ( barVisible ) manager.select("btnRandom"); }, down = "lblFilters", right = function() { manager.enabled = false; },
    select = function() {
        ::fe.signal("displays_menu");
    },
    state_default = {
        msg = "Displays",
        charsize = 18
    }
}));

manager.add(FeLabel("lblFilters", flw * 0.025, flh * 0.12, 200, 50, {
    surface = menu,
    up = "lblDisplays", down = "lblPrev", right = function() { manager.enabled = false; },
    select = function() {
        ::fe.signal("filters_menu");
    },
    state_default = {
        msg = "Filters",
        charsize = 18
    }
}))

manager.add(FeLabel("lblPrev", flw * 0.025, flh * 0.19, 200, 50, {
    surface = menu,
    up = "lblFilters", down = "lblNext", right = function() { manager.enabled = false; },
    select = function() {
        ::fe.signal("prev_game");
    },
    state_default = {
        msg = "Previous",
        charsize = 18
    }
}));

manager.add(FeLabel("lblNext", flw * 0.025, flh * 0.26, 200, 50, {
    surface = menu,
    up = "lblPrev", down = "lblBottomBar", right = function() { manager.enabled = false; },
    select = function() {
        ::fe.signal("next_game");
    },
    state_default = {
        msg = "Next",
        charsize = 18
    },
    // state_selected = {
    //     msg = "S"
    // }
}));

manager.add(FeLabel("lblBottomBar", flw * 0.025, flh * 0.33, 200, 50, {
    surface = menu,
    up = "lblNext", down = function() { if ( barVisible ) manager.select("btnRandom"); }, right = function() { manager.enabled = false; },
    select = function() {
        if ( barVisible )
            barAnim.to(flh).speed(2).play();
        else
            barAnim.to(flh * 0.8).speed(2).play();
        barVisible = !barVisible;
    },
    state_default = {
        msg = "Toggle Bar",
        charsize = 18
    }
}));

manager.add(FeButton("btnRandom", flw * 0.025, flh * 0.02, 200, 50, {
    surface = bottom_bar,
    up = "lblBottomBar", down = "lblDisplays", left = "lblBottomBar", right = "btnLaunch",
    select = function() {
        ::fe.signal("random_game");
    },
    state_default = {
        msg = "Randomize",
        charsize = 18,
        file_name = "button.png",
        rgb = [ 0, 0, 0],
    },
    state_selected = {
        file_name = "button_selected.png",
        rgb = [ 100, 0, 100],
    },
}));

manager.add(FeButton("btnLaunch", flw * 0.2, flh * 0.02, 200, 50, {
    surface = bottom_bar,
    up = "lblNext", down = "lblDisplays", left = "btnRandom", right = "btnRandom",
    state_default = {
        msg = "Launch",
        charsize = 18,
        file_name = "button.png",
        rgb = [ 0, 0, 0 ],
    },
    state_selected = {
        file_name = "button_selected.png",
        rgb = [ 0, 200, 0],
    }
}));
fe.add_signal_handler(this, "on_signal");
function on_signal(str) {
    if ( str == "custom1" ) {
        // For debugging
        fe.signal("reload");
        return true;
    } else if ( str == "left" ) {
        manager.enabled = true;
        return true;
    } else if ( str == "right" ) {
        //do nothing for right to prevent confusing UI
        return true;
    } else if ( str == "select" ) {
        //do nothing for right to prevent confusing UI
        if ( !manager.enabled ) return true;
    }
    return false;
}

//init manager after our own signal handler, our signal handler gets priority
manager.init();
