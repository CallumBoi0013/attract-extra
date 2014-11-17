//To use ExtendedObjects, you must load the required module
fe.load_module("extended/extended");

//When adding objects, use ExtendedObjects instead
//You must pass an 'id' as the first argument
//Otherwise add_ functions mirror attract-mode defaults
ExtendedObjects.add_image("bg", "bg.png", 0, 0, fe.layout.width, fe.layout.height);

//objects can be retrieved at anytime by their id
//all object settings are get/set using functions, instead of variables
ExtendedObjects.get("bg").setPreserveAspectRatio(false);

//you can still keep a local reference to your object if you wish
local title = ExtendedObjects.add_text("title", "[Title]", 0, 80, fe.layout.width / 2, 60);
    //property functions follow a setFunction or getFunction standard
    title.setColor(220, 220, 220);
    title.setCharSize(36);
    //ExtendedTexts and ExtendedImages have a builtin shadow
    title.setShadow(true);
    title.setShadowColor(240, 240, 20);
    title.setShadowAlpha(75);
    title.setShadowOffset(4);

local logo = ExtendedObjects.add_image("logo", "logo.png", 0, 0, 262, 72);
    //you can set screen positions of objects using string names
    logo.setPosition("top");

local list = ExtendedObjects.add_listbox("list", fe.layout.width / 2, 0, fe.layout.width / 2, fe.layout.height);
    list.setCharSize(15);
    list.setStyle(Style.Bold);
    list.setColor(80, 80, 80);
    list.setSelectionColor(200, 200, 200);
    list.setSelectionBGColor(60, 60, 125);
    list.setSelectionBGAlpha(100);
    list.setPosition("right");

local snap = ExtendedObjects.add_artwork("snap", "snap", 100, 100, 480, 360);
    snap.setPosition( [ 100, (fe.layout.height / 2) - 180 ]);
    snap.setShadow(false);

local marquee = ExtendedObjects.add_artwork("marquee", "marquee", 0, 0, 500, 156);
    marquee.setPosition("bottom");


//The debugger adds debug text ontop of every object, helpful for... debugging
local debug = ExtendedObjects.debugger();
debug.setVisible(true);
