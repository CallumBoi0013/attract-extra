//push the method that users will use to the Animation table
Animation["particles"] <- function(c = {} ) {
    return ParticleAnimation(c);
}

const PCOUNT = 2000;

class ParticleAnimation extends ExtendedAnimation {
    particles = null;
    object = null;
    
    constructor(config) {
        base.constructor(config);
        particles = array(PCOUNT);
        local image = "extended/animations/particles/star.png";
        if ("particle" in config == true) image = config.particle; 
        object = fe.add_image(image, -32, -32, 32, 32);
        object.set_rgb(255, 0, 0);
        //local resource = fe.add_image(image, 20, 20, 32, 32);
        for (local i = 0; i < PCOUNT; i++) {
            particles[i] = Particle(i, object, 0, 0, fe.layout.width, fe.layout.height);
        }
        particles[0].setColor(255, 0, 0);
        particles[1].setColor(0, 255, 0);
        particles[2].setColor(0, 0, 255);
        
    }
    
    function getType() { return "ParticleAnimation"; }
    function start(obj) {
        base.start(obj);
        foreach (p in particles) {
            p.reset();
            p.visible(true);
        }
    }
    
    function frame(obj, ttime) {
        base.frame(obj, ttime);
        foreach (p in particles) {
            p.set(  calculate(config.easing, config.tween, ttime, p.start[0], p.end[0], config.duration),
                    calculate(config.easing, config.tween, ttime, p.start[1], p.end[1], config.duration)
             );
        }
    }
    
    function stop(obj) {
        base.stop(obj);
    }
}

class Particle {
    id = 0;
    object = null;
    minX = 0;
    minY = 0;
    maxX = 0;
    maxY = 0;
    start = null;
    end = null;
    forwardAnim = true;
    constructor(id, resource, minX, minY, maxX, maxY) {
        object = fe.add_clone(resource);
        this.minX = minX;
        this.minY = minY;
        this.maxX = maxX;
        this.maxY = maxY;
        reset();
    }
    
    function random(minNum, maxNum) {
        return floor(((rand() % 1000 ) / 1000.0) * (maxNum - minNum) + minNum);
    }
    
    function reset() {
        forwardAnim = !forwardAnim;
        if (start == null) {
            start = [   random(minX, maxX),
                        random(minY, maxY) ];
            object.alpha = random(25, 255);
            object.set_rgb(random(0,255), random(0,255), random(0,255));
            object.width = object.height = random(16, 32);
        } else {
            start = end;
        }
        end = [   random(minX, maxX),
                    random(minY, maxY) ];
        set(start[0], start[1]);
    }
    
    function setColor(r, g, b) {
        object.set_rgb(r, g, b);
    }
    
    function set(x, y) {
        object.x = x;
        object.y = y;
    }
    
    function visible(v) { object.visible = v; }
}