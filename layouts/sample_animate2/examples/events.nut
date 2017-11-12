OBJECTS.marquee.visible = true;
OBJECTS.tutorial1.msg = "Animation Events";
OBJECTS.tutorial2.msg = "Allows you to run your own code when various animation events occur";
OBJECTS.tutorial_instructions.msg = "anim.on(\"start\", function(anim) {\n   //do something\n})";

local text = fe.add_text("", 50, 300, 600, 30 );
text.align = Align.Left;
text.set_rgb( 30, 30, 30 );

PropertyAnimation()
  .name("events")
  .target(OBJECTS.marquee)
  .key("alpha")
  .from(255)
  .to(0)
  .speed(0.1)
  .on("update", function(anim) { text.msg = "Animation progress: .on(\"update\"): " + anim.progress; } )
  .on("stop", function(anim) { text.msg = "Animation complete .on(\"stop\")"; } )
  .play();
