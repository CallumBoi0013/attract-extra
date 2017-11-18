///////////////////////////////////////////////////
//
// Attract-Mode Frontend - Magic Images plugin
// by: liquid8d
// version: 1.0
//
//  DESC:
//  use premade magic image functions to add images for # of players, genre, region, esrb and system
// 
//  USAGE:
//      Add the magic-images.nut and images folder into your layout
//
//      fe.do_nut("magic-images.nut");
//      fe.add_image("[!TYPE_image]", 0, 0, 100, 100) //where type is one of: players, genre, region, esrb or system
//
//  NOTES:
//  ESRB and REGION uses TAGS! You must tag your games for them to show up
//  Filenames are expected to be in images/TYPE/ with the extension specified in the magic_image_settings variable
//  The supported filenames are the 'key' in the supported table for each function
//  The names that will match the filename are in the array of the supported table for each function
//
///////////////////////////////////////////////////

::magic_image_settings <- {
    players = { path = "images/players/", ext = ".png" },
    genre = { path = "images/genre/", ext = ".png", mode = 0 } // modes: 0 = first match, 1 = last match, 2 = random,
    region = { path = "images/region/", ext = ".png" },
    esrb = { path = "images/esrb/", ext = ".png" },
    system = { path = "images/system/", ext = ".png" },
}

//return file_name for system
function system_image( offset ) {
    local supported = {
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
   }
   local displayName = fe.displays[fe.list.display_index].name.tolower()
   local matches = []
   foreach( key, val in supported )
      foreach( nickname in val )
        if ( matches.find(key) == null && displayName.tolower() == nickname ) matches.push(key)
   if ( matches.len() > 0 )
     return magic_image_settings.system.path + matches[0] + magic_image_settings.system.ext
   return magic_image_settings.system.path + "unknown" + magic_image_settings.system.ext
}

//return file_name for esrb
function esrb_image( offset ) {
   local supported = [ "esrb-c", "esrb-e", "esrb-e10", "esrb-t", "esrb-m", "esrb-a", "esrb-rp", "unknown" ]
   local tags = fe.game_info(Info.Tags, offset).tolower()
   local index = supported.find("unknown")
   foreach( item in supported )
      if ( tags.find(item) != null ) index = supported.find(item)
   return magic_image_settings.esrb.path + supported[index] + magic_image_settings.esrb.ext
}

//return file_name for region
function region_image( offset ) {
   local supported = [ "usa", "japan", "brazil", "asia", "spain", "europe", "world", "unknown" ]
   local tags = fe.game_info(Info.Tags, offset).tolower()
   local index = supported.find("unknown")
   foreach( item in supported )
      if ( tags.find(item) != null ) index = supported.find(item)
   return magic_image_settings.region.path + supported[index] + magic_image_settings.region.ext
}

//return file_name for genre
function genre_image( offset) {
   local supported = {
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
   }
   local cat = " " + fe.game_info(Info.Category, offset).tolower()
   local matches = []
   foreach( key, val in supported )
      foreach( nickname in val )
         if ( cat.find(nickname, 0) ) matches.push(key)
   if ( matches.len() > 0 ) {
      if ( magic_image_settings.genre.mode == 0 ) {
         return magic_image_settings.genre.path + matches[0] + magic_image_settings.genre.ext
      } else if ( magic_image_settings.genre.mode == 1 ) {
         return magic_image_settings.genre.path + matches[matches.len() - 1] + magic_image_settings.genre.ext
      } else if ( magic_image_settings.genre.mode == 2 ) {
         local random_num = floor(((rand() % 1000 ) / 1000.0) * ((matches.len() - 1) - (0 - 1)) + 0)
         return magic_image_settings.genre.path + matches[random_num] + magic_image_settings.genre.ext
      }
   }
   return magic_image_settings.genre.path + "unknown" + magic_image_settings.genre.ext
}

//return file_name for players
function players_image( offset ) {
   local info = fe.game_info( Info.Players, offset ).tolower()
   if ( info.len() >= 1 ) return magic_image_settings.players.path + info.slice(0, 1) + magic_image_settings.players.ext
   return magic_image_settings.players.path + "unknown" + magic_image_settings.players.ext
}
