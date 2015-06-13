///////////////////////////////////////////////////
//
// Attract-Mode Frontend - IntroVid plugin
//
// Allow you to specify a video to play when the frontend starts
// 
// You can set the filename, and whether or not to play the audio
// Any keypress will stop (hide) the intro
//
///////////////////////////////////////////////////

class UserConfig </ help="Play an intro video at frontend startup" /> {
	</ label="Filename", help="Filename of the video to load (No path will be your layout folder)", order=1 />
	filename="intro.mp4";
	</ label="Audio", help="Yes will play the audio, No will not", options="Yes,No", order=2 />
	audio="No";
}

fe.add_transition_callback("onTransition");
fe.add_ticks_callback("onTick");
fe.add_signal_handler( "onSignal" );

local intro = null;
local config=fe.get_config();

function onTransition( ttype, var, ttime )
{
    if ( config["filename"] != "" && ttype == Transition.StartLayout && var == FromTo.Frontend )
    {
        intro = fe.add_image( config["filename"], 0, 0, fe.layout.width, fe.layout.height );
        intro.video_flags = ( config["audio"] == "Yes" ) ? Vid.NoLoop : Vid.NoLoop | Vid.NoAudio;
        return false;
    }
}

function onTick( ttime )
{
    if ( !intro.video_playing ) intro.visible = false;
}

function onSignal( signal_str )
{
    //Stop (well.. hide) video on input
    if ( intro.video_playing )
    {
        intro.video_flags = Vid.NoAudio;
        intro.visible = false;
        fe.remove_signal_handler("onSignal");
        return true;
    }
    return false;
}
