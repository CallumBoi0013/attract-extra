/**************************************
	Blueprint AM layout
	v1.0
	
    Notes:
        - requires:
            PreserveArt 1.1:
                https://github.com/liquid8d/attract-extra/blob/master/modules/preserve-art.nut
            PanAndScanArt:
                http://forum.attractmode.org/index.php?topic=624.0
            KeyboardSearch:
                https://github.com/liquid8d/attract-extra/tree/master/modules/objects/keyboard-search
    Fonts:
        https://www.fontsquirrel.com/fonts/bebas-neue
***************************************/
class UserConfig {
    </ label="Layout", help="The layout to use", options="16x10,10x16", order=1 />
    user_layout="16x10";
    </ label="Select Style", help="The style for the select screen", options="List", order=2 />
    user_style="List";
    </ label="Color Theme", help="The color theme to use", options="red,blue,green,purple,orange", order=3 />
    user_theme="blue";
    </ label="Info 1", help="Top Left Line 1", order=4 />
    user_info_one="[DisplayName] > [FilterName] [Search]";
    </ label="Info 2", help="Top Left Line 2", order=5 />
    user_info_two="[Date]";
    </ label="Info 3", help="Top Right Line 2", order=6 />
    user_info_three="[ListEntry] of [ListSize]";
    </ label="Info 4", help="Top Right Line 2", order=7 />
    user_info_four="[Time]";
    </ label="Info 5", help="Bottom Left Line 1", order=8 />
    user_info_five="[Year] [Manufacturer]";
    </ label="Info 6", help="Bottom Left Line 2", order=9 />
    user_info_six="[Players] [Category]";
    </ label="Info 7", help="Bottom Right", order=10 />
    user_info_seven="[FormattedPlayedTime]";
    </ label="Side Art", help="Art shown to the side on the selection screen", options="wheel,flyer,marquee,snap,logo,box,fanart", order=11 />
    user_side_art="wheel";
    </ label="Fan Art", help="Art shown behind the selection screen", options="wheel,flyer,marquee,snap,logo,box,fanart", order=12 />
    user_fan_art="fanart";
    </ label="Search Key", help="Choose the key to initiate a search", options="custom1,custom2,custom3,custom4,custom5,custom6,up,down,left,right", order=14 />
    user_search_key="custom1";
    </ label="Search Results", help="Choose the search method", options="show_results,next_match", order=15 />
    user_search_method="show_results";
    </ label="Attract Mode", help="Fade menu to attract mode after a delay", options="Yes,No", order=16 />
    user_attract_mode="Yes";
    </ label="12hr Clock", help="Use a 12hr clock instead of 24h", options="Yes,No", order=17 />
    user_clock_12hours="Yes";
}

local user_config = fe.get_config();
::layout <- user_config["user_layout"]
::theme <- user_config["user_theme"]

//store some values we use/update later
theme_values <- {
    formatted_time = "",
    formatted_date = "",
    formatted_played_time = 0,
    played_time = 0,
    last_time_reset = 0,
    search_text = ""
}

//use percentages
::per <- function(percent, val) {
    if ( percent == 0 ) return 0
    return ( percent / 100.0 ) * val.tofloat()
}

//set properties on an object
::setProps <- function(target, props) {
    foreach( key, val in props )
        try {
            target[key] = val
        } catch(e) { "error setting property: " + key }
}

//provide a XXhXXmXXs display of played time
::played_time <- function(time) {
	//return time
    time = replace(time, " minutes", "").tointeger()
    local totalSecs = time
    local hours = totalSecs / 3600
    hours = ( hours > 0 ) ? hours.tostring() + "h" : ""
    local minutes = (totalSecs % 3600) / 60
    minutes = ( minutes > 0 ) ? minutes.tostring() + "m" : ""
    local seconds = totalSecs % 60
    seconds = ( seconds > 0 ) ? seconds.tostring() + "s" : ""
    return hours + minutes + seconds
}

//replace text within text
::replace <- function(string, original, replacement) {
    //allows you to replace text in a string
    local expression = regexp(original)
    local result = ""
    local position = 0
    local captures = expression.capture(string)
    while (captures != null)
    {
    foreach (i, capture in captures)
    {
      result += string.slice(position, capture.begin)
      result += replacement
      position = capture.end
    }
    captures = expression.capture(string, position)
    }
    result += string.slice(position)
    return result
}

