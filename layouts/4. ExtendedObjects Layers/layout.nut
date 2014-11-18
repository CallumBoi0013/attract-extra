/*
	This is a testing layout. Check out the other tutorial layouts for examples on using ExtendedObjects
*/

//load required files
fe.load_module("extended/extended");
fe.load_module("extended/animate");
//fe.do_nut("extended/animations/particles/particles.nut");

//local bg = ExtendedObjects.add_image("bg", "bg.png", 0, 0, fe.layout.width, fe.layout.height, Layer.Back);
//ExtendedObjects.get("bg").animate({ which = "particles", preset = "default", layer = Layer.Front } );
//ExtendedObjects.add_surface("test", 600, 100);
//ExtendedObjects.get("test").add_text("surfaceText", "Surface Text", 0, 0, 600, 50);
//ExtendedObjects.get("test").add_image("surfaceImage", "logo.png", 0, 50, 150, 75);
//ExtendedObjects.get("test").setPosition([100, 100]);
//ExtendedObjects.get("test").animate({ which = "translate", when = When.StartLayout, from = "0", to = "200"  } );

//local s = fe.add_surface(100, 100);
//local debug = ExtendedObjects.debugger();
//debug.setVisible(true);

/*
	Typically with AM, once an object is drawn, anything drawn after that will be on top. This means you have to be careful about
	the order you draw objects if they will overlap. Surfaces were added in AM 1.3, which gives us greater control.
	
	Layers is a built-in ExtendedObjects feature available to help simplify using surfaces to create a layered effect.
	A layer is just a surface that ExtendedObjects has already created and draws its objects on.
	There are three layers in ExtendedObjects - Layer.Background, Layer.Primary, Layer.Foreground
	When you add new objects in ExtendedObjects, by default they are drawn to the Primary (middle) layer.
	With layers, this means you can now add objects behind or in front of existing objects without having to create your own surfaces.
*/

//here, we are adding 3 objects that overlap. First to the foreground, then the background, then the (default) primary layer, but they still display
//in the order we want.
//Draw order will still matter when drawing to the same layer

//Draw to foreground
ExtendedObjects.add_text("foregroundText", "Foreground", 90, 20, 300, 50, Layer.Foreground);
//Draw to background
local vid = ExtendedObjects.add_image("background", "violet rays with white particles - Sagar Mhamane on YouTube.flv", 0, 0, fe.layout.width, fe.layout.height, Layer.Background);
ExtendedObjects.add_text("primaryText", "Background", 0, fe.layout.height - 50, 300, 50, Layer.Background);

//Draw to Primary (default if not specified)
local list = ExtendedObjects.add_listbox("list", fe.layout.width / 2, 0, fe.layout.width / 2, fe.layout.height);
    list.setBGColor(30, 30, 30);
    list.setBGAlpha(100);
    list.setSelectionBGColor(60, 60, 125);
    list.setCharSize(18);
	list.setFormatString("[Year] - [Title]");
local art = ExtendedObjects.add_artwork("artwork", "snap", 0, 50, 480, 360);
ExtendedObjects.add_text("primaryText", "Primary", 90, 350, 300, 50, Layer.Primary);

//you can still create your own surfaces if you want, just remember draw order will still matter when adding objects to the same layer
local mySurface = ExtendedObjects.add_surface("surfaceTest", 480, 180, Layer.Background);
mySurface.setX(fe.layout.width / 2 - mySurface.getWidth() / 2);
mySurface.setY(0);
mySurface.add_text("mySurfaceText", "MySurface on Background", 0, 0, 480, 30);

local bgMarquee = mySurface.add_artwork("mySurfaceArtwork", "marquee", 0, 30, mySurface.getWidth(), mySurface.getHeight() - 30);
	bgMarquee.setPreserveAspectRatio(true);

local surfaceAnim =  {
                        which = "translate",		//which animation to use
                        when = When.ToNewSelection,	//when to perform the animation
                        delay = 750,				//the delay before the animation starts
                        duration = 3000,			//how long the animation lasts (in ms)
                        from = "offtop",			//where the animation will start from
                        to = "bottom",			//where the animation will go to
                    };
mySurface.animate(surfaceAnim);

//The debugger adds debug text ontop of every object, helpful for... debugging
local debug = ExtendedObjects.debugger();
debug.setVisible(false);
