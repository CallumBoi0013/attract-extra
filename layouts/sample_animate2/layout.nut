fe.load_module("animate2");
fe.layout.width = 1280;
fe.layout.height = 720;

//NOTE: Each example makes use of resources/shared.nut which creates objects, objects are shown when needed
fe.do_nut( "resources/shared.nut");

try { local l = fe.nv.layout; } catch(e) { fe.nv.layout <- 0; }
try { local l = fe.nv.previous; } catch(e) { fe.nv.previous <- 0; }
local from = ( fe.nv.previous <= fe.nv.layout ) ? fe.nv.layout * 80 : (fe.nv.previous * 80) + 80
local to = (fe.nv.layout * 80) + 80;
PropertyAnimation(OBJECTS.tutorial_bar_progress).debug(false).key("width").from(from).to(to).speed(2).play();

local layouts = [
    "examples/intro.nut",
    "examples/property.nut",
    "examples/transform.nut",
    "examples/interpolate.nut",
    "examples/events.nut",
    "examples/sprite.nut",
    "examples/timeline.nut",
    "examples/states.nut",
    "examples/macro.nut",
    "examples/particle.nut",
    "practice.nut"
]

fe.do_nut( layouts[fe.nv.layout] );

function on_signal( str )
{
    if ( str == "custom1" ) {
        fe.signal("reload");
        return true;
    } else if ( str == "up" ) {
        fe.nv.previous = fe.nv.layout;
        fe.nv.layout <- ( fe.nv.layout == 0 ) ? layouts.len() - 1 : fe.nv.layout - 1;
        fe.signal("reload");
        return true;
    } else if ( str == "down" ) {
        fe.nv.previous = fe.nv.layout;
        fe.nv.layout <- ( fe.nv.layout == layouts.len() - 1 ) ? 0 : fe.nv.layout + 1;
        fe.signal("reload");
    } else if ( str == "left" ) {
        fe.signal("prev_game");
        return true;
    } else if ( str == "right" ) {
        fe.signal("next_game");
        return true;
    }
    return false;
}
fe.add_signal_handler( this, "on_signal");