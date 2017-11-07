OBJECTS.tutorial1.msg = "Interpolate";
OBJECTS.tutorial2.msg = "Allows you to control easing for from-to values";
OBJECTS.tutorial_instructions.msg = "PropertyAnimation(obj)\n   .from(0).to(100)\n   .interpolator( CubicBezierInterpolator(\"ease-in-out-back\")\n   .play()";
OBJECTS.list.visible = true;

PropertyAnimation(OBJECTS.list)
    .name("interpolate")
    .interpolator( CubicBezierInterpolator("ease-in-sine") )
    .key("x").from(-OBJECTS.list.width - 20).to(0)
    .play();