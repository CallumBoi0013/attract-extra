class ControlsManager
{
    exit_states = { updown = 0, leftright = 1 }
    controls = null;
    selected = 0;
    key_up = "up";
    key_down = "down";
    key_left = "left";
    key_right = "right";
    key_select = "select";

    constructor()
    {
        controls = [];
        ::fe.add_signal_handler( this, "signal" );
        return this;
    }
    
    //chained methods

    //allow layout to customize user keys
    function up(str) { key_up = str; return this; }
    function down(str) { key_down = str; return this; }
    function left(str) { key_left = str; return this; }
    function right(str) { key_right = str; return this; }
    function select(str) { key_select = str; return this; }

    function add( ctl ) { controls.push( ctl ); return this; }
    function init() {
        if ( controls.len() > 0 ) controls[selected].setState("selected");
    }
    
    function update( next ) {
        if ( selected <= controls.len() - 1 ) {
            //deselected current control
            controls[selected].setState("enabled");
        }
        controls[next].setState("selected");
        selected = next;
    }

    //find the next best control to select based on current control index and direction
    //  - clean up code
    //  - wrap to other side
    function next( current, dir )
    {
        local center_current = [ controls[current].x + ( controls[current].width / 2 ), controls[current].y + ( controls[current].height / 2 )];
        local match = null;
        for( local i = 0; i < controls.len(); i++ )
        {
            local center =  [ controls[i].x + ( controls[i].width / 2 ), controls[i].y + ( controls[i].height / 2 )];
            local dist_this = sqrt( pow( abs( center[0] - center_current[0] ), 2) + pow( abs( center[1] - center_current[1] ), 2) );
            
            switch( dir )
            {
                case key_down:
                    if ( controls[i].y > controls[current].y )
                    {
                        if ( match == null ) match = i;
                        local center_match =  [ controls[match].x + ( controls[match].width / 2 ), controls[match].y + ( controls[match].height / 2 )];
                        local dist_match = sqrt( pow( abs( center_match[0] - center_current[0] ), 2) + pow( abs( center_match[1] - center_current[1] ), 2) );
                        if ( dist_this < dist_match ) match = i;
                    }
                    break;
                case key_up:
                    if ( controls[i].y < controls[current].y )
                    {
                        if ( match == null ) match = i;
                        local center_match =  [ controls[match].x + ( controls[match].width / 2 ), controls[match].y + ( controls[match].height / 2 )];
                        local dist_match = sqrt( pow( abs( center_match[0] - center_current[0] ), 2) + pow( abs( center_match[1] - center_current[1] ), 2) );
                        if ( dist_this < dist_match ) match = i;
                    }
                    break;
                case key_left:
                    if ( controls[i].x < controls[current].x )
                    {
                        if ( match == null ) match = i;
                        local center_match =  [ controls[match].x + ( controls[match].width / 2 ), controls[match].y + ( controls[match].height / 2 )];
                        local dist_match = sqrt( pow( abs( center_match[0] - center_current[0] ), 2) + pow( abs( center_match[1] - center_current[1] ), 2) );
                        if ( dist_this < dist_match ) match = i;
                    }
                    break;
                case key_right:
                    if ( controls[i].x > controls[current].x )
                    {
                        if ( match == null ) match = i;
                        local center_match =  [ controls[match].x + ( controls[match].width / 2 ), controls[match].y + ( controls[match].height / 2 )];
                        local dist_match = sqrt( pow( abs( center_match[0] - center_current[0] ), 2) + pow( abs( center_match[1] - center_current[1] ), 2) );
                        if ( dist_this < dist_match ) match = i;
                    }
                    break;
            }
        }
        return ( match == null ) ? current : match;
    }
    
    function signal( str )
    {
        if ( controls.len() <= 0 ) return false;
        
        //allow control to take over signal handler
        if ( controls[selected].handle_signal ) return controls[selected].signal( str );
        
        switch ( str )
        {
            case key_up:
                update( next( selected, "up" ) );
                return true;
            case key_left:
                update( next( selected, "left" ) );
                return true;
            case key_down:
                update( next( selected, "down" ) );
                return true;
            case key_right:
                update( next( selected, "right" ) );
                return true;
            case key_select:
                controls[selected].onAction();
                return true;
        }
        return false;
    }
}

// Generic View surface that will hold various objects
// when adding objects to an FeView, you need to specify a reference name as
// the first argument, followed by the standard arguments for add_text, add_image,
// add_artwork, add_clone
// you can also pass an initial set of properties in a table at the end
// you can access the created children with .find(name)
class FeView {
    DEBUG = false;
    ref = null;
    children = null;

    constructor( x, y, width, height, surface = ::fe) {
        ref = surface.add_surface(width, height);
        ref.set_pos(x, y);
        children = {}
        if ( DEBUG ) {
            //debug surface
            local bg = ref.add_image("images/pixel.png", 0, 0, ref.width, ref.height);
            bg.set_rgb( 30, 30, 30 );
        }
    }
    