//replcae some custom magic tokens
function replaceMagicTokens(msg) {
    local tokens = {
        "\\[FormattedPlayedTime\\]": ( theme_values.formatted_played_time == "" ) ? "Not Played" : "Played for " + theme_values.formatted_played_time,
        "\\[Date\\]": theme_values.formatted_date,
        "\\[Time\\]": theme_values.formatted_time,
        "\\[Search\\]": ( theme_values.search_text == "" ) ? "" : "(Search: " + theme_values.search_text + ")"
    }
    foreach( key, val in tokens )
        msg = replace(msg, key, val)
        //print(key + ": " + val + "\n")
    return msg
}

//load modules we use
//fe.load_module("objects/wheel")
fe.load_module("animate")
fe.load_module("preserve-art")
fe.load_module("pan-and-scan")
fe.load_module("objects/keyboard-search")

fe.do_nut("themes.nut")
fe.do_nut("config.nut")

///////////////////////////
// Attract Surface
//////////////////////////

//create objects and set their properties
local artwork = fe.add_artwork("snap", -1, -1, 1, 1)
    setProps(artwork, config[layout].artwork)
    artwork.video_flags = Vid.NoAudio
///////////////////////////
// Main Surface
//////////////////////////
local main_surface = fe.add_surface(fe.layout.width, fe.layout.height)

//use PanAndScanArt
//PreserveArt
local fan_art = PreserveArt( "fanart", 0, 0, fe.layout.width, fe.layout.height, main_surface );
    //setProps(fan_art.surface, config[layout].fan_art)
fan_art.set_fit_or_fill( "fill" );  // fit, fill or stretch
fan_art.set_anchor( ::Anchor.Center ); // Top, Left, Center, Centre, Right, Bottom
//fan_art.set_zoom(1.25, 0.00008)
//fan_art.set_animate(::AnimateType.HorizBounce, 0.07, 0.07)
//fan_art.set_randomize_on_transition(false)
//fan_art.set_start_scale(1.25)

local background = main_surface.add_image("images/pixel.png", -1, -1, 1, 1)
    setProps(background, config[layout].background)

local fade_top = main_surface.add_image("images/fade-top.png", -1, -1, 1, 1)
    setProps(fade_top, config[layout].fade_top)
local fade_bottom = main_surface.add_image("images/fade-bottom.png", -1, -1, 1, 1)
    setProps(fade_bottom, config[layout].fade_bottom)
local infobar = main_surface.add_image("images/pixel.png", -1, -1, 1, 1)
    setProps(infobar, config[layout].infobar)

local info_line = main_surface.add_image("images/pixel.png", -1, -1, 1, 1)
    setProps(info_line, config[layout].info_line)
local info_one = main_surface.add_text("", -1, -1, 1, 1)
    setProps(info_one, config[layout].info_one)
local info_two = main_surface.add_text("", -1, -1, 1, 1)
    setProps(info_two, config[layout].info_two)
local info_three = main_surface.add_text("", -1, -1, 1, 1)
    setProps(info_three, config[layout].info_three)
local info_four = main_surface.add_text("", -1, -1, 1, 1)
    setProps(info_four, config[layout].info_four)
local info_five = main_surface.add_text("", -1, -1, 1, 1)
    setProps(info_five, config[layout].info_five)
local info_six = main_surface.add_text("", -1, -1, 1, 1)
    setProps(info_six, config[layout].info_six)
local info_seven = main_surface.add_text("", -1, -1, 1, 1)
    setProps(info_seven, config[layout].info_seven)

local list = main_surface.add_listbox(-1, -1, 1, 1)
    setProps(list, config[layout].list)
local side_art = main_surface.add_artwork("wheel", -1, -1, 1, 1)
    setProps(side_art, config[layout].side_art)

///////////////////////////
// Select Surface
//////////////////////////

local select_surface = fe.add_surface(fe.layout.width, fe.layout.height)
    select_surface.alpha = 0

local select_bg = select_surface.add_image("images/pixel.png", -1, -1, 1, 1)
    setProps(select_bg, config[layout].select_bg)
local select_overlay = select_surface.add_image("images/pixel.png", -1, -1, 1, 1)
    setProps(select_overlay, config[layout].select_overlay)
//add the wheel
//local wheel = Wheel(select_surface, config[layout].wheel)
local flyer = select_surface.add_artwork("flyer", -1, -1, 1, 1)
    setProps(flyer, config[layout].flyer)

