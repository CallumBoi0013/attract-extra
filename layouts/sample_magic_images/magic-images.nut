///////////////////////////////////////////////////
//
// Attract-Mode Frontend - Magic Images
// by: liquid8d
// version: 1.1
//
//  DESC:
//  use premade magic image functions in your layout to add images for # of players, genre, region, esrb and system
//
//  It does this by keeping a list of names (the filename it will load), along with what matches should display that image.
//  For example with genre, fighter.png will load from the /images/genre folder, when the category info matches fighting, fighter, or beat'em up
//
//  USAGE:
//      Add the magic-images.nut and images folder into your layout
//
//      fe.do_nut("magic-images.nut");
//      fe.add_image("[!TYPE_image]", 0, 0, 100, 100) //where type is one of: players, genre, region, esrb or system
//
//      You can add or override image paths, extensions or supported items as needed:
//      magic_image.genre.path = "my-images/genres"
//      magic_image.genre.ext = ".jpg"
//      magic_image.supported.genre.action.push("new-action-match");
//      magic_image.supported.genre.newgenre <- [ "match1", "match2" ];
//
//  NOTES:
//  ESRB and REGION uses TAGS! You must tag your games for them to show up
//  Filenames are expected to be in images/TYPE/ with the extension specified in the magic_image variable
//  The supported filenames are the 'key' in the supported table for each function
//  The names that will match the filename are in the array of the supported table for each function
//
///////////////////////////////////////////////////

::magic_image <- {
    players = { path = "images/players/", ext = ".png" },
    genre = { path = "images/genre/", ext = ".png", mode = 0 } // modes: 0 = first match, 1 = last match, 2 = random,
    region = { path = "images/region/", ext = ".png" },
    esrb = { path = "images/esrb/", ext = ".png" },
    system = { path = "images/system/", ext = ".png" },
    supported = {
        esrb = [ "esrb-c", "esrb-e", "esrb-e10", "esrb-t", "esrb-m", "esrb-a", "esrb-rp", "unknown" ],
        region = [ "usa", "japan", "brazil", "asia", "spain", "europe", "world", "unknown" ],
        genre = {
            //filename : [ match1, match2 ]
            "action": [ "action" ],
            "adventure": [ "adventure" ],
            "fighter": [ "fighting", "fighter", "beat'em up" ],
            "platformer": [ "platformer", "platform" ],
            "puzzle": [ "puzzle" ],
            "racing": [ "racing", "driving" ],
            "rpg": [ "rpg", "role playing", "role-playing", "role playing game" ],
            "shooter": [ "shooter", "shooter scrolling", "shmup" ],
            "sports": [ "sports", "boxing", "golf", "baseball", "football", "soccer" ],
            "strategy": [ "strategy"]
        },
        system = {
            "nes": [ "nes", "nintendo", "nintendo entertainment system", "famicom" ],
            "snes": [ "snes", "super nintendo", "super nintendo entertainment system", "super famicom" ],
            "n64": [ "n64", "nintendo 64" ],
            "gamecube": [ "gamecube", "nintendo gamecube", "gcn" ],
            "wii": [ "wii", "nintendo wii" ],
            "gameboy": [ "gameboy", "nintendo gameboy", "gb" ],
            "gba": [ "gba", "gameboy advance", "nintendo gameboy advance" ],
            "nds": [ "nds", "nintendo ds", "ds"],
            "master system": [ "master system", "msx", "sega master system" ],
            "genesis": [ "genesis", "sega genesis", "mega drive" ],
            "saturn": [ "saturn", "sega saturn" ],
            "dreamcast": [ "dreamcast", "sega dreamcast" ],
            "game gear": [ "game gear", "sega game gear" ],
            "playstation": [ "playstation", "sony playstation", "psx" ],
            "ps2": [ "ps2", "sony playstation 2" ],
            "psp": [ "psp", "sony psp", "sony playstation portable" ],
            "atari 2600": [ "atari 2600", "2600" ],
            "atari 7800": [ "atari 7800", "7800" ],
            "jaguar": [ "jaguar", "atari jaguar" ],
            "lynx":  [ "lynx", "atari lynx" ],
            "tg16": [ "tg16", "turbografx", "turbografx 16" ],
            "arcade": [ "arcade", "mame", "model2", "model3" ]
        },
    }
}

//return file_name for system
function system_image( offset ) {
   local displayName = fe.displays[fe.list.display_index].name.tolower()
   local matches = []
   foreach( key, val in magic_image.supported.system )
      foreach( nickname in val )
        if ( matches.find(key) == null && displayName.tolower() == nickname ) matches.push(key)
   if ( matches.len() > 0 )
     return magic_image.system.path + matches[0] + magic_image.system.ext
   return magic_image.system.path + "unknown" + magic_image.system.ext
}

//return file_name for esrb
function esrb_image( offset ) {
   local tags = fe.game_info(Info.Tags, offset).tolower()
   local index = magic_image.supported.esrb.find("unknown")
   foreach( item in magic_image.supported.esrb )
      if ( tags.find(item) != null ) index = magic_image.supported.esrb.find(item)
   return magic_image.esrb.path + magic_image.supported.esrb[index] + magic_image.esrb.ext
}

//return file_name for region
function region_image( offset ) {
   local tags = fe.game_info(Info.Tags, offset).tolower()
   local index = magic_image.supported.region.find("unknown")
   foreach( item in magic_image.supported.region )
      if ( tags.find(item) != null ) index = magic_image.supported.region.find(item)
   return magic_image.region.path + magic_image.supported.region[index] + magic_image.region.ext
}

//return file_name for genre
function genre_image( offset ) {
   local cat = " " + fe.game_info(Info.Category, offset).tolower()
   local matches = []
   foreach( key, val in magic_image.supported.genre )
      foreach( nickname in val )
         if ( cat.find(nickname, 0) ) matches.push(key)
   if ( matches.len() > 0 ) {
      if ( magic_image.genre.mode == 0 ) {
         return magic_image.genre.path + matches[0] + magic_image.genre.ext
      } else if ( magic_image.genre.mode == 1 ) {
         return magic_image.genre.path + matches[matches.len() - 1] + magic_image.genre.ext
      } else if ( magic_image.genre.mode == 2 ) {
         local random_num = floor(((rand() % 1000 ) / 1000.0) * ((matches.len() - 1) - (0 - 1)) + 0)
         return magic_image.genre.path + matches[random_num] + magic_image.genre.ext
      }
   }
   return magic_image.genre.path + "unknown" + magic_image.genre.ext
}

//return file_name for players
function players_image( offset ) {
   local info = fe.game_info( Info.Players, offset ).tolower()
   if ( info.len() >= 1 ) return magic_image.players.path + info.slice(0, 1) + magic_image.players.ext
   return magic_image.players.path + "unknown" + magic_image.players.ext
}
