/*
 blocking/locked/waitUntilFinished animation config option will not advance to next transition until finished
 use AnimationConfig class instead of table to allow for proper method chaining
 animation position not ending up accurate - t wrong?
 how to request animation by name in add_animation
 animation config creator
 move animation piece into onTick - just start/stop from onTransition?
 fix broke animations (all outin, bounce)
 provide values for p, a or s for back, expo, elastic from config
*/

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
            "back": function (t, b, c, d, s = null) { if (s == null) s = 1.70158; return c * t * t * ((s + 1) * t - s) + b; }
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
            "bounce": function (ttime, b, c, d) { local t = ttime.tofloat() / d; if (t < 1 / 2.75) return c * (7.5625 * t * t) + b; if (t < 2 / 2.75) { t = t - (1.5 / 2.75); return c * (7.5625 * t * t + 0.75) + b; } else if (t < 2.5 / 2.75) {t = t - (2.25 / 2.75); return c * (7.5625 * t * t + 0.9375) + b; } else { t = t - (2.625 / 2.75); return c * (7.5625 * t * t + 0.984375) + b; } }
        },
        "inout": {
            "quad": function (t, b, c, d) { t = t * 2; if (t < 1) return c / 2 * pow(t, 2) + b; return -c / 2 * ((t - 1) * (t - 3) - 1) + b; },
            "cubic": function (t, b, c, d) { t = t * 2; if (t < 1) return c / 2 * t * t * t + b; t = t - 2; return c / 2 * (t * t * t + 2) + b; },
            "quart": function (t, b, c, d) {  t = t * 2; if (t < 1) return c / 2 * pow(t, 4) + b; t = t - 2; return -c / 2 * (pow(t, 4) - 2) + b; },
            "quint": function (t, b, c, d) { t = t * 2; if (t < 1) return c / 2 * pow(t, 5) + b; t = t - 2; return c / 2 * (pow(t, 5) + 2) + b; },
            "sine": function (t, b, c, d) { return -c / 2 * (cos(PI * t) - 1) + b; },
            "expo": function (ttime, b, c, d) { if (ttime == 0) return b; if (ttime == d) return b + c; local t = (ttime.tofloat() / d) / 2; if (t < 1) return c / 2 * pow(2, 10 * (t - 1)) + b; t = t - 1; return c / 2 * (-pow(2, -10 * t) + 2) + b; },
            "circle": function (t, b, c, d) { t = t * 2; if (t < 1) return -c / 2 * (sqrt(1 - t * t) - 1) + b; t = t - 2; return c / 2 * (sqrt(1 - t * t) + 1) + b; },
            "elastic": function (ttime, b, c, d, a = null, p = null) { if (ttime == 0) return b; local t = (ttime.tofloat() / d) * 2; if (t == 2) return b + c; if (p == null) p = d * (0.3 * 1.5); local s; if (a == null || a < abs(c)) { a = c;  s = p / 4; } else { s = p / (PI * 2) * asin(c / a); } if (t < 1) return -0.5 * (a * pow(2, 10 * (t - 1)) * sin((t * d - s) * (PI * 2) / p)) + b; return a * pow(2, -10 * (t - 1)) * sin((t * d - s) * (PI * 2) / p) * 0.5 + c + b; },
            "back": function (t, b, c, d, s = null) { if (s == null) s = 1.70158; s = s * 1.525; t = t * 2; if (t < 1) return c / 2 * (t * t * ((s + 1) * t - s)) + b; t = t - 2; return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b; }
        }
    }
    function onObjectAdded(params) {
        local o = params.object;
        o.config.animations <- [];
        o.getclass().newmember("animate_property", function(c = {}) {
            o.config.animations.append(PropertyAnimation(c));
        });
        o.getclass().newmember("animate_translate", function(c = {}) {
            o.config.animations.append(TranslateAnimation(c));
        });
    }

    function onTransition(params) {
        local ttype = params.ttype;
        local var = params.var;
        local ttime = params.ttime;
        local busy = false;
        foreach (o in ExtendedObjects.objects) {
            foreach (a in o.config.animations) {
                if (ttype == a.config.when) {
                    if (ttime < a.config.duration + a.config.delay) {
                        //run animation
                        if (ttime - a.config.delay > 0) {
                            if (!a.running) {
                                a.running = true;
                                a.start(o);
                                ExtendedObjects.run_callback("onAnimationStart", { ttime = ttime, object = o, animation = a } );
                            }
                            a.frame(o, ttime - a.config.delay);
                            ExtendedObjects.run_callback("onAnimationFrame", { ttime = ttime, object = o, animation = a } );
                        }
                        busy = true;
                    } else {
                        //stop animation
                        if (a.running) {
                            a.running = false;
                            a.frame(o, a.config.duration);
                            a.stop(o);
                            a.reset();
                        }
                        ExtendedObjects.run_callback("onAnimationStop", { ttime = ttime, object = o, animation = a } );
                    }
                }
            }
        }
        if (busy) return true;
        return false;
    }
}

ExtendedObjects.add_callback(Animate, "onObjectAdded");
ExtendedObjects.add_callback(Animate, "onTransition");
ExtendedObjects.add_callback(Animate, "onTick");

class ExtendedAnimationConfig {
    transition = Transition.FromOldSelection;
    duration = 500;
    delay = 0;
    easing = "out";
    tween = "linear";
    from = null;
    to = null;
    reverse = false;
    property = "alpha";
    
