function states() {
  OBJECTS.tutorial1.msg = "States";
  OBJECTS.tutorial2.msg = "Allows you to store multiple states for an object and switch or animate between them";
  OBJECTS.tutorial_instructions.msg = "local hide = { alpha = 0 }\nanim.set_state(\"hide\")";

  local topleft = { x = 100, y = 100 }
  local bottomright = { x = fe.layout.width - 100, y = fe.layout.height - 50 }

  local hide = { alpha = 0 }
  local show = { alpha = 255 }

  local small = { scale = 0.25 }
  local big = { scale = 1.5 }

}

states();