class PropertyAnimation extends Animation {
    supported = [ "x", "y", "width", "height", "scale", "rotation", "red", "green", "blue", "bg_red", "bg_green", "bg_blue", "sel_red", "sel_green", "sel_blue", "selbg_red", "selbg_green", "selbg_blue", "alpha", "skew_x", "skew_y", "pinch_x", "pinch_y", "subimg_x", "subimg_y", "charsize" ];
    origin = null;
    scale = 1.0;

    function defaults(params) {
        base.defaults(params);

        //set some additional default values
        opts = merge_opts({
            key = null,
            scale = 1.0,
            center_scale = false,
            center_rotation = false
        }, opts);

        //if target was specified, set the target
        if ( params.len() > 0 )
            target(params[0]);
        else if ( "target" in opts && opts.target != null )
            target(opts.target);
        return this;
    }

    function target( ref ) {
        //store objects origin values
        origin = {
            x = ref.x,
            y = ref.y,
            width = ref.width,
            height = ref.height,
            origin_x = ref.origin_x,
            origin_y = ref.origin_y,
            scale = 1.0
        }
        opts.target <- ref;
        return this;
    }

    function key( key ) {
        opts.key <- key;
        //set default from and to to the current value 
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
    
    function center_rotation(bool = true) { opts.center_rotation = bool; return this; }
    function center_scale(bool = true) { opts.center_scale = bool; return this; }

    function update() {
        base.update();
        if ( opts.key == "rotation" ) {
            current = opts.target[opts.key] = opts.interpolator.interpolate(_from, _to, progress);
            set_rotation(current);
        } else if ( opts.key == "scale" ) {
            current = opts.interpolator.interpolate(_from, _to, progress);
            set_scale(current);
        } else if ( supported.find != null ) {
            current = opts.target[opts.key] = opts.interpolator.interpolate(_from, _to, progress);
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

    function cancel( state = "stop") {
        base.cancel();
        if ( state == "table" ) {
            set_state( state );
        } else if ( state == "string" ) {
            if ( state == "start" ) {
                set_state( origin );
            } else if ( state == "stop" ) {
                local cancel_state = {}
                cancel_state[opts.key] <- opts.to;
                set_state( cancel_state );
            } else if ( "state" in state ) {
                set_state( states[state] );
            }
        }
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

    function set_rotation( r ) {
        if ( opts.center_rotation ) {
            opts.target.x = origin.x + ( ( origin.width * scale ) / 2 );
            opts.target.y = origin.y + ( ( origin.height * scale ) / 2 );
            opts.target.origin_x = ( origin.width * scale ) - ( origin.width / 2 ) ;
            opts.target.origin_y = ( origin.height * scale ) - ( origin.height / 2 );
        }
    }

    function set_scale( s ) {
        scale = s;
        opts.target.width = origin.width * s;
        opts.target.height = origin.height * s;
        if ( opts.center_scale ) {
            opts.target.x = origin.x + ( ( origin.width * s ) / 2 );
            opts.target.y = origin.y + ( ( origin.height * s ) / 2 );
            opts.target.origin_x = ( origin.width * s ) - ( origin.width / 2 ) ;
            opts.target.origin_y = ( origin.height * s ) - ( origin.height / 2 );
        }
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