    function copy() { return clone(config); }
    function create() { return this; }
    function setDelay(d) { delay = d; return this; }
    function setDuration(d) { duration = d; return this; }
    function setEasing(e) { easing = e; return this; }
    function setFrom(f) { from = f; return this; }
    function setProperty(p) { property = p; return this; }
    function setReverse(r) { reverse = r; return this; }
    function setTo(t) { to = t; return this; }
    function setTransition(t) { transition = t; return this; }
    function setTween(t) { tween = t; return this; }
}

class ExtendedAnimation {
    running = false;
    config = null;
    constructor(cfg) {
        config = cfg;
        //defaults
        if ("when" in config == false) config.when <- Transition.FromOldSelection;
        if ("duration" in config == false) config.duration <- 500;
        if ("delay" in config == false) config.delay <- 0;
        if ("reverse" in config == false) config.reverse <- false;
        if ("easing" in config == false) config.easing <- "out";
        if ("tween" in config == false) config.tween <- "quad";
    }
    function getType() { return "ExtendedAnimation" };
    function calculate(ttime, duration, start, end, amp = null, period = null) {
        local t = (ttime.tofloat() / duration).tofloat();
        local change = end - start;
        switch(config.tween) {
            case "bounce":
            case "expo":
            case "elastic":
                //these require ttime
                return Animate.penner[config.easing][config.tween](ttime, start, change, config.duration);
            case "linear":
                return Animate.penner["linear"](t, start, change, config.duration);
            default:
                return Animate.penner[config.easing][config.tween](t, start, change, config.duration);
        }
    }
    //extend these
    function start(obj) {  }
    function frame(obj, ttime) {  }
    function stop(obj) {  }
    function reset() { running = false;}
}

class PropertyAnimation extends ExtendedAnimation {
    constructor(config) {
        base.constructor(config);
        //set defaults
        if ("property" in config == false) config.property <- "alpha";
    }
    function getType() { return "PropertyAnimation"; }
    function start(obj) {
        base.start(obj);
        local defaults = {
            "alpha": [ 0, 255 ],
            "x": [ "offleft", "top" ],
            "y": [ "offtop", "top" ],
            "skew_x": [ 0, 10 ],
            "skew_y": [ 0, 10 ],
            "pinch_x": [ 0, 10 ],
            "pinch_y": [ 0, 10 ],
            "width": [ obj.getWidth(), obj.getWidth() + 50 ],
            "height": [ obj.getHeight(), obj.getHeight() + 50 ],
            "rotation": [ 0, 90 ],
        }
        if ("from" in config == false) config.from <- defaults[config.property][0];
        if ("to" in config == false) config.to <- defaults[config.property][1];
        if (config.property == "x" || config.property == "y") {
            local point = 0;
            if (config.property == "y") point = 1;
            if (typeof config.from == "string") config.start <- POSITIONS[config.from](obj)[point] else config.start <- config.from;
            if (typeof config.to == "string") config.end <- POSITIONS[config.to](obj)[point] else config.end <- config.to;
        } else {
            config.start <- config.from;
            config.end <- config.to;
        }
    }
    function frame(obj, ttime) {
        local value;
        if (config.reverse) value = calculate(ttime, config.duration, config.end, config.start) else value = calculate(ttime, config.duration, config.start, config.end);
        switch (config.property) {
            case "x":
                obj.setX(value);
                break;
            case "y":
                obj.setY(value);
                break;
            case "skew_x":
                obj.setSkewX(value);
                break;
            case "skew_y":
                obj.setSkewY(value);
                break;
            case "pinch_x":
                obj.setPinchX(value);
                break;
            case "pinch_y":
                obj.setPinchY(value);
                break;
            case "width":
                obj.setWidth(value);
                break;
            case "height":
                obj.setWidth(value);
                break;
            case "rotation":
                obj.setRotation(value);
                break;
            case "alpha":
                obj.setAlpha(value);
                break;
        }
    }
}

class TranslateAnimation extends ExtendedAnimation {
    constructor(config) {
        base.constructor(config);
    }
    function getType() { return "TranslateAnimation"; }
    function start(obj) {
        base.start(obj);
        //set defaults
        local defaults = {
            "from": "left",
            "to": "center"
        }
        if ("from" in config == false) config.from <- defaults["from"];
        if ("to" in config == false) config.to <- defaults["to"];
        //replace string value positions in from and to with correct positions
        if (typeof config.from == "string") config.start <- POSITIONS[config.from](obj) else config.start <- config.from;
        if (typeof config.to == "string") config.end <- POSITIONS[config.to](obj) else config.end <- config.to;
    }
    function frame(obj, ttime) {
        local point;
        if (config.reverse) {
            if (config.tween == "quadbezier") {
                local arc = 1.25;
                local controlpoint = [ (config.end[0] + config.end[1]) / 2 * arc, (config.start[0] + config.start[1]) / 2 * arc ]; 
                local bezier = quadbezier(config.end[0], config.end[1], controlpoint[0], controlpoint[1], config.start[0], config.start[1], t)
                point = [ bezier[0], bezier[1] ];
            } else {
                point = [   calculate(ttime, config.duration, config.end[0], config.start[0]),
                            calculate(ttime, config.duration, config.end[1], config.start[1])
                        ];
            }
        } else {
            if (config.tween == "quadbezier") {
                local arc = 1.25;
                local controlpoint = [ (config.start[0] + config.start[1]) / 2 * arc, (config.end[0] + config.end[1]) / 2 * arc ]; 
                local bezier = quadbezier(config.start[0], config.start[1], controlpoint[0], controlpoint[1], config.end[0], config.end[1], t);
                point = [ bezier[0], bezier[1] ];
            } else {
                point = [   calculate(ttime, config.duration, config.start[0], config.end[0]),
                            calculate(ttime, config.duration, config.start[1], config.end[1])
                        ];
            }
        }
        obj.setPosition(point);
    }
}