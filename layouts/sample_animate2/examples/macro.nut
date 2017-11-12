function macro() {
  OBJECTS.tutorial1.msg = "Macros";
  OBJECTS.tutorial2.msg = "Allows you to store predefined animation macros and reuse them";
  OBJECTS.tutorial_instructions.msg = "Animation.registerMacro(\"myMacro\", { config ... })";
  OBJECTS.wheel.visible = true;

  //Animation.registerMacro( "hideArt", { duration = "2s", from = { x = 100, y = 100 alpha = 255 }, to = { x = -480, y = 100, alpha = 0 } } );
  //Animation.registerMacro( "showArt", { duration = "2s", delay = "2.25s", easing = Easing.OutElastic, default_state = "current", from = { x = -480, y = 100, alpha = 0 }, to = { x = 100, y = 100, alpha = 255 } } );
  //local anim = PropertyAnimation(OBJECTS.wheel).exec("hideArt");

}

macro();