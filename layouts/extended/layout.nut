//load required files
fe.do_nut("extended/extended.nut");
//animate is only required if you want to use animations
fe.do_nut("extended/animate.nut");

/*
ExtendedObjects works similar to the standard fe functions, but can
provide additional functionality
*/

//You must pass an 'id' as the first argument, otherwise add_ functions mirror attract-mode defaults
ExtendedObjects.add_image("bg", "bg.png", 0, 0, fe.layout.width, fe.layout.height);

//objects can be retrieved by their id
ExtendedObjects.get("bg").setPreserveAspectRatio(false);

//but you can still keep a variable
local title = ExtendedObjects.add_text("title", "[Title]", 0, 80, fe.layout.width / 2, 60);
    //property functions follow a setFunction or getFunction standard
    title.setColor(220, 220, 220);
    title.setCharSize(36);
    //ExtendedTexts and ExtendedImages can make use of a shadow
    title.setShadow(true);
    title.setShadowColor(240, 240, 20);
    title.setShadowAlpha(225);
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
 object.animate(animType, config)
 The config is a table of properties (any combination or none can be used)
*/
    
//add a property animation that moves the list from off right to the start position
local listAnim =    {
                        when = Transition.StartLayout,
                        property = "x",
                        delay = 750,
                        from = "offright",
                        to = "start"
                    }
list.animate("property", listAnim);

//Add a logo image
local logo = ExtendedObjects.add_image("logo", "logo.png", 0, 0, 262, 72);
    logo.setPosition("offtoprightx");

//add a translate animation that goes from the current position to the top of the screen and bounces
local logoAnim =  {
                        when = Transition.StartLayout,
                        delay = 750,
                        duration = 1000,
                        from = "current",
                        to = "top",
                        easing = "out",
                        tween = "bounce"
                    };
logo.animate("translate", logoAnim);

                    
local marquee = ExtendedObjects.add_artwork("marquee", "marquee", 0, 0, 500, 156);
    marquee.setPosition("offleft");


//You can delay animations to get a step1, step2 approach
//step 1: move from offscreen left to center using the out/back tween
local marqueeAnim1 =  {
                        when = Transition.FromOldSelection,
                        duration = 750,
                        from = "offleft",
                        to = "center",
                        easing = "out",
                        tween = "back"
                    };
//step 2: move from current position to bottomleft after an 800ms delay using the out/bounce tween
local marqueeAnim2 =  {
                        when = Transition.FromOldSelection,
                        delay = 800,
                        duration = 750,
                        from = "current",
                        to = "bottom",
                        easing = "out",
                        tween = "bounce"
                    };
marquee.animate("translate", marqueeAnim1);
marquee.animate("translate", marqueeAnim2);

local snap = ExtendedObjects.add_artwork("snap", "snap", 100, 100, 480, 360);
    snap.setPosition( [ 100, (fe.layout.height / 2) - 180 ]);
    snap.setShadow(false);

//You can use predefined animation sets (a group of animations)
snap.animate_set( "property", "fade_in_out" );

//The debugger adds debug text ontop of every object, helpful for... debugging
local debug = ExtendedObjects.add_debug();
debug.setVisible(false);