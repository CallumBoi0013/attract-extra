class UserConfig {
	</ label="Enable Debug", help="Enable/Disable debug info", options="Yes,No" />
	enable_debug="No";
	</ label="Enable Animations", help="Enable/Disable animations", options="Yes,No" />
	enable_anims="Yes";
	</ label="Enable Particles", help="Enable/Disable particle effects", options="Yes,No" />
	enable_particles="Yes";
}

local config = fe.get_config();

//load required files
fe.do_nut("extended/extended.nut");
//animate is only required if you want to use animations
fe.do_nut("extended/animate.nut");
fe.do_nut("extended/animations/particles/particles.nut");

/*
ExtendedObjects works similar to the standard fe functions, but can
provide additional functionality
*/

//You must pass an 'id' as the first argument, otherwise add_ functions mirror attract-mode defaults
ExtendedObjects.add_image("bg", "bg.png", 0, 0, fe.layout.width, fe.layout.height, Layer.Back);

//objects can be retrieved by their id
ExtendedObjects.get("bg").setPreserveAspectRatio(false);

//various animations can be added to objects
if (config.enable_particles == "Yes") ExtendedObjects.get("bg").animate({ which = "particles", preset = "snow", layer = Layer.Middle } );

local title = ExtendedObjects.add_text("title", "[Title]", 0, 80, fe.layout.width / 2, 60);
    //property functions follow a setFunction or getFunction standard
    title.setColor(220, 220, 220);
    title.setCharSize(36);
    //ExtendedTexts and ExtendedImages can make use of a shadow
    title.setShadow(true);
    title.setShadowColor(240, 240, 20);
    title.setShadowAlpha(75);
    title.setShadowOffset(4);

//Add a list at a custom position
local list = ExtendedObjects.add_listbox("list", fe.layout.width / 2, 0, fe.layout.width / 2, fe.layout.height);
    list.setCharSize(15);
    list.setStyle(Style.Bold);
    list.setColor(80, 80, 80);
    list.setSelectionColor(200, 200, 200);
    list.setSelectionBGColor(60, 60, 125);
    list.setSelectionBGAlpha(100);
    //you can set positions of objects by string names
    list.setPosition("offright");

/*
 Animations are as simple as creating a config with properties and using
 object.animate(config)
 The config is a table of properties (any combination or none can be used)
*/
    
//add a property animation that moves the list from off right to the start position
local listAnim =    {
                        which = "property",
                        when = When.StartLayout,
                        property = "x",
                        delay = 750,
                        from = "offright",
                        to = "right"
                    }
if (config.enable_anims == "Yes") list.animate(listAnim) else list.setPosition("right");

//Add a logo image
local logo = ExtendedObjects.add_image("logo", "logo.png", 0, 0, 262, 72);
    logo.setPosition("offtoprightx");

//add a translate animation that goes from the current position to the top of the screen and bounces
local logoAnim =  {
                        which = "translate",
                        when = When.StartLayout,
                        delay = 750,
                        duration = 1000,
                        from = "current",
                        to = "top",
                        easing = "out",
                        tween = "bounce"
                    };
if (config.enable_anims == "Yes") logo.animate(logoAnim) else logo.setPosition("top");


local snap = ExtendedObjects.add_artwork("snap", "snap", 100, 100, 480, 360, 2);
    snap.setPosition( [ 100, (fe.layout.height / 2) - 180 ]);
    snap.setShadow(false);

//You can use predefined animation sets (a group of animations)
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
