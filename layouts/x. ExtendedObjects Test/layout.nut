/*
	This is a testing layout. For a complete example, rename this to layout-test.nut, and rename example-layout.nut to layout.nut
*/

//load required files
fe.load_module("extended/extended");
fe.load_module("extended/animate");
//fe.do_nut("extended/animations/particles/particles.nut");

ExtendedObjects.add_image("bg", "bg.png", 0, 0, fe.layout.width, fe.layout.height, Layer.Back);
//ExtendedObjects.get("bg").animate({ which = "particles", preset = "default", layer = Layer.Front } );
//ExtendedObjects.add_surface("test", 600, 100);
//ExtendedObjects.get("test").add_text("surfaceText", "Surface Text", 0, 0, 600, 50);
//ExtendedObjects.get("test").add_image("surfaceImage", "logo.png", 0, 50, 150, 75);
//ExtendedObjects.get("test").setPosition([100, 100]);
//ExtendedObjects.get("test").animate({ which = "translate", when = When.StartLayout, from = "0", to = "200"  } );

//local s = fe.add_surface(100, 100);
local debug = ExtendedObjects.debugger();
debug.setVisible(true);
