  OBJECTS.tutorial1.msg = "PropertyAnimation";
  OBJECTS.tutorial2.msg = "Allows you to animation property values on an object";
  OBJECTS.tutorial_instructions.msg = "PropertyAnimation(obj)\n   .key(\"scale\").from(1).to(2)\n   .loops(-1).yoyo()\n   .play()";
  OBJECTS.wheel.visible = true;

  PropertyAnimation()
      .name("property_anim")
      .target(OBJECTS.wheel)
      .key("y").from(-OBJECTS.wheel.height - 20).to(50)
      .triggers( [ Transition.FromOldSelection ] )
      .speed(0.5)
      .play()