    //forward unhandled properties to the surface ref
    function _get(idx) { return ref[idx]; }
    function _set(idx, val) { return val; }

    function find(name) {
        foreach(key, val in children)
            if ( key == name ) return val;
    }
    
    function add_child(name, ref, props = null) {
        children[name] <- ref;
        if ( props != null ) set_props(children[name], props);
        return this;
    }

    function add_text(name, msg, x, y, width, height, props = null) {
        return add_child(name, ref.add_text(msg, x * ref.width, y * ref.height, width * ref.width, height * ref.height), props);
    }

    function add_image(name, filename, x, y, width, height, props = null) {
        return add_child(name, ref.add_image(filename, x * ref.width, y * ref.height, width * ref.width, height * ref.height), props);
    }

    function add_artwork(name, label, x, y, width, height, props = null) {
        return add_child(name, ref.add_artwork(label, x * ref.width, y * ref.height, width * ref.width, height * ref.height), props);
    }

    function add_clone(name, ref, props = null) {
        return add_child(name, ref.add_clone(ref), props);
    }

    static function print(msg) {
        ::print(msg);
    }

    //merge one table into another ( 2nd table will overwrite any existing keys )
    static function merge_props(a, b) {
        foreach( key, value in b ) {
            if ( typeof(b[key]) == "table" )
                a[key] <- merge_props(a[key], b[key]);
            else
                a[key] <- b[key];
        }
        return a;
    }

    //set properties of an AM object using a squirrel table
    //includes some additional custom properties
    static function set_props(obj, props) {
        if ( obj == null ) return;
        foreach( key, val in props )
            try {
                //check for custom or modified properties
                if ( key == "rgb" ) {
                    obj.set_rgb(props[key][0], props[key][1], props[key][2]);
                } else if ( key == "rgba" ) {
                    obj.set_rgb(props[key][0], props[key][1], props[key][2]);
                    obj.alpha = props[key][3];
                } else if ( key == "bg_rgb" ) {
                    obj.set_bg_rgb(props[key][0], props[key][1], props[key][2]);
                } else if ( key == "bg_rgba" ) {
                    obj.set_bg_rgb(props[key][0], props[key][1], props[key][2]);
                    obj.bg_alpha = props[key][3];
                } else if ( key == "sel_rgb" ) {
                    obj.set_sel_rgb(props[key][0], props[key][1], props[key][2]);
                } else if ( key == "sel_rgba" ) {
                    obj.set_sel_rgb(props[key][0], props[key][1], props[key][2]);
                    obj.sel_alpha = props[key][3];
                } else if ( key == "selbg_rgb" ) {
                    obj.set_selbg_rgb(props[key][0], props[key][1], props[key][2]);
                } else if ( key == "selbg_rgba" ) {
                    obj.set_selbg_rgb(props[key][0], props[key][1], props[key][2]);
                } else if ( key == "label" ) {
                    //ignore it - this is for artwork - use file_name to change dynamically
                } else {
                    obj[key] = val;
                }
            } catch(e) {
                print_debug("unable to set prop: " + key + " on " + obj + ": " + e);
            }
    }
}

class FeControl extends FeView
{
    template = null;
    enabled = true;
    selected = false;
    previous_state = "";
    current_state = "";
    handle_signal = false;
    action = null;

    constructor( x, y, width, height, surface = ::fe, template = null )
    {   
        if ( template != null ) {
            base.constructor(x, y, width, height, surface);
            this.template = template;
            template.create(this);
        } else {
            print_debug("You must provide a template for an FeControl, there is no default", "WARN");
        }
    }

    //forward unhandled properties to the surface ref
    //function _get(idx) { return ref[idx]; }
    //function _set(idx, val) { return val; }

    //chainable methods
    function set_pos( x, y ) {
        this.x = x;
        this.y = y;
        return this;
    }

    function setAction( func ) {
        this.action = func;
        return this;
    }
    
    function signal( str )
    {
        //if handle_signal is true, the control will handle signal events
        return this;
    }
    
    //get controls current state
    function getState() {
        return current_state;
    }

    function setState( name )
    {
        switch ( name )
        {
            case "selected":
                onSelected();
                break;
            case "enabled":
                if ( previous_state == "selected" ) onDeselected(); else onEnabled();
                break;
            case "disabled":
            default:
                onDisabled();
                break;
        }
        this.previous_state = this.current_state;
        this.current_state = name;
        return this;
    }
    
    function onEnabled() {
        if ( "enabled" in template ) template.enabled(this);
    }
    function onDisabled() {
        if ( "disabled" in template ) template.disabled(this);
    }
    function onSelected() {
        if ( "selected" in template ) template.selected(this);
    }
    function onDeselected() {
        if ( "enabled" in template ) template.enabled(this);
    }
    function onAction() {
        if ( "action" in template ) template.action(this);
        if ( action != null && typeof(action) == "function" ) action();
    }
}

fe.load_module("objects/controls/button");
fe.load_module("objects/controls/checkbox");