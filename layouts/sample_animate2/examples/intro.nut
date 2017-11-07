OBJECTS.logo.visible = true;
OBJECTS.tutorial1.msg = "Introduction";
OBJECTS.tutorial2.msg = "This demonstration shows the features of the animate v2 module.\n";
OBJECTS.tutorial_instructions.msg = "fe.load_module(\"animate2\")";

PropertyAnimation()
    .name("logo_bounce")
    .target(OBJECTS.logo)
    .key("y").from(100).to(400)
    .interpolator( PennerInterpolator("ease-out-bounce"))
    .speed(0.5)
    .play();
PropertyAnimation()
    .name("logo_move")
    .target(OBJECTS.logo)
    .key("x").from(400).to(600)
    .speed(0.5)
    .play();

PropertyAnimation()
    .name("logo_scale")
    .target(OBJECTS.logo)
    .key("scale").from(1).to(1.5)
    .play();

PropertyAnimation()
    .name("text_pulse")
    .target(OBJECTS.tutorial3)
    .key("alpha").from(255).to(0)
    .yoyo(true)
    .loops(-1)
    .play();