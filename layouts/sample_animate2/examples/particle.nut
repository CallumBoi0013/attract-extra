OBJECTS.wheel.visible =  OBJECTS.list.visible = OBJECTS.surface.visible = true;
OBJECTS.tutorial1.msg = "ParticleAnimation";
OBJECTS.tutorial2.msg = "Allows you to emit particles on a surface";
OBJECTS.tutorial_instructions.msg = "ParticleAnimation(surface)\n   .addEmiter({ x = fe.layout.width / 2, y = fe.layout.height / 2 })\n      .addModifier(...)\n   .play()";
OBJECTS.surface.visible = true;

//Particle testing
local particles = ParticleAnimation( OBJECTS.surface );
local emitter = particles.engine.addEmitter({ x = fe.layout.width / 2, y = fe.layout.height / 2, texture = "resources/bubble-01.png" });
//emitter.life = 3;
//emitter.color = { r = 0, g = 20, b = 200 }
emitter.addModifier( VelocityModifier( { angle = "random-each" , radius = "random-each" } ) );
emitter.addModifier( RateModifier( { particleRate = "random-each", timeRate = "random-each" } ) );
emitter.addModifier( LifeModifier( { life = "random-each" } ) );

//emitter.addModifier( ColorModifier( { color = [ Color( 200, 0, 0), Color( 0, 200, 0), Color( 0, 0, 200), ] } ));
//emitter.addModifier( ScaleModifier( { scaleX = Span( [ 3, 5 ] ), scaleY = Span( [ 3, 5 ] ) } ) );
//emitter.addModifier( ScaleModifier( { scaleX = 0.25, scaleY = 0.25 } ) );
//emitter.addModifier( FieldModifier( 320, 360, 0.0 ) );
//emitter.addModifier( FieldModifier( 960, 360, 0.0 ) );
//emitter.addModifier( FieldModifier( 1000, 500, 500.0 ) );

/*


local redToYellow = ColorSpan([ Color( 200, 0, 0 ), Color( 200, 200, 0 ), ]);
local whiteToGreen = ColorSpan([ Color( 230, 251, 231 ), Color( 169, 229, 161 ), Color( 96, 221, 79 ), Color( 27, 178, 34 ) ]);

local rainbow = ColorSpan([
  Color( 186, 32, 37 ), //red
  Color( 247, 105, 11 ), //orange
  Color( 247, 233, 11 ), //yellow
  Color( 75, 210, 2 ), //green
  Color( 2, 208, 210 ), //blue
  Color( 136, 59, 168 ), //indigo
  Color( 205, 114, 202 ), //violet
]);

local randomArray = [
  Color( 200, 0, 0),
  Color( 0, 200, 0),
  Color( 0, 0, 200),
]

*/