///////////////////////////
// Search Overlay
//////////////////////////

//Setup search surface and KeyboardSearch module
local search_surface = main_surface.add_surface( config[layout].search.width, config[layout].search.height)
    search_surface.x = config[layout].search.x
    search_surface.y = config[layout].search.y
local search = KeyboardSearch( search_surface )
    .search_key( user_config["user_search_key"] )
    .mode( user_config["user_search_method"] )
    .bg_color( config[layout].search.bg_red, config[layout].search.bg_green, config[layout].search.bg_blue, config[layout].search.bg_alpha )
    .keys_pos( config[layout].search.key_pos )
    .keys_color( config[layout].search.red, config[layout].search.green, config[layout].search.blue, config[layout].search.alpha )
    .keys_selected_color( config[layout].search.sel_red, config[layout].search.sel_green, config[layout].search.sel_blue, config[layout].search.sel_alpha )
    .text_pos( config[layout].search.text_pos )
    .text_font( config[layout].search.font )
    .text_color( config[layout].search.sel_red, config[layout].search.sel_green, config[layout].search.sel_blue, config[layout].search.sel_alpha )
    .init()

///////////////////////////
// Displays Overlay
//////////////////////////
local system_select_surface = fe.add_surface( fe.layout.width, fe.layout.height )
system_select_surface.alpha = 0
local system_title = system_select_surface.add_text("System select", 0, 0, fe.layout.width, 20)
local system_listbox = system_select_surface.add_listbox(50,50,300,500)
//fe.overlay.set_custom_controls( "system select", system_listbox );
/*
local system_bg = system_select_surface.add_image("images/pixel.png", 0, 0, system_select_surface.width, system_select_surface.height)
    setProps(system_bg, config[layout].system_bg)
local system_menu_bg = system_select_surface.add_image("images/pixel.png", -1, -1, 1, 1)
    setProps(system_menu_bg, config[layout].system_menu_bg)
local system_title = system_select_surface.add_text("", -1, -1, 1, 1)
    setProps(system_title, config[layout].system_title)
local system_breadcrumb = system_select_surface.add_text("", -1, -1, 1, 1)
    setProps(system_breadcrumb, config[layout].system_breadcrumb)
local system_most_played = system_select_surface.add_text("", -1, -1, 1, 1)
    setProps(system_most_played, config[layout].system_most_played)
local system_most_played_1 = system_select_surface.add_artwork("", -1, -1, 1, 1)
    setProps(system_most_played_1, config[layout].system_most_played_1)
local system_most_played_2 = system_select_surface.add_artwork("", -1, -1, 1, 1)
    setProps(system_most_played_2, config[layout].system_most_played_2)
local system_last_played = system_select_surface.add_text("", -1, -1, 1, 1)
    setProps(system_last_played, config[layout].system_last_played)
local system_last_played_1 = system_select_surface.add_artwork("", -1, -1, 1, 1)
    setProps(system_last_played_1, config[layout].system_last_played_1)
local system_last_played_2 = system_select_surface.add_artwork("", -1, -1, 1, 1)
    setProps(system_last_played_2, config[layout].system_last_played_2)
*/

local displays = []
foreach( item in fe.displays )
    displays.push(item.name)

/*
local list = CustomList( system_select_surface, displays, {
    x = config[layout].system_list.x,
    y = config[layout].system_list.y,
    width = config[layout].system_list.width,
    height = config[layout].system_list.height,
    items = [],
    max_items = config[layout].system_list.slots,
    select_handler = null,
    change_handler = null,
    orientation = "vertical",
    next = "next_page",
    prev = "prev_page",
    select = "select",
    text = {
        rgba = [ 0, 255, 255, 255 ]
    },
    selected = {
        rgba = [ 255, 0, 0, 255 ]
    }
})
local on_change = function(index, item) {
    list.print("on_change " + index + " " + item )
}
local on_select = function(index, item) {
    fe.set_display(index)
}
list.set_change_handler(on_change)
list.set_select_handler(on_select)
list.set_selected(fe.list.display_index)
*/

///////////////////////////
// Misc
//////////////////////////

//can only pull most_played for current list
function most_played() {
    local most = []
    for ( local i = 0; i < fe.list.size; i++ )
        most.push( { index = i, title = fe.game_info(Info.Title, i) count = fe.game_info(Info.PlayedCount, i) } )
    most.sort(function(a, b) {
        return ( a.count > b.count ) ? -1 : ( a.count < b.count ) ? 1 : 0
    })
    return most
}
local most = most_played()

