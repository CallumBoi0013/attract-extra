///////////////////////////////////////////
// AM Controls Module
//
// The Controls module allows you to create a navigation UI with labels and buttons.
// It consists of a Controls Manager, which takes over control of AM using a signal handler,
// and you add FeControls like buttons or labels which specify which controls to select
// when a certain button is pressed.
//
// You can tie actions to a function, so if the users "selects" a control, your function will
// run.
/////////////////////

// Utility functions
////////////////////

//merge one options table with another - values in b will overwrite values in a
::merge_opts <- function(a, b) {
    local opts = clone(a);
    foreach( key, value in b )
        try {
            if ( typeof(b[key]) == "table" ) opts[key] <- ::merge_opts( ( key in opts ) ? opts[key] : {}, b[key]); else opts[key] <- value;
        } catch(e) {}
    return opts;
}

//set properties of an AM object using a squirrel table
::set_props <- function(obj, props) {
    if ( obj == null ) return;
    foreach( key, val in props )
        try {
            //check for custom or modified properties
            if ( key == "rgb" || key == "rgba" ) {
                obj.set_rgb(val[0], val[1], val[2]);
                if ( props[key].len() > 3 ) obj.alpha = props[key][3];
            } else if ( key == "bg_rgb" || key == "bg_rgba" ) {
                obj.set_bg_rgb(val[0], val[1], val[2]);
                if ( props[key].len() > 3 ) obj.bg_alpha = props[key][3];
            } else if ( key == "sel_rgb" || key == "sel_rgba" ) {
                obj.set_sel_rgb(val[0], val[1], val[2]);
                if ( props[key].len() > 3 ) obj.sel_alpha = props[key][3];
            } else if ( key == "selbg_rgb" || key == "selbg_rgba" ) {
                obj.set_selbg_rgb(val[0], val[1], val[2]);
                if ( props[key].len() > 3 ) obj.selbg_alpha = props[key][3];
            } else if ( key == "nomargin" ) {
                //supported only >= 1.3
                try { obj.nomargin = val; } catch(e) {};
            } else if ( key == "label" ) {
                //ignore it - this is for artwork - use file_name to change dynamically
            } else {
                try { obj[key] = val; } catch(e) {}
            }
        } catch(e) { ::print("error setting key " + key + ": " + e + "\n"); }
}

::table_as_string <- function ( table ) {
    if ( table == null ) return "";
    local str = "";
    foreach ( name, value in table )
    {
        if ( typeof(value) == "table" )
        {
            str += "[" + name + "] -> ";
            str += table_as_string( value );
        } else
        {
            str += name + ": " + value + " ";
        }
    }
    return str;
}

/////////////////////
// FeControls
// Handles which control is selected and movement between each control
////////////////////
class FeControls {
    VERSION = 1.0;
    opts = null;
    controls = null;
    constructor(opts = {}) {
        //set some default values, overriden by user provided values when merged
        this.opts = ::merge_opts({
            enabled = true,                     //whether controls manager takes control
            selected = null,                    //selected control
            last_selected = null,               //last selected control
            clear_selection = true,             //clear selection on disable, restore selection on enable
            key_up = "up",                      //up key
            key_down = "down",                  //down key
            key_left = "left",                  //left key
            key_right = "right",                //right key
            key_select = "select"               //select key
        }, opts);

        controls = {};
    }

    //enable or disable manager
    //function enabled(e) { opts.enabled = e; return this; }
    //allow layout to customize user keys
    function up(str) { opts.key_up = str; return this; }
    function down(str) { opts.key_down = str; return this; }
    function left(str) { opts.key_left = str; return this; }
    function right(str) { opts.key_right = str; return this; }
    function select(str) { opts.key_select = str; return this; }

    //add new control
    function add(ctl) {
        controls[ctl.id] <- ctl;
        if ( opts.selected == null || ( opts.selected && ctl.id == opts.selected ) ) select(ctl.id);
        return this;
    }

    function clear_selection() {
        foreach( ctl in controls )
            ctl.trigger.call(ctl, "selected", false );
        opts.last_selected = opts.selected;
        opts.selected = null;
    }

    //select control by id
    function select(id) {
        if ( id in controls == false ) return;
        foreach( ctl in controls )
            if ( ctl.id == id )
                ctl.trigger.call(ctl, "selected", true );
            else
                ctl.trigger.call(ctl, "selected", false );
        opts.last_selected = opts.selected;
        opts.selected = id;
    }

    //initialize manager
    function init() {
        select(opts.selected);
        ::fe.add_signal_handler(this, "on_signal");
    }
    
    function _get(key) {
        if ( key in opts ) return opts[key];
    }

    function _set(key, val) {
        if ( key == "enabled" ) {
            if ( val != opts.enabled ) {
                if ( opts.clear_selection && val ) select(opts.last_selected);
                if ( opts.clear_selection && !val ) clear_selection(); 
            }
        }
        if ( key in opts ) opts[key] <- val;
    }

