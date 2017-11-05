class PropertyAnimation extends Animation {
    supported = [ "x", "y", "width", "height", "origin_x", "origin_y", "scale", "rotation", "red", "green", "blue", "bg_red", "bg_green", "bg_blue", "sel_red", "sel_green", "sel_blue", "selbg_red", "selbg_green", "selbg_blue", "alpha", "skew_x", "skew_y", "pinch_x", "pinch_y", "subimg_x", "subimg_y", "charsize" ];
    scale = 1.0;

    function defaults(params) {
        base.defaults(params);
        //set some additional default values
        opts = merge_opts({
            key = null,
            center_scale = false,
            center_rotation = false
        }, opts);
        return this;
    }

    function target( ref ) {
        base.target( ref );
        //store objects origin values
        save_state( "origin", collect_state(ref) );
        states["origin"].scale <- 1.0;
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
        return this;
    }
    
    function center_rotation(bool = true) { opts.center_rotation = bool; return this; }
    function center_scale(bool = true) { opts.center_scale = bool; return this; }

    function start() {
        local state = collect_state( opts.target );
        //save the target start state
        save_state( "start", clone(state) );
        save_state( "from", clone(state) );
        save_state( "to", clone(state) );
        states["from"][opts.key] <- opts.from;
        states["to"][opts.key] <- opts.to;
        base.start();
    }

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

    //cancel animation, set key to specified state (origin, start, from or to)
    function cancel( state = "") {
        print("anim canceled");
        if ( typeof(state) == "string" && state in states )
            try {
                opts.target[opts.key] = states[state][opts.key];
                print("set cancel state to: " + state);
            } catch(e) {
                print("couldn't set " + opts.key + "for cancel state: " + state);
            }
        base.cancel();
    }
    
    //set the target state
    function set_state( state ) {
        if ( "target" in opts && opts.target != null ) {
            print( "set state: " + table_as_string( state ) );
            foreach( key, val in state ) {
                try { opts.target[ key ] = val; } catch (err) {}
            }
        }
        return this;
    }

    //collect supported key values in a state from target
    function collect_state(target) {
        if ( target == null ) return;
        local state = {}
        for ( local i = 0; i < supported.len(); i++)
            try {
                state[supported[i]] <- target[supported[i]];
            } catch(e) {}
        return state;
    }

    //set target centered rotation
    function set_rotation( r ) {
        if ( opts.center_rotation ) {
            opts.target.x = states["origin"].x + ( ( states["origin"].width * scale ) / 2 );
            opts.target.y = states["origin"].y + ( ( states["origin"].height * scale ) / 2 );
            opts.target.origin_x = ( states["origin"].width * scale ) - ( states["origin"].width / 2 ) ;
            opts.target.origin_y = ( states["origin"].height * scale ) - ( states["origin"].height / 2 );
        }
    }

    //set target scale
    function set_scale( s ) {
        scale = s;
        opts.target.width = states["origin"].width * s;
        opts.target.height = states["origin"].height * s;
        if ( opts.center_scale ) {
            opts.target.x = states["origin"].x + ( ( states["origin"].width * s ) / 2 );
            opts.target.y = states["origin"].y + ( ( states["origin"].height * s ) / 2 );
            opts.target.origin_x = ( states["origin"].width * s ) - ( states["origin"].width / 2 ) ;
            opts.target.origin_y = ( states["origin"].height * s ) - ( states["origin"].height / 2 );
        }
    }
}