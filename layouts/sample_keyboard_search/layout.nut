class UserConfig {
    </ label="Search Key", help="Choose the key to initiate a search", options="custom1,custom2,custom3,custom4,custom5,custom6,up,down,left,right", order=14 />
    user_search_key="custom1";
    </ label="Search Results", help="Choose the search method", options="show_results,next_match", order=15 />
    user_search_method="show_results";
    </ label="Retain Search", help="Retain search when search is toggled back on", options="true,false", order=15 />
    user_search_retain="false";
}
local user_config = fe.get_config();

fe.load_module("objects/keyboard-search");

fe.add_listbox(fe.layout.width * 0.5, 0, fe.layout.width * 0.5, fe.layout.height);

local search_surface = fe.add_surface( fe.layout.width * 0.5, fe.layout.height );
search_surface.set_pos(0,0);
local keyboard = KeyboardSearch(search_surface)
    .search_key( user_config["user_search_key"] )
    .mode( user_config["user_search_method"] )
    .retain( user_config["user_search_retain"] )
    .bg_color( 30, 30, 30, 200 )
    //keys x/y/w/h ( in search surface percentages )
    .keys_pos([ 0.05, 0.4, 0.9, 0.5 ])
    //keys options
    .keys_image_folder(null) //no folder uses text instead of images
    .keys_color( 0, 150, 50 )
    .keys_selected_color( 240, 240, 240 )
    .keys_font("BebasNeue Bold")
    .keys_charsize(64)
    //text options
    .text_pos([ 0.05,  0.2, 0.9, 0.1 ]) //search text x/y/w/h ( in search surface percentages )
    .text_font("BebasNeue Bold")
    .text_color( 200, 200, 0 )
    .init()

//keyboard.search_text.set_pos(20, 20, search_surface.width - 20, 40);

fe.add_signal_handler(this, "on_signal");
function on_signal(str) {
    if ( str == "custom1" ) {
        fe.signal("reload");
        return true;
    }
    return false;
}