    //catch keys we need (up/down/left/right/select)
    function on_signal(str) {
        if ( !opts.enabled || opts.selected == null ) return false;
        if ( str == opts.key_up || str == opts.key_down || str == opts.key_left || str == opts.key_right ) {
            //try to run function, or select new control
            if ( str in controls[opts.selected].opts ) {
                if ( typeof(controls[opts.selected].opts[str]) == "function" )
                    controls[opts.selected].opts[str].call(controls[opts.selected]);
                else if ( typeof(controls[opts.selected].opts[str]) == "string" )
                    select(controls[opts.selected].opts[str]);
            }
            return true;
        } else if ( str == opts.key_select && str in controls[opts.selected].opts ) {
            //run included opts function
            try {
                controls[opts.selected].opts[str].call(controls[opts.selected]);
                return true;
            } catch(e) {}
        }
        if ( str in controls[opts.selected].opts ) {
            //run from class trigger function
            controls[opts.selected].trigger.call(controls[opts.selected], "select");
        }
        return false;
    }
}

/////////////////////
// FeControl
// Base control to be used with FeControlsManager
////////////////////
class FeControl {
    opts = null;
    constructor(id, x, y, w, h, opts = {}) {
        this.opts = ::merge_opts({
            id = id,
            x = x,
            y = y,
            width = w,
            height = h
        }, opts);
        create( ( "surface" in opts ) ? opts.surface : ::fe );
    }
    
    function create(surface) {
        //you should create your control object here - use surface.add_xxxx with this.x, this.y, this.width, this.height as arguments
    }
    
    function update_props(selected) {
        //update your controls property values here - selected is true or false
    }
    function trigger(event, val = null) {
        //capture triggered events for this control - the following events are captureable:
        //selected: when control is selected or deselected - val is true/false
        //select: when user presses select on control - val is null

        //by default, a control will update its property values when selected/unselected
        if ( event == "selected" )
            update_props(val);
    }

    function _get(key) {
        if ( key in opts ) return opts[key];
    }

    function _set(key, val) {
        if ( key in opts ) opts[key] <- val;
    }
}

/////////////////////
// FeLabel
// A Text label extended from FeControl
////////////////////
class FeLabel extends FeControl {
    text = null;
    template_default = {
        bg_alpha = 0,
        rgb = [ 0, 0, 0 ],
        nomargin = true,
        charsize = 16
    }
    template_selected = {
        bg_alpha = 255,
        bg_rgb = [ 0, 150, 0 ],
        rgb = [ 0, 50, 0 ]
    }

    function create(surface) {
        text = surface.add_text("", this.x, this.y, this.width, this.height);
    }

    function update_props(selected) {
        local state = ::merge_opts(template_default, opts.state_default);
        if ( selected ) state = ::merge_opts(state, template_selected);
        ::set_props(text, state);
    }
}

/////////////////////
// FeButton
// A button, consisting of a surface, image texture and text label
////////////////////
class FeButton extends FeControl {
    container = null;
    texture = null;
    text = null;
    template_default = {
        bg_rgb = [ 255, 255, 255 ],
        bg_alpha = 255,
        rgb = [ 0, 0, 0 ],
        nomargin = true,
        charsize = 16
    }
    template_selected = {
        bg_rgb = [ 0, 150, 0 ],
        bg_alpha = 255,
        rgb = [ 0, 50, 0 ]
    }

    function create(surface) {
        container = surface.add_surface(this.width, this.height);
        container.set_pos(this.x, this.y);
        try {
            texture = container.add_image(opts.state_default.file_name, 0, 0, this.width, this.height);
        } catch(e) {}
        text = container.add_text("", 0, 0, this.width, this.height);
        ::fe.add_ticks_callback(this, "on_tick");
        //::fe.add_transition_callback(this, "on_transition");
    }

    function on_tick(ttime) {
        //workaround fix for subsurface redraw
        if ( ttime < 3000 ) container.set_pos(container.x, container.y);
    }

    function on_transition(ttype, var, ttime) {
        //if ( ttype == Transition.FromOldSelection ) container.set_pos(container.x, container.y);
    }

    function update_props(selected) {
        local state = ::merge_opts(template_default, opts.state_default);
        if ( selected ) state = ::merge_opts(state, template_selected);
        local rgb = state.rgb;
        if ( texture ) {
            //swap bg_ properties when a texture is used
            state.alpha <- ( "bg_alpha" in state ) ? state.bg_alpha : 255;
            state.rgb <- ( "bg_rgb" in state ) ? state.bg_rgb : [ 255, 255, 255 ];
            state.rawdelete("bg_alpha");
            state.rawdelete("bg_rgb");
            ::set_props(texture, state);
        }
        //use remaining properties for the text object
        //don't use background for text when a texture is used
        state.rgb = rgb;
        state.bg_alpha <- ( texture ) ? 0 : 255;
        ::set_props(text, state);
    }
}