//for ( local i = 0; i < most.len(); i++ )
//    print( most[i].title + ": " + most[i].count + "\n")

///////////////////////////
// Handlers
//////////////////////////

function on_transition( ttype, var, ttime) {
    if ( ttype == Transition.StartLayout || ttype == Transition.FromOldSelection || ttype == Transition.ToNewList ) {
        if ( user_config["user_attract_mode"] == "Yes" ) {
            animation.add(PropertyAnimation( main_surface, { property = "alpha", start = 255, end = 255, when = When.Always }))
            animation.add(PropertyAnimation( main_surface, { property = "alpha", start = 255, end = 0, delay = 7000, when = When.Always }))
        }

        //update values
        theme_values.last_time_reset = fe.layout.time
        theme_values.played_time = fe.game_info(Info.PlayedTime)
        print("played time: " + theme_values.played_time + "\n")
        theme_values.formatted_played_time = played_time(fe.game_info(Info.PlayedTime))
        
        //we have to manually update artwork's dynamic file_name
        side_art.file_name = fe.get_art(user_config["user_side_art"])
        fan_art.art.file_name = fe.get_art(user_config["user_fan_art"])
        //flyer.file_name = fe.get_art(config[layout].flyer.art)
        //system_most_played_1.file_name = fe.get_art(config[layout].system_most_played_1.art, most[0].index)
        //system_most_played_2.file_name = fe.get_art(config[layout].system_most_played_2.art, most[1].index)
        //system_last_played_1.file_name = fe.get_art(config[layout].system_last_played_1.art)
        //system_last_played_2.file_name = fe.get_art(config[layout].system_last_played_2.art)
        
        //update the wheel and system list
        /*
        local current = ceil(config[layout].wheel.slots / 2)
        local scale = 2
        local transform = {
            width = config[layout].wheel.slot_width * scale,
            height = config[layout].wheel.slot_height * scale,
        }
        if ( user_config["user_highlight_current"] == "Yes") {
            foreach( index, slot in wheel.slots )
                if ( index == current ) {
                    slot.alpha = 255
                } else {
                    slot.alpha = 75
                }
        }
        */
    }
    
    //show overlays
    if (ttype == Transition.ShowOverlay )
        switch(var) {
            case Overlay.Displays:
                //fe.overlay = system_select_surface
                //system_select_surface.alpha = 255
        }
    
    //hide overlays
    if (ttype == Transition.HideOverlay) {
        switch(var) {
            case Overlay.Displays:
                //system_select_surface.alpha = 0
                //main_surface.alpha = 255
        }
    }
    
    theme_values.search_text = search.get_text()
    info_one.msg = replaceMagicTokens(user_config["user_info_one"])
    info_two.msg = replaceMagicTokens(user_config["user_info_two"])
    info_three.msg = replaceMagicTokens(user_config["user_info_three"])
    info_four.msg = replaceMagicTokens(user_config["user_info_four"])
    info_five.msg = replaceMagicTokens(user_config["user_info_five"])
    info_six.msg = replaceMagicTokens(user_config["user_info_six"])
    info_seven.msg = replaceMagicTokens(user_config["user_info_seven"])
    
    return false
}

//for debugging
function on_signal(str) {
    //let the system select custom list catch the signals
    switch( str ) {
        case "custom1":
            ::fe.signal("reload")
            return true
    }
    return false
}

//setup clock
function on_tick(tick_time) {
    
    //refresh date and time
    local days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    local months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    local ttime = date()
    
    local hours = ttime.hour
    if ( user_config["user_clock_12hours"] == "Yes" ) {
        local mar = "am"
        if ( hours > 12 ) {
            hours -= 12
            mar = "pm"
        }
        if ( hours == 0 ) {
            hours = 12
            mar = "am"
        }
        theme_values.formatted_time = format("%01d:%02d%s", hours, ttime.min, mar)
    } else {
        theme_values.formatted_time = format("%02d:%02d", ttime.hour, ttime.min)
    }
    theme_values.formatted_date = format("%s, %s %02d, %04d", days[ttime.wday], months[ttime.month], ttime.day, ttime.year)
    
}

fe.add_transition_callback(this, "on_transition")
fe.add_ticks_callback("on_tick")
fe.add_signal_handler(this, "on_signal")
