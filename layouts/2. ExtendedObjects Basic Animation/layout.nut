fe.load_module("extended/extended");
//To use animations, just add the animate module
fe.load_module("extended/animate");

ExtendedObjects.add_image("bg", "bg.png", 0, 0, fe.layout.width, fe.layout.height, Layer.Back);
ExtendedObjects.get("bg").setPreserveAspectRatio(false);

local title = ExtendedObjects.add_text("title", "[Title]", 0, 80, fe.layout.width / 2, 60);
    title.setColor(220, 220, 220);
    title.setCharSize(36);
    title.setShadow(true);
    title.setShadowColor(240, 240, 20);
    title.setShadowAlpha(75);
    title.setShadowOffset(4);

/*
 Animations are as simple as creating a config with properties and using
 object.animate(config)
 The config is a table of properties (any combination or none can be used)
*/
    
local logo = ExtendedObjects.add_image("logo", "logo.png", 0, 0, 262, 72);
    logo.setPosition("top");

//a translate animation moves an object from one point to another
//this one will go from the objects current position to the top of the screen
local logoAnim =  {
                        which = "translate",		//which animation to use
                        when = When.StartLayout,	//when to perform the animation
                        delay = 750,				//the delay before the animation starts
                        duration = 1000,			//how long the animation lasts (in ms)
                        from = "current",			//where the animation will start from
                        to = "offtoprightx",			//where the animation will go to
                    };
logo.animate(logoAnim);

local list = ExtendedObjects.add_listbox("list", fe.layout.width / 2, 0, fe.layout.width / 2, fe.layout.height);
    list.setCharSize(15);
    list.setStyle(Style.Bold);
    list.setColor(80, 80, 80);
    list.setSelectionColor(200, 200, 200);
    list.setSelectionBGColor(60, 60, 125);
    list.setSelectionBGAlpha(100);
    list.setPosition("offright");

//a property animation can animate an objects property
//this one will animate the x property from offscreen right, to right with a bounce animation
local listAnim =    {
                        which = "property",
                        when = When.StartLayout,
                        property = "x",				//tell the property animation which property to animate
                        delay = 750,
						duration = 1500,
                        from = "offright",
                        to = "right",
                        easing = "out",				//type of easing (describes how the animation starts or finishes)
                        tween = "bounce"			//type of tween (different types of animations)
                    }
list.animate(listAnim);

local snap = ExtendedObjects.add_artwork("snap", "snap", 100, 100, 480, 360, 2);
    snap.setPosition( [ 100, (fe.layout.height / 2) - 180 ]);
    snap.setShadow(false);

//now we will make our marquee object go off the screen when leaving a selection, and back on when going to a new one 
local marquee = ExtendedObjects.add_artwork("marquee", "marquee", 0, 0, 500, 156);
    marquee.setPosition("bottom");

local marqueeIn =  {
                        which = "translate",
                        when = When.FromOldSelection,
                        from = "offbottom",
                        to = "bottom",
						delay = 1000
                    }
local marqueeOut =  {
                        which = "translate",
                        when = When.ToNewSelection,
                        from = "bottom",
                        to = "offbottom"
                    }
marquee.animate(marqueeOut);
marquee.animate(marqueeIn);
