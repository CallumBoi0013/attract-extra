class PropertyAnimation extends Animation {
    supported = [ "x", "y", "width", "height", "rotation", "red", "green", "blue", "bg_red", "bg_green", "bg_blue", "sel_red", "sel_green", "sel_blue", "selbg_red", "selbg_green", "selbg_blue", "alpha", "skew_x", "skew_y", "pinch_x", "pinch_y", "subimg_x", "subimg_y", "charsize" ];
    unique_keys = null;
    x = 0;
    y = 0;
    width = null;
    height = null;
    scale = 1.0;

    constructor( param1 = null, param2 = null ) {
        base.constructor();

        unique_keys = [];
        opts = merge_opts({
            key = null,
            center_origin = true
        }, opts);

        if ( param1 != null && typeof(param1) == "table" ) {
            //param1 is a opts, update values opts.from defaults
            opts = merge_opts( opts, param1 );
        } else {
            if ( param2 != null && typeof(param2) == "table" ) {
                //param2 is a opts
                opts = merge_opts( opts, param2 );
            }
            //param1 is the target
            if ( param1 != null ) target(param1);
        }
    }

    function target( ref ) {
        opts.target <- ref;
        this.x = ref.x;
        this.y = ref.y;
        this.width = ref.width;
        this.height = ref.height;
        this.scale = 1.0;
        return this;
    }

    function key( key ) {
        opts.key <- key;
        if ( supported.find(key) != null ) {
            if ( key == "scale" )
                opts.from = opts.to = 1;
            else
                opts.from = opts.to = opts.target[key];
        } else {
            print("unsupported key: " + key + "\n");
        }
        save_state( opts.target, "start");
        return this;
    }

    function init() {
        base.init();
    }

    function play() {
        base.play();
    }

    function start() {
        get_unique_keys();
        base.start();
    }

    function update() {
        base.update();
        local value = ( opts.key == "scale" ) ? scale : opts.target[opts.key];
        local progress = ( value - opts.to ) / ( opts.to - opts.from );
        if ( opts.key == "rotation" ) {
            _from = opts.target[opts.key] = opts.interpolator.interpolate(_from, _to, progress);
            if ( value != 0 ) {
                if ( opts.center_origin ) {
                    opts.target.x = this.x + ( ( width * scale ) / 2 );
                    opts.target.y = this.y + ( ( height * scale ) / 2 );
                    opts.target.origin_x = ( width * scale ) - ( width / 2 ) ;
                    opts.target.origin_y = ( height * scale ) - (height / 2 );
                }
            } else {
                opts.target.x = this.x;
                opts.target.y = this.y;
            }
        } else if ( opts.key == "scale" ) {
            print("scale from/to: " + _from + " " + _to );
            _from = scale = opts.interpolator.interpolate(_from, _to, progress);
            if ( value != 1 ) {
                set_scale(scale);
            } else {
                opts.target.x = this.x;
                opts.target.y = this.y;
                opts.target.width = this.width;
                opts.target.height = this.height;
            }
        } else if ( supported.find != null ) {
            _from = opts.target[opts.key] = opts.interpolator.interpolate(_from, _to, progress);
        } else {
            print("unsupported key: " + opts.key + "\n");
        }
    }

    function stop() {
        base.stop();

        foreach( key in supported )
            if ( "current" in states && key in states["current"] )
                try {
                    states["current"][key] <- target[key];    
                } catch(e) {}
        
        if ( !yoyoing && opts.loops > 0 && play_count == 0 )
            if ( "then" in opts && typeof(opts.then) == "table" ) {
                set_state( opts.then );
                //don't keep running it
                opts.then = null;
            }
    }

    function cancel() {
        //immediately set state to the 'to' values on cancel
        local cancel_state = ( opts.to != null ) ? opts.to : states[opts.default_state];
        set_state( cancel_state );
        base.cancel();
    }
    
    //set the animation state
    function set_state( state ) {
        if ( "target" in opts && opts.target != null ) {
            print( "set state: " + table_as_string( state ) );
            foreach( key, val in state ) {
                try { opts.target[ key ] = val; } catch (err) {}
            }
        }
        return this;
    }

    function set_scale( s ) {
        opts.target.width = width * s;
        opts.target.height = height * s;
        if ( opts.center_origin ) {
            opts.target.x = this.x + ( ( width * s ) / 2 );
            opts.target.y = this.y + ( ( height * s ) / 2 );
            opts.target.origin_x = ( width * s ) - ( width / 2 ) ;
            opts.target.origin_y = ( height * s ) - (height / 2 );
        }
        scale = s;
    }

    //find unique keys that will be animated in the 'opts.from' and 'opts.to' states
    function get_unique_keys() {
        local found = {}
        unique_keys.clear();
        if ( "opts.from" in opts && opts.from != null )
            foreach( key, val in opts.from )
                if ( key in found == false && opts.to != null && key in opts.to )
                    found[key] <- val;
        if ( "opts.to" in opts && opts.to != null )
            foreach( key, val in opts.to )
                if ( key in found == false && opts.from != null && key in opts.from )
                    found[key] <- val;
        
        //find out if values change opts.from 'opts.from' and 'opts.to' states
        foreach( key, val in found )
            if ( key in opts.from && key in opts.to )
                if ( opts.from[key] != opts.to[key] )
                    unique_keys.append(key);
    }
}