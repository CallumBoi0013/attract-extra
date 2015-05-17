fe.load_module("animate/animate");

local text = fe.add_text("[Title]", 0, 25, fe.layout.width, 72);

local particle_cfg = {
    resources = [ "default.png" ],
    ppm = 60,
    x = 0,
    y = 0,
    width = fe.layout.width,
    speed = [ 100, 250 ],
    angle = [ 0, 180 ],
    startScale = [ 1, 2 ],
    gravity = 1,
    fade = 10000,
    lifespan = 10000
}

//animation.add( ParticleAnimation( particle_cfg ) );

//PRESETS are also available to use
//
//animation.add( ParticleAnimation( Particles.bubbles1 ) );
//animation.add( ParticleAnimation( Particles.snow ) );
animation.add( ParticleAnimation( Particles.sparkle ) );
