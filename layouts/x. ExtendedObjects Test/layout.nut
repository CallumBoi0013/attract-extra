/*
	This is a testing layout. Check out the other tutorial layouts for examples on using ExtendedObjects
*/

//load required files
fe.load_module("extended/extended");
fe.load_module("extended/animate");
fe.load_module("extended/animations/particles/particles.nut");

ExtendedObjects.add_image("bg", "bg.png", 0, 0, fe.layout.width, fe.layout.height, Layer.Background);
ExtendedObjects.get("bg").animate({ which = "particles", preset = "snow", layer = Layer.Primary } );
ExtendedObjects.add_image("logo", "logo.png", 0, 0, 150, 75);
