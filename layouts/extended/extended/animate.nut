//The Animate class handles the hooks that allow ExtendedObjects to 
//animate and processes the animations based on a table of config
//parameters
class Animate {
    //  Penner's Easing equations
    //  http://www.robertpenner.com/easing/
    //  - functions modified so t is passed as (ttime / duration) since many functions need that
    //  - Some functions require ttime to do the calculation, so that is used instead, and t is calculated in the function
    penner = {
        "linear": function (t, b, c, d) { return c * t + b; }
        "in": {
            "quad": function (t, b, c, d) { return c * pow(t, 2) + b; },
            "cubic": function (t, b, c, d) { return c * pow(t, 3) + b; },
            "quart": function (t, b, c, d) { return c * pow(t, 4) + b; },
            "quint": function (t, b, c, d) { return c * pow(t, 5) + b; },
            "sine": function (t, b, c, d) { return -c * cos(t * (PI / 2)) + c + b; },
            "expo": function (ttime, b, c, d) { if ( ttime == 0) return b; return c * pow(2, 10 * ( ttime.tofloat() / d - 1)) + b; },
            "circle": function (t, b, c, d) { return -c * (sqrt(1 - pow(t, 2)) - 1) + b; },
            "elastic": function (ttime, b, c, d, a = null, p = null) { if (ttime == 0) return b; local t = ttime.tofloat() / d; if (t == 1) return b + c; if (p == null) p = d * 0.37; local s; if (a == null || a < abs(c)) { a = c; s = p / 4; } else { s = p / (PI * 2) * asin(c / a); } t = t - 1; return -(a * pow(2, 10 * t) * sin((t * d - s) * (PI * 2) / p)) + b; },
            "back": function (t, b, c, d, s = null) { if (s == null) s = 1.70158; return c * t * t * ((s + 1) * t - s) + b; },
            "bounce": function (ttime, b, c, d) { return c - Animate.penner["out"]["bounce"](d - ttime, 0, c, d) + b; }
        },
        "out": {
            "quad": function (t, b, c, d) { return -c * t * (t - 2) + b; },
            "cubic": function (t, b, c, d) { t = t - 1; return c * (pow(t, 3) + 1) + b; },
            "quart": function (t, b, c, d) { t = t - 1; return -c * (pow(t, 4) - 1) + b; },
            "quint": function (t, b, c, d) { t = t - 1; return c * (pow(t, 5) + 1) + b; },
            "sine": function (t, b, c, d) { return c * sin(t * (PI / 2)) + b; },
            "expo": function (ttime, b, c, d) { if (ttime == d) return b + c; return c * (-pow(2, -10 * (ttime.tofloat() / d)) + 1) + b;},
            "circle": function (t, b, c, d) { t = t - 1; return (c * sqrt(1 - pow(t, 2)) + b); },
            "elastic": function (ttime, b, c, d, a = null, p = null) { if (ttime == 0) return b; local t = ttime.tofloat() / d; if (t == 1) return b + c; if (p == null) p = d * 0.37; local s; if (a == null || a < abs(c)) { a = c; s = p / 4; } else { s = p / (PI * 2) * asin(c / a); } return (a * pow(2, -10 * t) * sin((t * d - s) * (PI * 2) / p) + c + b).tofloat(); },
            "back": function (t, b, c, d, s = null) { if (s == null) s = 1.70158; t = t - 1; return c * (t * t * ((s + 1) * t + s) + 1) + b; },
            "bounce": function (ttime, b, c, d) { local t = ttime.tofloat() / d; if (t < 1 / 2.75) { return c * (7.5625 * t * t) + b; } else if ( t < 2 / 2.75) { return c * (7.5625 * (t -= (1.5/2.75)) * t + 0.75) + b; } else if ( t < 2.5 / 2.75 ) { return c * (7.5625 * (t -= (2.25/2.75)) * t + 0.9375) + b; } else { return c * (7.5625 * (t -= (2.625/2.75)) * t + 0.984375) + b;} }
        },
        "inout": {
            "quad": function (t, b, c, d) { t = t * 2; if (t < 1) return c / 2 * pow(t, 2) + b; return -c / 2 * ((t - 1) * (t - 3) - 1) + b; },
            "cubic": function (t, b, c, d) { t = t * 2; if (t < 1) return c / 2 * t * t * t + b; t = t - 2; return c / 2 * (t * t * t + 2) + b; },
            "quart": function (t, b, c, d) {  t = t * 2; if (t < 1) return c / 2 * pow(t, 4) + b; t = t - 2; return -c / 2 * (pow(t, 4) - 2) + b; },
            "quint": function (t, b, c, d) { t = t * 2; if (t < 1) return c / 2 * pow(t, 5) + b; t = t - 2; return c / 2 * (pow(t, 5) + 2) + b; },
            "sine": function (t, b, c, d) { return -c / 2 * (cos(PI * t) - 1) + b; },
            "expo": function (ttime, b, c, d) { if (ttime == 0) return b; if (ttime == d) return b + c; local t = ttime.tofloat() / d * 2; if (t < 1) return c / 2 * pow(2, 10 * (t - 1)) + b; t = t - 1; return c / 2 * (-pow(2, -10 * t) + 2) + b; },
            "circle": function (t, b, c, d) { t = t * 2; if (t < 1) return -c / 2 * (sqrt(1 - t * t) - 1) + b; t = t - 2; return c / 2 * (sqrt(1 - t * t) + 1) + b; },
            "elastic": function (ttime, b, c, d, a = null, p = null) { if (ttime == 0) return b; local t = (ttime.tofloat() / d) * 2; if (t == 2) return b + c; if (p == null) p = d * (0.3 * 1.5); local s; if (a == null || a < abs(c)) { a = c;  s = p / 4; } else { s = p / (PI * 2) * asin(c / a); } if (t < 1) return -0.5 * (a * pow(2, 10 * (t - 1)) * sin((t * d - s) * (PI * 2) / p)) + b; return a * pow(2, -10 * (t - 1)) * sin((t * d - s) * (PI * 2) / p) * 0.5 + c + b; },
            "back": function (t, b, c, d, s = null) { if (s == null) s = 1.70158; s = s * 1.525; t = t * 2; if (t < 1) return c / 2 * (t * t * ((s + 1) * t - s)) + b; t = t - 2; return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b; },
            "bounce": function (ttime, b, c, d) { if (ttime < d / 2) return Animate.penner["in"]["bounce"](ttime * 2, 0, c, d) * 0.5 + b; return Animate.penner["out"]["bounce"](ttime * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b; }
        }
    }
    
    function getWhen(w) {
        switch (w) {
            case 0:
                return "StartLayout";
            case 1:
                return "EndLayout";
            case 2:
                return "ToNewSelection";
            case 3:
                return "FromOldSelection";
            case 4:
                return "ToGame";
            case 5:
                return "FromGame";
            case 6:
                return "ToNewList";
            case 100:
                return "OnDemand";
            case 101:
                return "Always";
        }
    }
    
    //injects an animation table and the .animate() and .animate_set() methods into new objects
    function onObjectAdded(params) {
        local o = params.object;
        o.config.animations <- [];
        //add the animate function to each object
        o.getclass().newmember("animate", function(w, c = {}) {
            if (w in Animation) {
                o.config.animations.append(Animation[w](c));
            }
        });
        //add the animate_set function to each object
        o.getclass().newmember("animate_set", function(w, s) {
            if (w in Animation && s in AnimationSet && typeof AnimationSet[s] == "array") {
                foreach(c in AnimationSet[s])
                    o.config.animations.append(Animation[w](c));
            }
        });
    }

    //handles transitions
    function onTransition(params) {
        local ttime = params.ttime;
        local ttype = params.ttype;
        local var = params.var;
        local busy = false;
        foreach (o in ExtendedObjects.objects) {
            foreach (a in o.config.animations) {
                //start waiting transitions
                if (!a.running && ttype == a.config.when) startAnimation(ttime, o, a);
                if (a.running) {
                    if (ttype == a.config.when) {
                        if (a.config.wait) {
                            //execute waiting transitions
                            //TODO - this needs code to handle different kinds..
                            if (ttime < a.config.duration + a.config.delay) {
                                if (ttime - a.config.delay > 0) runFrame(ttime, o, a);
                                busy = true;
                            } else {
                                if (a.running) stopAnimation(ttime, o, a);
                            }
                            //CAN WE USE THIS INSTEAD?
                            //busy = update(ttime, o, a);
                        }
                        if (!a.config.wait && a.config.restart) {
                            //restart transition animations if restart option is enabled
                            a.createdAt = 0;
                            a.playCount = 0;
                        }
                    }
                    //continue executing non-waiting animations (even if there are waiting animations)
                    if (!a.config.wait) {
                        update(ttime, o, a);
                    }
                }
            }
        }
        return busy;
    }
    
    //handles tick
    function onTick(params) {
        //TODO - handle animations that don't "wait" or that don't rely on transitions
        local ttime = params.ttime;
        foreach (o in ExtendedObjects.objects) {
            foreach (a in o.config.animations) {
                //TODO - what needs to be done with this?
                //       look for non-running animations and see if we should start them
                if (!a.running) {
                    switch (a.config.when) {
                        case When.OnDemand:
                            break;
                        case When.Always:
                            startAnimation(ttime, o, a);
                            break;
                    }
                }
                //handle any running animations
                if (a.running) update(ttime, o, a);
            }
        }
    }

    function update(ttime, o, a) {
        local busy = false;
        ExtendedDebugger.notice("animating " + o.id + " - ttime: " + ttime + ", created: " + a.createdAt + ", current: " + a.currentTime + "end: " + (a.createdAt + a.config.duration + a.config.delay) + ", when: " + Animate.getWhen(a.config.when) + ", count: " + a.playCount);
        
        //if animation started in transition or has restarted, start it at current ttime
        if (a.createdAt == 0) a.createdAt = ttime;
        a.currentTime = ttime - a.createdAt;
        
        //only run this for the delay + the duration
        if (a.currentTime < a.config.delay + a.config.duration) {
            //handle repeating animation kinds
            switch (a.config.kind) {
                case "yoyo":
                case "loop":
                    //if (a.currentTime - a.config.delay > 0) runFrame(a.currentTime, o, a);
                    if (a.playCount < a.config.repeat) runFrame(a.currentTime * a.config.repeat, o, a);
                    if (a.currentTime >= a.config.duration / a.config.repeat) { 
                        //check play count for repeating animations
                        a.playCount += 1;
                        if (a.playCount < a.config.repeat) {
                            //restart repeating animations
                            if (a.config.kind == "yoyo" && a.playCount >=1 ) a.config.reverse = !a.config.reverse;
                            a.createdAt = 0;
                        } else {
                            stopAnimation(a.currentTime, o, a);
                        }
                    }
                    break;
                default:
                    if (a.currentTime - a.config.delay > 0) runFrame(a.currentTime, o, a);
                    break;
            }
            busy = true;
        } else {
            if (a.running) stopAnimation(a.currentTime, o, a);
        }
        return busy;
    }
    
    //starts the animation
    function startAnimation(ttime, o, a) {
        //if (a.config.restart) stopAnimation(ttime, o, a);
        a.createdAt = 0;
        a.running = true;
        a.start(o);
        ExtendedObjects.run_callback("onAnimationStart", { ttime = ttime, object = o, animation = a } );
    }
    
    //executes an animation frame
    function runFrame(ttime, o, a) {
        //execute frame
        a.frame(o, ttime - a.config.delay);
        ExtendedObjects.run_callback("onAnimationFrame", { ttime = ttime, object = o, animation = a } );
    }
    
    //stops the animation
    function stopAnimation(ttime, o, a) {
        a.running = false;
        a.createdAt = 0;
        a.currentTime = 0;
        a.playCount = 0;
        a.frame(o, a.config.duration);
        a.stop(o);
        ExtendedObjects.run_callback("onAnimationStop", { ttime = ttime, object = o, animation = a } );
    }
}

//The ExtendedAnimation class is the base class that will be used to create new animation types.
class ExtendedAnimation {
    running = false;
    createdAt = 0;
    currentTime = 0;
    playCount = 0;
    config = null;
    
