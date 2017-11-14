class PropertyAnimation extends Animation {
    supported = [ "x", "y", "width", "height", "origin_x", "origin_y", "scale", "rotation", "red", "green", "blue", "bg_red", "bg_green", "bg_blue", "sel_red", "sel_green", "sel_blue", "selbg_red", "selbg_green", "selbg_blue", "selbg_alpha", "alpha", "skew_x", "skew_y", "pinch_x", "pinch_y", "subimg_x", "subimg_y", "charsize" ];
    scale = 1.0;
    unique_keys = null;

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
        state( "origin", collect_state(ref) );
        states["origin"].scale <- 1.0;
        return this;
    }

    function key( key ) {
        opts.key <- key;
        return this;
    }
    
    function center_rotation(bool = true) { opts.center_rotation = bool; return this; }
    function center_scale(bool = true) { opts.center_scale = bool; return this; }

    function start() {
        if ( opts.from == null && opts.to == null ) {
            print("you didn't specify a from or to value");
            return;
        }

        //convert `from` and `to` to tables
        if ( opts.to == null ) opts.to <- {}
        if ( typeof(opts.to) != "table" ) {
            local val = opts.to;
            opts.to <- {}
            opts.to[opts.key] <- val;
        }
        if ( opts.from == null ) opts.from <- {}
        if ( typeof(opts.from) != "table" ) {
            local val = opts.from;
            opts.from <- {}
            opts.from[opts.key] <- val;
        }

        //save target states
        states["current"] <- collect_state( opts.target );
        state( "start", clone(states["current"]) );
        
        //ensure all keys are accounted for
        foreach( key, val in opts.to )
            if ( key in opts.from == false || opts.from[key] == null )
                opts.from[key] <- ( opts.default_state in states ) ? states[opts.default_state][key] : states["current"][key];
        foreach( key, val in opts.from )
            if ( key in opts.to == false || opts.from[key] == null )
                opts.to[key] <- ( opts.default_state in states ) ? states[opts.default_state][key] : states["current"][key];

        state( "from", ( opts.from == null ) ? ( opts.default_state in states ) ? states[opts.default_state] : clone(state) : opts.from );
        state( "to", ( opts.to == null ) ? (opts.default_state in states ) ? states[opts.default_state] : clone(state) : opts.to );
        
        //store a table of unique keys we are animating
        unique_keys = {}
        foreach ( key, val in opts.from )
            unique_keys[key] <- "";
        foreach ( key, val in opts.to )
            unique_keys[key] <- "";

        base.start();
    }

    function update() {
        if ( opts.from == null || opts.to == null ) return;
        base.update();
        foreach( key, val in states["to"] ) {
            if ( key == "scale" ) {
                local s = opts.interpolator.interpolate(_from[key], _to[key], progress);
                set_scale(s);
            } else if ( supported.find(key) != null ) {
                opts.target[key] = opts.interpolator.interpolate(_from[key], _to[key], progress);
                if ( key == "rotation" ) set_rotation(opts.target[key]);
            }
        }
        states["current"] <- collect_state(opts.target);

        if ( debug ) {
            //during debug, print out values as they are animated
            foreach( key, val in unique_keys )
                unique_keys[key] <- states["current"][key];
            print( "\t" + table_as_string(unique_keys));
        }
    }

    function stop() {
        base.stop();
        foreach( key in supported )
            try {
                states["current"][key] <- target[key];    
            } catch(e) {}
    }
    
    //collect supported key values in a state from target
    function collect_state(target) {
        if ( target == null ) return;
        local state = {}
        for ( local i = 0; i < supported.len(); i++)
            try {
                state[supported[i]] <- target[supported[i]];
            } catch(e) {}
        state.scale <- 1;
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
            //auto center scale
            //local offsetX = ( opts.target.width - states["origin"].width ) / 2;
            //local offsetY = ( opts.target.height - states["origin"].height ) / 2;
            opts.target.origin_x = ( opts.target.width / 2 ) / 2;
            opts.target.origin_y = ( opts.target.height / 2 ) / 2;
        } else {
            //scale origin
            opts.target.origin_x = states["origin"].origin_x * s;
            opts.target.origin_y = states["origin"].origin_y * s;
        }
        states["current"].scale <- scale;
    }
}