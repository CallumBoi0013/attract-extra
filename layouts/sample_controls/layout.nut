/////////////////////
// Example Controls module layout
////////////////////

//be sure to load the module!
fe.load_module("objects/controls");

local flw = fe.layout.width;
local flh = fe.layout.height;

//side menu
local menu = fe.add_surface(flw * 0.2, flh);
local menu_bg = menu.add_text("", 0, 0, flw * 0.2, flh);
menu_bg.set_bg_rgb(130, 130, 130);

//game title
local title = fe.add_text("[Title]", flw * 0.2, 0, flw * 0.8, flh * 0.1);
title.set_bg_rgb(30, 30 , 175);
title.set_rgb(200, 200, 200);
title.charsize = 40;
title.align = Align.Left;

local art = fe.add_artwork("flyer", flw * 0.2, flh *0.1, flw * 0.8, flh);
art.preserve_aspect_ratio = true;

//create manager class (options are chainable if you prefer)
local manager = FeControls({
    selected = "lblDisplays"
});

function hide_menu() {
    menu.visible = false;
    manager.enabled = false;
    title.set_pos(0, 0, flw, flh * 0.1);
    art.set_pos(0, flh *0.1, flw, flh);
}

function show_menu() {
    menu.visible = true;
    manager.enabled = true;
    title.set_pos(flw * 0.2, 0, flw, flh * 0.1);
    art.set_pos(flw * 0.2, flh *0.1, flw, flh);
}

// ADD LABELS //
manager.add(FeLabel("lblDisplays", flw * 0.025, flh * 0.05, 200, 50, {
    surface = menu,
    up = "btnLaunch", down = "lblFilters", right = hide_menu,
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
    up = "lblDisplays", down = "lblPrev", right = hide_menu,
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
    up = "lblFilters", down = "lblNext", right = hide_menu,
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
    up = "lblPrev", down = "btnRandom", right = hide_menu,
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

// ADD BUTTONS //
manager.add(FeButton("btnRandom", flw * 0.025, flh * 0.45, 200, 50, {
    surface = menu,
    up = "lblNext", down = "btnLaunch", right = hide_menu,
    select = function() {
        ::fe.signal("random_game");
    },
    state_default = {
        msg = "Random Game",
        charsize = 18,
        file_name = "button.png",
        rgb = [ 0, 0, 0],
    },
    state_selected = {
        file_name = "button_selected.png",
        rgb = [ 100, 0, 100],
    },
}));

manager.add(FeButton("btnLaunch", flw * 0.025, flh * 0.55, 200, 50, {
    surface = menu,
    up = "btnRandom", down = "lblDisplays", left = "btnRandom", right = hide_menu,
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

//Our own signal handler - control is handed over to the controls manager
//when 'left' is pressed. Control is passed back to our signal handler when 'right'
// is pressed on any of the label/buttons above
fe.add_signal_handler(this, "on_signal");
function on_signal(str) {
    if ( str == "custom1" ) {
        // For debugging
        fe.signal("reload");
        return true;
    } else if ( str == "left" ) {
        //return control to the controls manager
        show_menu();
        return true;
    } else if ( str == "right" ) {
        //do nothing for right to prevent confusing UI
        //hmm... we could do a show_right_menu() here with game info :)
        return true;
    }
    return false;
}

//initialize the controls manager
//we init if after our own signal handler here, just to make our signal handler get priority
manager.init();
