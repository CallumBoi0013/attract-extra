class CoverFlow {
    slots = null;
    props = null;
    anims = null;
    width = 0;
    selected = 0;
    constructor(art, x, y, w, h, count = 5, preserve = false, pad = 10) {
        anims = [];
        slots = [];
        props = [];
        width = ( w / count ) - (pad * count);
        selected = floor(count / 2);
        //create art slots, animations and set props for each slot
        for( local i = 0; i < count; i++) {
            local obj = fe.add_artwork(art, -1, -1, 1, 1);
            slots.push( obj );
            anims.push( PropertyAnimation(obj) );
            props.push({
                x = x + ( width * i ) + ( pad * i ) + pad,
                y = y + pad,
                width = ( i == selected ) ? width * 1.5 : width,
                height = h - pad,
                preserve_aspect_ratio = preserve,
                index_offset = -selected + i,
                pinch_y = ( i < selected ) ? 20 : ( i == selected ) ? 0 : -20,
                zorder = ( i == selected ) ? 6 : 5,
                alpha = 255
            });
            set_props( slots[i], props[i] );
        }

        //static values for empty slots
        slots.insert( 0, fe.add_artwork(art, -1, -1, 1, 1) );
        slots.push( fe.add_artwork(art, -1, -1, 1, 1) );
        anims.insert( 0, PropertyAnimation(slots[0]));
        anims.push( PropertyAnimation(slots[slots.len() - 1]));
        props.insert( 0, { x = x - width, y = y, alpha = 0 } );
        props.push( { x = w + width, y = y, alpha = 0 } );
        set_props( slots[0], props[0] );
        set_props( slots[slots.len() - 1], props[ slots.len() - 1]);

        fe.add_transition_callback(this, "on_transition" );
    }

    function on_transition( ttype, var, ttime ) {
        if ( ttype == Transition.FromOldSelection )
            if ( var > 0 ) next(); else prev();
        return false;
    }

    function prev() {
        for ( local i = 1; i < anims.len() - 1; i++ )
            //if ( i > 0 ) print("animate: " + i + "\n" );
            try {
                if ( i > 0 ) anims[i].from( props[i] ).to( props[i - 1] ).play();
            } catch(e) { print( "anim error: " + e + "\n")}
    }

    function next() {
        for ( local i = 1; i < anims.len() - 1; i++ )
            //if ( i < anims.len() - 1 ) print("animate: " + i + "\n" );
            try {
                if ( i < anims.len() - 1 ) anims[i].from( props[i] ).to( props[i + 1] ).play();
            } catch(e) { print( "anim error: " + e + "\n") }
    }

    function set_props(obj, props) {
        foreach( key, val in props )
        try {
            if ( key == "rgb" ) {
                obj.set_rgb(val[0],val[1],val[2]);
                if ( val.len() > 3 ) obj.alpha = val[3];
            } else if ( key == "bg_rgb" ) {
                obj.set_bg_rgb(val[0],val[1],val[2]);
                if ( val.len() > 3 ) obj.bg_alpha = val[3];
            } else if ( key == "sel_rgb" ) {
                obj.set_sel_rgb(val[0],val[1],val[2]);
                if ( val.len() > 3 ) obj.sel_alpha = val[3];
            } else if ( key == "selbg_rgb" ) {
                obj.set_selbg_rgb(val[0],val[1],val[2]);
                if ( val.len() > 3 ) obj.selbg_alpha = val[3];
            } else {
                obj[key] = val;
            }
        } catch(e) { ::print("set_props error,  setting property: " + key + "\n") }
    }
}
