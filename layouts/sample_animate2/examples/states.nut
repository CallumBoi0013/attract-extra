OBJECTS.tutorial1.msg = "States";
OBJECTS.tutorial2.msg = "Allows you to store multiple states for an object and switch or animate between them";
OBJECTS.tutorial_instructions.msg = "PropertyAnimation(obj)\n   .delay(\"1s\").easing(\"ease-in-out\")\n   .state(\"left\", { x = 250, y = 150 })\n   .state(\"right\", { x = 950, y = 150 })\n   .from(\"left\").to(\"right\")\n   .loop(-1).yoyo()\n   .play()";
OBJECTS.tutorial_instructions.set_pos(50, 300);
OBJECTS.wheel.visible = true;
OBJECTS.wheel.origin_x = OBJECTS.wheel.width / 2;
OBJECTS.wheel.origin_y = OBJECTS.wheel.height / 2;

PropertyAnimation(OBJECTS.wheel)
  .delay("1s")
  .easing("ease-in-out")
  .state("left", { x = 250, y = 150 })
  .state("right", { x = 950, y = 150 })
  .from("left").to("right")
  .loop(-1)
  .yoyo()
  .play()
