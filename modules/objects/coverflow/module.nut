class CoverFlow {
    slots = null;
    props = null;
    width = 0;
    selected = 0;
    constructor(art, x, y, w, h, count = 5, preserve = false, pad = 10) {
        slots = [];
        props = [];
        width = ( w / count ) - (pad * count);
        selected = floor(count / 2) + 1;

        local SELECTED_WIDTH = 0.2;
        local SELECTED_HEIGHT = 1;
        local SELECTED_YOFFSET = 0;
        local UNSELECTED_YOFFSET = 0;
        local UNSELECTED_HEIGHT = 1;

        local totalW = w - ( pad * 2 );
        local totalH = h - ( pad * 2 );
        local selectedY = y + ( pad + totalH * -SELECTED_YOFFSET ) * 1;
        local selectedW = totalW * SELECTED_WIDTH + (pad / 2);
        local selectedH = totalH * SELECTED_HEIGHT - pad;
        local unselectedY = y + ( pad + totalH * UNSELECTED_YOFFSET ) * 1;
        local unselectedW = totalW / count * ( 1 - SELECTED_WIDTH ) + pad;
        local unselectedH = totalH * UNSELECTED_HEIGHT - pad;
        local cfX = x - unselectedW - pad;

        //create art slots, animations and set props for each slot
        for( local i = 0; i < count + 2; i++) {
            local itemX = cfX + pad;
            local itemY = ( i == selected ) ? selectedY : unselectedY;
            local itemW = ( i == selected ) ? selectedW : unselectedW;
            local itemH = ( i == selected ) ? selectedH : unselectedH;
            slots.push( CoverFlowArt(art) );
            slots[i].props({
                x = itemX,
                y = itemY,
                width = itemW,
                height = itemH,
                pinch_y = ( i < selected ) ? 20 : ( i == selected ) ? 0 : -20,
                alpha = ( i == 0 || i == count + 1 ) ? 0 : 255,
            });
            slots[i].ref.preserve_aspect_ratio = preserve;
            slots[i].ref.index_offset = -selected + i;
            cfX = itemX + itemW;
        }

        //fe.add_transition_callback(this, "on_transition" );
        fe.add_signal_handler(this, "on_signal");
    }

    function on_signal(str) {
        if ( str == "prev_game" ) {
            backwards();
            return true;
        } else if ( str == "next_game" ) {
            forwards();
            return true;
        }
        return false;
    }

    function on_transition( ttype, var, ttime ) {
        if ( ttype == Transition.StartLayout ) {

        } else if ( ttype == Transition.FromOldSelection ) {
            if ( var > 0 ) backwards(); else forwards();
        }
        return false;
    }

    function backwards() {
        print("backwards\n");
        for ( local i = 0; i < slots.len(); i++ ) {
            local toIndex = ( i > 0 ) ? i - 1 : slots.len() - 1;
            slots[i].animate( slots[toIndex]._props );
        }
    }

    function forwards() {
        print("forwards\n");
        for ( local i = 0; i < slots.len(); i++ ) {
            local toIndex = ( i < slots.len() - 1 ) ? i + 1 : 0;
            slots[i].animate( slots[toIndex]._props );
        }
    }
}

class CoverFlowArt {
    ref = null;
    //mirror = null;
    anim = null;
    _props = null;
    index_offset = 0;

    constructor(art) {
        ref = fe.add_artwork(art, -1, -1, 1, 1);
        //mirror = fe.add_clone(ref);
        //mirror.subimg_x = -1;
    }

    function props(props) {
        this._props = props;
        set_props(props);
        //mirror.y = props.y + props.height;
    }


    function animate(to) {
        anim = PropertyAnimation(ref).from(_props).to(to).play();
    }

    function set_props(props) {
        foreach( key, val in props )
        try {
            if ( key == "rgb" ) {
                ref.set_rgb(val[0],val[1],val[2]);
                if ( val.len() > 3 ) ref.alpha = val[3];
            } else {
                ref[key] = val;
            }
        } catch(e) { ::print("set_props error,  setting property: " + key + "\n") }
    }
}
