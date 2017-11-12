function sprite() {
  OBJECTS.tutorial1.msg = "SpriteAnimation";
  OBJECTS.tutorial2.msg = "Allows you to use a spritesheet for animation";
  OBJECTS.tutorial_instructions.msg = "SpriteAnimation(obj)\n   .sprite_width(128).sprite_height(128)\n   .sprite_order([ 0, 3, 1, 2])\n   .loops(-1).speed(0.25)\n   .play()";
  OBJECTS.joystick.visible = true;
  
  SpriteAnimation(OBJECTS.joystick)
    .debug(false)
    .sprite_width(128)
    .sprite_height(128)
    .sprite_order([ 0, 1, 0, 2 ])
    .sprite_frame(3)
    .speed(0.25)
    .loops(-1)
    .play()
}

sprite();