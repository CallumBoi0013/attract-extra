//we will add some user config options
class UserConfig {
	</ label="Enable Debug", help="Enable/Disable debug info", options="Yes,No" />
	enable_debug="No";
	</ label="Enable Animations", help="Enable/Disable animations", options="Yes,No" />
	enable_anims="Yes";
	</ label="Enable Particles", help="Enable/Disable particle effects", options="Yes,No" />
	enable_particles="Yes";
}

local config = fe.get_config();

fe.load_module("extended/extended");
fe.load_module("extended/animate");
//we can add additional animation modules, we'll try the particules module
fe.load_module("extended/animations/particles/particles.nut");

ExtendedObjects.add_image("bg", "bg.png", 0, 0, fe.layout.width, fe.layout.height);
ExtendedObjects.get("bg").setPreserveAspectRatio(false);

//we're going to attach the particles animation to our background, but it will be on the front layer (surface)
if (config.enable_particles == "Yes") ExtendedObjects.get("bg").animate({ which = "particles", preset = "snow" } );


local title = ExtendedObjects.add_text("title", "[Title]", 0, 80, fe.layout.width / 2, 60);
    //property functions follow a setFunction or getFunction standard
    title.setColor(220, 220, 220);
    title.setCharSize(36);
    //ExtendedTexts and ExtendedImages can make use of a shadow
    title.setShadow(true);
    title.setShadowColor(240, 240, 20);
    title.setShadowAlpha(75);
    title.setShadowOffset(4);

local list = ExtendedObjects.add_listbox("list", fe.layout.width / 2, 0, fe.layout.width / 2, fe.layout.height);
    list.setCharSize(15);
    list.setStyle(Style.Bold);
    list.setColor(80, 80, 80);
    list.setSelectionColor(200, 200, 200);
    list.setSelectionBGColor(60, 60, 125);
    list.setSelectionBGAlpha(100);
    //you can set positions of objects by string names
    list.setPosition("offright");

local listAnim =    {
                        which = "property",
                        when = When.StartLayout,
                        property = "x",
                        delay = 750,
                        from = "offright",
                        to = "right"
                    }
if (config.enable_anims == "Yes") list.animate(listAnim) else list.setPosition("right");

local logo = ExtendedObjects.add_image("logo", "logo.png", 0, 0, 262, 72);
    logo.setPosition("top");

local logoAnim =  {
                        which = "translate",
                        when = When.StartLayout,
                        delay = 750,
                        duration = 1000,
                        from = "current",
                        to = "offtoprightx",
                        easing = "out",
                        tween = "bounce"
                    };
if (config.enable_anims == "Yes") logo.animate(logoAnim) else logo.setPosition("top");


local snap = ExtendedObjects.add_artwork("snap", "snap", 100, 100, 480, 360);
    snap.setPosition( [ 100, (fe.layout.height / 2) - 180 ]);
    snap.setShadow(false);

//You can use some predefined animation sets (a group of animations)
if (config.enable_anims == "Yes") snap.animate_set("fade_in_out" );

                    
local marquee = ExtendedObjects.add_artwork("marquee", "marquee", 0, 0, 500, 156);
    marquee.setPosition("offleft");

//You can delay animations to get a step1, step2 approach
//step 1: move from offscreen left to center using the out/bounce tween
local marqueeAnim1 =  {
                        which = "translate",
                        when = When.ToNewSelection,
                        wait = false,
                        duration = 750,
                        from = "offleft",
                        to = "center",
                        easing = "out",
                        tween = "bounce"
                    };
//step 2: move from center position to bottom after a delay using the out/bounce tween
local marqueeAnim2 =  {
                        which = "translate",
                        when = When.FromOldSelection,
                        delay = 1000,
                        duration = 750,
                        from = "center",
                        to = "bottom",
                        easing = "out",
                        tween = "bounce"
                    };
if (config.enable_anims == "Yes") {
    marquee.animate(marqueeAnim1);
    marquee.animate(marqueeAnim2);
} else {
    marquee.setPosition("bottom");
}

//The debugger adds debug text ontop of every object, helpful for... debugging
if (config.enable_debug == "Yes") {
    local debug = ExtendedObjects.debugger();
    debug.setVisible(true);
}