    constructor(cfg) {
        config = cfg;
        //defaults
        if ("delay" in config == false) config.delay <- 0;
        if ("duration" in config == false) config.duration <- 500;
        if ("easing" in config == false) config.easing <- "out";
        if ("kind" in config == false) config.kind <- "transition";
        if ("repeat" in config == false) config.repeat <- 1;
        if ("restart" in config == false) config.restart <- false;
        if ("reverse" in config == false) config.reverse <- false;
        if ("tween" in config == false) config.tween <- "quad";
        if ("wait" in config == false) config.wait <- true;
        if ("when" in config == false) config.when <- Transition.FromOldSelection;
    }
    
    //return a user friend name for the animation
    function getType() { return "ExtendedAnimation" };
    
    //calculate allows you to use easing and tweens from one point to another in your Animation class
    function calculate(easing, tween, ttime, start, end, duration, amp = null, period = null) {
        local t = (ttime.tofloat() / duration).tofloat();
        local change = end - start;
        if (tween == "linear") return Animate.penner["linear"](t, start, change, duration);
        switch(easing) {
            case "outin":
                //outin uses existing in and out functions based of the first half or second half of the animation
                switch(tween) {
                    case "bounce":
                    case "expo":
                    case "elastic":
                        //these require ttime
                        if (ttime < duration / 2) {
                            return Animate.penner["out"][tween](ttime * 2, start, change / 2, duration);
                        } else {
                            return Animate.penner["in"][tween]((ttime * 2) - duration, start + change / 2, change / 2, duration);
                        }
                    default:
                        if (ttime < duration / 2) {
                            t = ((ttime.tofloat() * 2) / duration).tofloat();
                            return Animate.penner["out"][tween](t, start, change / 2, duration);
                        } else {
                            t = (((ttime.tofloat() * 2) - duration) / duration).tofloat();
                            return Animate.penner["in"][tween](t, start + change / 2, change / 2, duration);
                        }
                }
                break;
            default:
                switch(tween) {
                    case "bounce":
                    case "expo":
                    case "elastic":
                        //these require ttime
                        return Animate.penner[easing][tween](ttime, start, change, duration);
                    default:
                        return Animate.penner[easing][tween](t, start, change, duration);
                }
                break;
        }
    }
    
