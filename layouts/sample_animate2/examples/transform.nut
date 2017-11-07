OBJECTS.tutorial1.msg = "Center Transform objects";
OBJECTS.tutorial2.msg = "Allows you to center rotate and scale objects";
OBJECTS.tutorial_instructions.msg = "PropertyAnimation(obj)\n   .key(\"scale\")\n   .from(1).to(2)\n   .center_scale()\n   .play()";
OBJECTS.snap.visible = true;

PropertyAnimation(OBJECTS.snap)
    .name("transform")
    .key("scale")
    .from(1).to(1.25)
    .center_scale()
    .speed(2)
    .triggers( [ Transition.FromOldSelection ] )
    .play()
