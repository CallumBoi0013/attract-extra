/////////////////////
// Example Controls module layout
////////////////////
fe.load_module("objects/controls");
fe.add_image("debug.png", 0, 0, 1920, 1080);

local menu = fe.add_surface(500, 600);
menu.set_pos(200, 200);

local manager = FeControls({
    selected = "lblDisplays"
});

manager.add(FeLabel("lblDisplays", 50, 25, 200, 50, {
    surface = menu,
    up = "btnRandom", down = "lblFilters", right = "btnLaunch",
    select = function() {
        ::fe.signal("displays_menu");
    },
    state_default = {
        msg = "Displays"
    }
}));

manager.add(FeLabel("lblFilters", 50, 75, 200, 50, {
    surface = menu,
    up = "lblDisplays", down = "lblPrev", right = "btnLaunch",
    select = function() {
        ::fe.signal("filters_menu");
    },
    state_default = {
        msg = "Filters"
    }
}))

manager.add(FeLabel("lblPrev", 50, 125, 200, 50, {
    surface = menu,
    up = "lblFilters", down = "lblNext", right = "btnLaunch",
    select = function() {
        ::fe.signal("prev_game");
    },
    state_default = {
        msg = "Previous"
    }
}));

manager.add(FeLabel("lblNext", 50, 175, 200, 50, {
    surface = menu,
    up = "lblPrev", down = "btnRandom", right = "btnLaunch",
    select = function() {
        ::fe.signal("next_game");
    },
    state_default = {
        msg = "Next"
    },
    state_selected = {
        msg = "S"
    }
}));

manager.add(FeLabel("lblTitle", 270, 50, 600, 50, {
    surface = menu,
    up = "lblDisplays", left = "lblPrev", right = "lblNext", down = "btnRandom",
    state_default = {
        msg = "[Title]",
        charsize = 22,
        align = Align.Left,
        nomargin = true,
    }
}));

manager.add(FeButton("btnRandom", 50, 250, 200, 50, {
    surface = menu,
    up = "lblNext", left = "btnLaunch", right = "btnLaunch", down = "lblDisplays",
    select = function() {
        ::fe.signal("random_game");
    },
    state_default = {
        msg = "Randomize",
        charsize = 14,
        file_name = "button.png",
        rgb = [ 0, 0, 0],
    },
    state_selected = {
        file_name = "button_selected.png",
        rgb = [ 100, 0, 100],
    },
}));

manager.add(FeButton("btnLaunch", 260, 250, 200, 50, {
    surface = menu,
    up = "lblNext", left = "btnRandom", down = "lblDisplays", right = "btnRandom",
    state_default = {
        msg = "Launch",
        charsize = 14,
        file_name = "button.png",
        rgb = [ 0, 0, 0 ],
    },
    state_selected = {
        file_name = "button_selected.png",
        rgb = [ 0, 200, 0],
    }
}));

manager.init();

/////////////////////
// Debugging
////////////////////
fe.add_signal_handler(this, "on_signal");
function on_signal(str) {
    if ( str == "custom1" ) {
        fe.signal("reload");
        return true;
    }
    return false;
}