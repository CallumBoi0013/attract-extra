function set(obj, state) { try { foreach( key, val in state ) obj[key] = val; } catch(e) {} }

class Gallery {
    art = "snap";
    ref = null;
    index = 0;
    layout = [
        { x = 50, y = 50, width = 275, height = 200 }
        { x = 350, y = 50, width = 275, height = 200 }
        { x = 650, y = 50, width = 275, height = 200 }
    ]

    constructor(art, x, y, w, h) {
        this.art = art;
        ref = [];
        index = fe.list.index;
        local startIndex = index - floor(layout.len() / 2);
        for( local i = 0; i < layout.len(); i++ ) {
            ref.push( fe.add_image(fe.get_art(art, startIndex + i)) );
            set(ref[i], layout[i]);
        }
        fe.add_signal_handler(this, "on_signal");
        fe.add_transition_callback(this, "on_transition");
    }
    
    function update_index(movement) {
        index += movement;
        print("index: " + index + "\n");
        for( local i = 0; i < layout.len(); i++ ) {
            local offset = index + ( i - floor(layout.len() / 2));
            print( offset + ": " + fe.get_art(art, offset, fe.list.filter_index) + "\n" );
            ref[i].file_name = fe.get_art(art, offset, fe.list.filter_index);
        }
    }

    function on_transition( ttype, var, ttime ) {
        print("transition: " + ttype + "\n");
        if ( ttype == Transition.StartLayout || ttype == Transition.ToNewSelection ) {
            update_index(var);
            print(var + "\n");
        }
        return false;
    }

    function on_signal(str) {
        if ( str == "prev_game" ) {
            return false;
        } else if ( str == "next_game" ) {
            return false;
        } else if ( str == "custom1" ) {
            fe.signal("reload");
            return true;
        }
        return false;
    }
}
function get_list_index() { return fe.list.index; }
fe.add_text("[!get_list_index] [Title]", 0, 0, 200, 20);

Gallery( "box", 0, 0, 100, 100 );

