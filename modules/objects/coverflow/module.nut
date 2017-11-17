class CoverFlow {
    slots = null;
    reflections = null;
    opts = null;
	lastaction = null;

    constructor(art, x, y, w, h) {
        opts = {
            art = art,
            x = x,
            y = y,
            width = w,
            height = h,
            selected = 0,
            selected_width = 0.25,
            selected_height = 1.25,
            selected_yoffset = 0,
            unselected_yoffset = 0.4,
            unselected_height = 0.6,
            count = 5,
            preserve_aspect_ratio = true,
            pad = 10
        }

        slots = create_slots();
        reflections = [];
        

        //fe.add_transition_callback(this, "on_transition" );
        fe.add_signal_handler(this, "on_signal");
    }

    function create_slots() {
        local slots = [];
        //width = ( opts.width / opts.count ) - (opts.pad * opts.count);
        opts.selected = floor(opts.count / 2) + 1;

        local totalW = opts.width - ( opts.pad * 2 );
        local totalH = opts.height - ( opts.pad * 2 );
        local selectedY = opts.y + ( opts.pad + totalH * -opts.selected_yoffset ) * 1;
        local selectedW = totalW * opts.selected_width + (opts.pad / 2);
        local selectedH = totalH * opts.selected_height - opts.pad;
        local unselectedY = y + ( opts.pad + totalH * opts.unselected_yoffset ) * 1;
        local unselectedW = totalW / opts.count * ( 1 - opts.selected_width ) + opts.pad;
        local unselectedH = totalH * opts.unselected_height - opts.pad;
        local cfX = x - unselectedW - opts.pad;

        //create art slots, animations and set props for each slot
        for( local i = 0; i < opts.count + 2; i++) {
            local itemX = cfX + opts.pad;
            local itemY = ( i == opts.selected ) ? selectedY : unselectedY;
            local itemW = ( i == opts.selected ) ? selectedW : unselectedW;
            local itemH = ( i == opts.selected ) ? selectedH : unselectedH;
            slots.push( CoverFlowArt(opts.art) );
            slots[i].props({
                x = itemX,
                y = itemY,
                width = itemW,
                height = itemH,
                pinch_y = ( i < opts.selected ) ? 20 : ( i == opts.selected ) ? 0 : -20,
                alpha = ( i == 0 || i == opts.count + 1 ) ? 0 : 255,
            });
            slots[i].ref.preserve_aspect_ratio = opts.preserve_aspect_ratio;
            slots[i].ref.index_offset = -opts.selected + i;
			slots[i].index_offset = -opts.selected + i;
			slots[i].slotnumber = i;
            cfX = itemX + itemW;
        }
        return slots;
    }

    function on_signal(str) {
        if ( str == "prev_game" ) {
            backwards();
			if (lastaction ==str)	{fe.list.index++}
			lastaction = str;
            return true;
        } else if ( str == "next_game" ) {
            forwards();
			if (lastaction ==str)	{fe.list.index--}
            lastaction = str;
			return true;
        }
        return false;
    }

    function on_transition( ttype, var, ttime ) {
        if ( ttype == Transition.StartLayout ) {

        } else if ( ttype == Transition.FromOldSelection ) {
            if ( var > 0 ) forwards(); else backwards();
        }
        return false;
    }

    function backwards() {
        print("backwards\n");
        for ( local i = 0; i < slots.len(); i++ ) {
            local toIndex = ( i > 0 ) ? i - 1 : slots.len() - 1;
			local fromIndex = ( i  > 0 ) ? i - 1 : slots.len() - 1;
            slots[i].animate( slots[toIndex]._props, slots[toIndex].ref );
        }
    }

    function forwards() {
        print("forwards\n");
        for ( local i = 0; i < slots.len(); i++ ) {
            local toIndex = ( i < slots.len() - 1 ) ? i + 1 : 0;
			local fromIndex = ( i+1 < slots.len() - 1 ) ? i + 1 : 0;
            slots[i].animate( slots[toIndex]._props, slots[toIndex].ref );
        }
    }
}

class CoverFlowArt {
    ref = null;
    reflection = null;
    anim = null;
    _props = null;
    index_offset = null;
	newref = null;	
	slotnumber=null;
    constructor(art) {
        ref = fe.add_artwork(art, -1, -1, 1, 1);
        reflection = fe.add_clone(ref);
        reflection.subimg_x = -1;
    }

    function props(props) {
        this._props = props;
        set_props(props);
        reflection.y = props.y + props.height;
    }
	
	function reset_index(blah)
	{
		if (slotnumber==3) {print("Slot:"+ slotnumber +" REFINDEX:"+ ref.x + " INDEX SETTING IN SLOT"+ index_offset+"\n")};
		
//		ref.swap(newref);
//		ref.rawset_index_offset(index_offset)
		return;
	}

    function animate(to, toref) {
		newref = toref;
		anim = PropertyAnimation(ref).from(_props)
		.to(to)
        .easing("ease")
        .speed(2)
//		.on("start", this, "reset_index" )
//		.debug(true)
		.play();
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

class Gallery extends CoverFlow {
    constructor(art) {
        fe.layout.width = 1920;
        fe.layout.height = 1080;
        base.constructor(art, 0, 0, fe.layout.width, fe.layout.height);
    }

    function create_slots() {
        local slots = [];
        for ( local i = 0; i < 15; i++)
            slots.push( CoverFlowArt(opts.art) );
        
        slots[0].props({ x = 150, y = 50, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        slots[1].props({ x = 470, y = 50, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        slots[2].props({ x = 790, y = 50, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        slots[3].props({ x = 1110, y = 50, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        slots[4].props({ x = 1430, y = 50, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        
        slots[5].props({ x = 150, y = 370, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        slots[6].props({ x = 470, y = 370, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        slots[7].props({ x = 770, y = 350, width = 340, height = 340, rgb = [ 255, 255, 255, 255 ] });
        slots[8].props({ x = 1110, y = 370, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        slots[9].props({ x = 1430, y = 370, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });

        slots[10].props({ x = 150, y = 690, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        slots[11].props({ x = 470, y = 690, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        slots[12].props({ x = 790, y = 690, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        slots[13].props({ x = 1110, y = 690, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        slots[14].props({ x = 1430, y = 690, width = 280, height = 280, rgb = [ 30, 30, 30, 225 ] });
        opts.selected = 7;

        for ( local i = 0; i < 15; i++) {
            slots[i].ref.index_offset = i - opts.selected;
            slots[i].ref.zorder = ( i == opts.selected ) ? 2 : 1;
            //if ( i != opts.selected ) slots[i].ref.set_rgb(30,30,30);
            //if ( i != opts.selected) slots[i].ref.alpha = 255;
        }
        return slots;
    }

    function animate(to, toref) {
		PropertyAnimation(ref).from(_props)
            .to(to)
            .easing("ease-in-back")
            .speed(0.25)
            .play();
    }

}
