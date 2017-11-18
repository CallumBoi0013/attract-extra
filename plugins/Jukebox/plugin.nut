///////////////////////////////////////////////////
//
// Attract-Mode Frontend - Jukebox plugin
// by: liquid8d
// version: 1.0
//
//  DESC:
//  Play music in the background
// 
//  USAGE:
//  - Tab (AM Menu), Plugins, Jukebox
//  - Configure Path to Music
//  - Enable Plugin
//  - Esc, Esc to exit
//  - First load will generate the song list
//  - Additional runs will load the generated list, if available or will attempt to generate a new one
//
//  NOTES:
//  - MP3 or FLAC
//  - Expects PATH/ARTIST/ALBUM/SONG
// 
///////////////////////////////////////////////////
fe.load_module("file");

class UserConfig </ help="Play some music" /> {
	</ label="Path", help="Path to music", order=1 />
	path=@"";
	</ label="Toggle Playing", help="Toggle playing music", order=2 />
	key_toggle = "custom2";
	</ label="Next Track", help="Play next track", order=3 />
	key_next = "custom3";
	</ label="Previous Track", help="Play previous track", order=4 />
	key_prev = "custom4";
	</ label="Next Artist", help="Play next artist", order=5 />
	key_nextartist = "custom5";
	</ label="Next Album", help="Play next album", order=6 />
	key_nextalbum = "custom6";
}

local user_config = fe.get_config();
local songs = null;
local music = null;

try { local l = fe.nv.track; } catch(e) { fe.nv.track <- 0; }

function generatePlaylist() {
    print("GENERATING JUKEBOX PLAYLIST, PLEASE WAIT...\n");
    local file = WriteTextFile( FeConfigDirectory + "/plugins/Jukebox/jukebox.txt" );
    local path = user_config["path"];
    local dir1 = DirectoryListing(path).results;
    for ( local i = 0; i < dir1.len(); i++ ) {
        local folder1 = dir1[i].slice( path.len() + 1, dir1[i].len() );
        local dir2 = DirectoryListing(path + "/" + folder1).results;
        for ( local x = 0; x < dir2.len(); x++ ) {
            local folder2 = dir2[x].slice( (path + "/" + folder1).len() + 1, dir2[x].len() );
            local f = DirectoryListing( path + "/" + folder1 + "/" + folder2 ).results;
            for ( local y = 0; y < f.len(); y++ ) {
                if ( f[y].slice( f[y].len() - 4 ) == ".mp3" || f[y].slice( f[y].len() - 5 ) == ".flac" )
                    file.write_line(folder1 + ";" + folder2 + ";" + f[y] + "\n");
            }
        }
    }
}

function loadData() {
    try {
        local data = [];
        local f = ReadTextFile( FeConfigDirectory + "/plugins/Jukebox/jukebox.txt");
        if ( f._f != null ) {
            while ( !f.eos() ) {
                local line = f.read_line();
                if ( line.slice( line.len() - 4 ) == ".mp3" || line.slice( line.len() - 5 ) == ".flac" )
                    data.push( { artist = split(line, ";")[0], album = split(line, ";")[1], name = split(line, ";")[2] });
            }
            return data;
        }
    } catch(e) { print("error reading jukebox.txt: " + e + "\n"); }
    return null;
}

function play(track) {
    fe.nv.track = ( track > songs.len() - 1 ) ? 0 : track;
    music.file_name = replace( songs[fe.nv.track].name, "\\\\", "/");
    music.playing = true;
    local meta = {
        title = music.get_metadata("title"),
        artist = music.get_metadata("artist"),
        album = music.get_metadata("album"),
        genre = music.get_metadata("genre"),
        track = music.get_metadata("track"),
    }
    local artist = music.get_metadata("artist");
    local album = music.get_metadata("album");
    print(meta.title + "\n");
    print("Track " + meta.track + " from " +  meta.album + " by " + meta.artist + " (" + meta.genre + ")\n");
}

function next() {
    fe.nv.track <- ( fe.nv.track < songs.len() - 1 ) ? fe.nv.track + 1 : 0;
    play(fe.nv.track);
}

function nextArtist() {
    local current = songs[fe.nv.track].artist;
    for ( local i = fe.nv.track; i < songs.len(); i++ )
        if ( songs[i].artist != current ) {
            fe.nv.track <- i;
            play(fe.nv.track);
            return;
        }
    fe.nv.track <- 0;
    play(fe.nv.track);
}

function nextAlbum() {
    local current = songs[fe.nv.track].album;
    for ( local i = fe.nv.track; i < songs.len(); i++ )
        if ( songs[i].album != current ) {
            fe.nv.track <- i;
            play(fe.nv.track);
            return;
        }
    fe.nv.track <- 0;
    play(fe.nv.track);
}

function previous() {
    fe.nv.track = ( fe.nv.track > 0 ) ? fe.nv.track - 1 : songs.len() - 1;
    play(fe.nv.track);
}

function toggleMusic() {
    music.playing = !music.playing;
}

function replace(string, original, replacement) {
    //allows you to replace text in a string
    local expression = regexp(original);
    local result = "";
    local position = 0;
    local captures = expression.capture(string);
    while (captures != null)
    {
    foreach (i, capture in captures)
    {
        result += string.slice(position, capture.begin);
        result += replacement;
        position = capture.end;
    }
    captures = expression.capture(string, position);
    }
    result += string.slice(position);
    return result;
}

print("LOADING JUKEBOX\n");

//load jukebox data
songs = loadData();
if ( songs == null) {
    //generate list if it doesnt exist
    generatePlaylist();
    songs = loadData();
}

if ( songs != null ) {
    music = fe.add_sound( FeConfigDirectory + "/plugins/Jukebox/empty.mp3" );
    play(fe.nv.track);
} else {
    print("Error loading Jukebox.. do you have the music path setup?\n");
}

fe.add_signal_handler("on_signal");
function on_signal(str) {
    if ( str == user_config["key_toggle"] ) {
        toggleMusic();
        return true;
    } else if ( str == user_config["key_next"] ) {
        next();
        return true;
    } else if ( str == user_config["key_prev"] ) {
        previous();
        return true;
    } else if ( str == user_config["key_nextartist"] ) {
        nextArtist();
        return true;
    } else if ( str == user_config["key_nextalbum"] ) {
        nextAlbum();
        return true;
    }
    return false;
}