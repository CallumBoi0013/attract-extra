fe.load_module("scenebuilder");
fe.load_module("animate2");

class UserConfig {
    </ label="BG Red", help="BG Red", options="250, 240, 230, 220, 210, 200, 190, 180, 170, 160, 150, 140, 130, 120, 110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0", order = 1 />
    bg_red = "30";
    </ label="BG Green", help="BG Green", options="250, 240, 230, 220, 210, 200, 190, 180, 170, 160, 150, 140, 130, 120, 110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0", order = 2 />
    bg_green = "200";
    </ label="BG Blue", help="BG Blue", options="250, 240, 230, 220, 210, 200, 190, 180, 170, 160, 150, 140, 130, 120, 110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0", order = 3 />
    bg_blue = "30";
}

local config = fe.get_config();
local bg_color = [ config.bg_red.tointeger(), config.bg_green.tointeger(), config.bg_blue.tointeger() ];

SceneBuilder.debug();

//Main screen
SceneBuilder
    .layout({ width = 1280, height = 720, font = "Keep Calm Med" })
    .shader("custom-shader", {
        shader = "crt-lottes",
        width = 570,
        height = 570,
        blackclip = 0.18,
        brightmult = 1.6,
        maskdark = 0.25,
        masklight = 0.08,
        saturation = 1.25,
        aperature = 2
    })
    .scene("main")
        .add("artwork", { label = "snap", index_offset = -1, x = 0, y = 158, width = 290, height = 290, shader = "custom-shader" })
        .add("artwork", { label = "snap", x = 330, y = 50, width = 640, height = 480, shader = "custom-shader" })
		.add("artwork", { label = "snap", index_offset = 1, x = 990, y = 158, width = 290, height = 290, shader = "custom-shader" })
        .add("image", { file_name = "bg-color.png", x = 0, y = 0, width = fe.layout.width, height = fe.layout.height, rgb = bg_color } )
        .add("text", { msg = "[Title]", x = 0, y = fe.layout.height - 78, width = fe.layout.width, height = 58, rgb = [ 20, 20, 20 ], charsize = 32 })
    .scene("info")
        .add_states({
            "hide": { alpha = 0 },
            "show": { alpha = 255 },
            "windowed": { x = 100, y = 100, width = 300, height = 300 },
            "full": { x = 0, y = 0, width = fe.layout.width, height = fe.layout.height }
        })
        .state("hide")
        .add("image", { file_name = "pixel.png", x = 0, y = 0, width = fe.layout.width, height = fe.layout.height, rgba = [ 0, 0, 0, 200] })
        .add("artwork", { label = "box", x = 10, y = fe.layout.height - 260, width = 310, height = 260, preserve_aspect_ratio = true })
        .add("text", { msg = "[Category]", x = 20, y = 20, width = 200, height = 20, charsize = 32, rgb = [ 240, 240, 240 ], align= Align.Left })
        .add("text", { msg = "[Players]", x = 20, y = 40, width = 200, height = 20, charsize = 32, rgb = [ 240, 240, 240 ], align= Align.Left })
        .add("text", { msg = "[Manufacturer]", x = 20, y = 60, width = 200, height = 20, charsize = 32, rgb = [ 240, 240, 240 ], align= Align.Left })
        .add("text", { msg = "[Year]", x = 20, y = 80, width = 200, height = 20, charsize = 32, rgb = [ 240, 240, 240 ], align= Align.Left })
        .add("text", { msg = "[Emulator]", x = 20, y = 100, width = 200, height = 20, charsize = 32, rgb = [ 240, 240, 240 ], align= Align.Left })
        .add("text", { msg = "[CloneOf]", x = 20, y = 120, width = 200, height = 20, charsize = 32, rgb = [ 240, 240, 240 ], align= Align.Left })
		
SceneBuilder
    .on({
        "toggle-info": function() {
            local info = SceneBuilder.find("info");
            if ( info.currentState == "hide" ) info.state("show"); else info.state("hide");
        },
        "choose-scene": function() {
            local scenes = ["demo", "basic"];
            local selected = fe.overlay.list_dialog(scenes, "Choose a Scene", 0, -1);
            if ( selected != -1 ) SceneBuilder.trigger("switch-scene", scenes[selected]);
        },
        "switch-scene": function(name) {
            //hides all scenes except requested one
            for ( local i = 0; i < SceneBuilder.scenes.len(); i++ )
                SceneBuilder.scenes[i].ref.alpha = ( SceneBuilder.scenes[i].name == name ) ? 255 : 0;
        }
    })
    .on("signal", function(str) {
        //capture key to show/hide scene
        if ( str == "custom2" ) {
            SceneBuilder.trigger("toggle-info");
            return true;
        }
        if ( str == "custom3" ) {
            SceneBuilder.trigger("choose-scene");
            return true;
        }
        if ( str == "custom1" ) {
            ::fe.signal("reload");
            return true;
        }
        return false;
    })