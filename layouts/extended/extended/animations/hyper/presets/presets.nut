Animation.hyperPresets <- {
    "arc1": {
        resources = [ "presets/ball.png" ],
        ppm = 1,
        x = -50,
        y = 800,
        speed = [ 1450, 1450 ],
        angle = [ 290, 290 ],
        gravity = 40,
        lifespan = 7000
    },
    "bounce1": {
        resources = [ "presets/ball.png" ],
        ppm = 1,
        x = -80,
        y = 225,
        speed = [ 800, 800 ],
        angle = [ 20, 20 ],
        gravity = 40,
        accel = 3.5,
        bound = [ 0, 0, 3000, 650 ],
        rotate = [ 3, 3 ],
        scale = [ 0.5, 3 ],
        lifespan = 5000
    },
    "bubbles1": {
        resources = [ "presets/bubbles1.png" ],
        ppm = 200,
        x = 0,
        y = fe.layout.height,
        width = fe.layout.width,
        speed = [ 100, 250 ],
        angle = [ 360, 180 ],
        startScale = [ 0.5, 1.5 ],
        gravity = -2,
        fade=10000,
        lifespan = 10000
    },
    "cloudstoon": {
        resources = [ "presets/clouds-toon-1.png", "presets/clouds-toon-2.png", "presets/clouds-toon-3.png" ],
        ppm = 40,
        x = -325,
        y = -200,
        height = fe.layout.height,
        speed = [ 150, 300 ],
        lifespan = 15000
    },
    "cloudstoon2": {
        resources = [ "presets/clouds-toon2-1.png", "presets/clouds-toon2-2.png", "presets/clouds-toon2-3.png", "presets/clouds-toon2-4.png", "presets/clouds-toon2-5.png" ],
        ppm = 40,
        x = -175,
        y = -200,
        height = fe.layout.height,
        speed = [ 150, 300 ],
        lifespan = 15000
    },
    "default": {
        resources = [ "presets/default.png" ],
        ppm = 50,
        lifespan = 5000
    },
    "snow": {
        resources = [ "presets/snow.png" ],
        ppm = 500,
        x = 0,
        y = 0,
        width = fe.layout.width,
        speed = [ 100, 250 ],
        angle = [ 0, 180 ],
        startScale = [ 1, 2 ],
        gravity = 1,
        fade = 10000,
        lifespan = 10000
    },
    "sparkle": {
        resources = [ "presets/sparkle.png" ],
        ppm = 1000,
        x = 0,
        y = 0,
        width = fe.layout.width,
        height = fe.layout.height,
        speed = [ 0, 0 ],
        startScale = [ 1, 1.5 ],
        fade = 500,
        rotate = [ 1, 10 ],
        lifespan = 500
    }
}
