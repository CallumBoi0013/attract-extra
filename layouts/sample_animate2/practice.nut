
OBJECTS.tutorial1.msg = "Practice";
OBJECTS.tutorial2.msg = "Open 'layouts/sample_animate2/practice.nut' and animate the final layout";
OBJECTS.tutorial3.msg = "Use this layout for testing!"
foreach( key, val in OBJECTS )
    try { OBJECTS[key].visible = true; } catch(e) {}
OBJECTS.tutorial_bar_text.visible = OBJECTS.tutorial_bar_progress.visible = false;

// Use the area below to animate the layout
// You can use the following existing objects prefixed with OBJECTS.
// bg, surface
// snap, wheel, marquee, list, title
// cd, joystick, joy_text, pixel
//
// You can change any values of the objects just like any other object:

OBJECTS.bg.file_name = OBJECTS.pixel.file_name;
OBJECTS.bg.set_rgb( 180, 20, 20 );
OBJECTS.marquee.visible = false;
OBJECTS.cd.set_pos( fe.layout.width - 160, fe.layout.height - 160 );

// Animation examples:

SpriteAnimation(OBJECTS.joystick).sprite_order([ 0, 1, 0, 2 ]).loops(-1).speed(0.25).play();

PropertyAnimation(OBJECTS.cd)
    .key("rotation")
    .center_rotation()
    .from(0).to(359)
    .speed(0.25)
    .loops(-1)
    .interpolator( CubicBezierInterpolator("ease-in-out-back") )
    .play()

