//load required files
fe.do_nut("extended/extended.nut");
//animate is only required if you want to use animations
fe.do_nut("extended/animate.nut");

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
    
//add an animation that moves the list from off right to the start position
local listAnim =    {
                        when = Transition.StartLayout,
                        property = "x",
                        delay = 750,
                        from = "offright",
                        to = "start"
                    }
list.animate_property(listAnim);

//Add a logo image
local logo = ExtendedObjects.add_image("logo", "logo.png", 0, 0, 262, 72);
    logo.setPosition("offtoprightx");

//An animation config is a table of properties (any or none - an empty table can be used)
local logoAnim =  {
                        when = Transition.StartLayout,
                        delay = 750,
                        duration = 1000,
                        from = "current",
                        to = "top",
                        easing = "out",
                        tween = "bounce"
                    };
logo.animate_translate( logoAnim );

                    
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
marquee.animate_translate( marqueeAnim1 );
marquee.animate_translate( marqueeAnim2 );

local snap = ExtendedObjects.add_artwork("snap", "snap", 100, 100, 480, 360);
    snap.setPosition( [ 100, (fe.layout.height / 2) - 180 ]);
    snap.setShadow(false);
//You can add multiple animations for different transition states
local snapAnim1 =  { 
                    when = Transition.ToNewSelection,
                    duration = 200,
                    property = "alpha",
                    from = 255,
                    to = 0,
                    easing = "out",
                    tween = "quad"
                };
local snapAnim2 =  { 
                    when = Transition.FromOldSelection,
                    delay = 1500,
                    duration = 500,
                    property = "alpha",
                    from = 0,
                    to = 255,
                    easing = "in",
                    tween = "quad"
                };
//You can animate properties like alpha, x, y, width, height
snap.animate_property( snapAnim1 );
snap.animate_property( snapAnim2 );

//The debugger adds debug text ontop of every object, helpful for... debugging
local debug = ExtendedObjects.add_debug();
debug.setVisible(false);