    //Animation classes will extend these methods
    function start(obj) { }
    function frame(obj, ttime) { }
    function stop(obj) { }
}

//WIP Animation config creator
class AnimationConfig {
    delay = 0;
    duration = 500;
    easing = "out";
    from = null;
    kind = "transition";
    property = "alpha";
    repeat = 1;
    reverse = false;
    to = null;
    tween = "linear";
    wait = true;
    when = Transition.FromOldSelection;
    
    function copy() { return clone(config); }
    function create() { return this; }

    function setDelay(d) { delay = d; return this; }
    function setDuration(d) { duration = d; return this; }
    function setEasing(e) { easing = e; return this; }
    function setFrom(f) { from = f; return this; }
    function setKind(k) { kind = k; return this; }
    function setProperty(p) { property = p; return this; }
    function setRepeat(r) { repeat = r; return this; }
    function setReverse(r) { reverse = r; return this; }
    function setTo(t) { to = t; return this; }
    function setTween(t) { tween = t; return this; }
    function setTransition(t) { when = t; return this; }
    function setWait(w) { wait = w; return this; }
}

When <- {
    StartLayout = 0,
    EndLayout = 1,
    ToNewSelection = 2,
    FromOldSelection = 3,
    ToGame = 4,
    FromGame = 5,
    ToNewList = 6,
    OnDemand = 100,
    Always = 101
}

//add our callbacks that we will handle
ExtendedObjects.add_callback(Animate, "onObjectAdded");
ExtendedObjects.add_callback(Animate, "onTransition");
ExtendedObjects.add_callback(Animate, "onTick");


//An empty table of animation types that will be available with object.animate(type, cfg)
Animation <- {}

//Pre-included animations
fe.do_nut("extended/animations/property/property.nut");
fe.do_nut("extended/animations/translate/translate.nut");


//An empty table of predefined animation sets that will be available with object.animate_set(set)
AnimationSet <- { }

//Pre-included sets
fe.do_nut("extended/animations/sets.nut");
