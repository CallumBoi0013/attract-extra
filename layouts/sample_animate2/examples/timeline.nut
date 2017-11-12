OBJECTS.tutorial1.msg = "Timeline";
OBJECTS.tutorial2.msg = "Allows you to chain animations together in a timeline";
OBJECTS.tutorial_instructions.msg = "TimelineAnimation()\n   .add(anim1).add(anim2)\n   .play()";

OBJECTS.marquee.visible = true;
OBJECTS.marquee.alpha = 255;

local anim1 = PropertyAnimation(OBJECTS.marquee).key("y").from(OBJECTS.marquee.y).to(100)
local anim2 = PropertyAnimation(OBJECTS.marquee).key("x").from(OBJECTS.marquee.x).to(300)
local anim3 = PropertyAnimation(OBJECTS.marquee).key("rotation").from(0).to(359)
local anim4 = PropertyAnimation(OBJECTS.marquee).key("alpha").from(255).to(0)

TimelineAnimation().add(anim1).add(anim2).add(anim3).add(anim4).play();
