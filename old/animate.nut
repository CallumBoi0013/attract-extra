///////////////////////////////////////////////////
// Attract-Mode Frontend - Animate library
///////////////////////////////////////////////////
//  The animation library allows you to easily add animations to your layout objects.
//
//  Requirements:
//      This library requires the 'extended' objects library (extended.nut)
//
//  Usage:
//      //load required files
//      fe.do_nut("extended.nut");
//      fe.do_nut("animate.nut");
//      ...
//      //add objects (note the addition of an id before the standard parameters)
//      //you can access objects later by the id you provided
//      ExtendedObjects.add_image("logo", "logo.png", 0, 0, fe.layout.width, fe.layout.height);
//      ExtendedObjects.add_artwork("game", "snap", 0, 0, fe.layout.width, fe.layout.height);
//      //add your animations - object.addAnimation(which, config );
//      ExtendedObjects.getObject("logo").addAnimation("translate");
//      //you can provide your own configuration options for the animation, options are shown below
//      ExtendedObjects.getObject("game").addAnimation("translate", { duration = 1500, when = Transition.FromOldSelection, easing = "out", tween = "back", from = "offscreenbottom", to = "bottom" });
//
//  ** PARAMETERS **********************************************************
//  which:                  which animation to run: "translate", "property"
//  config:                 optional table (surround with { } ) that contains your animation config options
//
//  ** CONFIG OPTIONS ******************************************************
//  OPTION              DEFAULT                         DESCRIPTION
//  when                Transition.FromOldSelection     when to run animation, one of Transition.TYPE provided by Attract-mode
//  delay:              0                               delay before the animation starts in ms
//  duration:           1000                            length of animation in ms
//  easing              out                             easing animation type to use: in, out, inout, outin
//  tween               quad                            tween animation to use:
//                                                      You can use one of the following: (See: http://easings.net/# for more info)
//                                                      back, bounce, circle, cubic, elastic
//                                                      expo, linear, quad, quart, quint, sine
//                                                      quadbezier (an arc - WIP)
//                                                      
//  reverse             false                           perform animation in reverse (true|false)
//
//  * PROPERTY *
//  property            alpha                           the property to animate
//  from                                                animation starts at this
//  to:                                                 animation ends at this
//  Default 'from' and 'to' differ depending on property
//                      alpha: 0 to 255
//                      x: offscreenleft to start
//                      y: offscreentop to start
//                      width: object current width
//                      height: object current height
//                      rotate: 0 to 90
//
//  * TRANSLATE *
//  from:               offscreenbottom                 animation starts from this position - an array [ x, y ] or position "center"
//  to:                 center                          animation goes to this position - an array [ x, y ] or position "bottom"
//
//  Positions: from and to
//
//  You can use one of the following for from or to:
//  - object positions -
//  start|last|current
//  - positions on the screen -
//  top|left|right|bottom|center
//  topleft|topright|bottomleft|bottomright
//  - positions off the screen -
//  offscreentop|offscreenleft|offscreenright|offscreenbottom
//  offscreentopleft|offscreentopright|offscreenbottomleft|offscreenbottomright
//
//  A FEW NOTES:
//  from = "current" to = wherever would be a one-time animation since on the next animation the from location would be the same as where its already at
//  from = "last" might be tricky to use, but if one animation finishes before the other starts, it might be useful
//  certain 'easing' and 'tween' options might be odd in some situations
//  easing 'out' animations probably aren't what you expect, these would be best used if you are 
//  ** INTERNAL ************************************************************
//  started:                whether the animation has started (true|false)
//  start:                  calculated start position of the animation
//  end:                    calculated end position of the animation
/////////////////////////////////////////////

/*
try {
    exists = ExtendedObjects.VERSION;
} catch (err) {
    local error = fe.add_text("Required library ExtendedObjects not found.", 0, fe.layout.height / 2, fe.layout.width, 30);
}
*/

class AnimationConfig {
    config = null;
    constructor() {
        this.config = {};
        return this;
    }
    function create() { return config; }
    function setDelay(d) { config.delay <- d; return this; }
    function setDuration(d) { config.duration <- d; return this; }
    function setEasing(e) { config.easing <- e; return this; }
    function setFrom(f) { config.from <- f; return this; }
    function setProperty(p) { config.property <- p; return this; }
    function setReverse(r) { config.reverse <- r; return this; }
    function setTo(t) { config.to <- t; return this; }
    function setTransition(t) { config.when <- t; return this; }
    function setTween(t) { config.tween <- t; return this; }
}

class Animate {
    config = null;
    
    constructor(which, userconfig={}) {
        if (userconfig != null) config = userconfig else config = {};

        //user config variable defaults
        if ("when" in config == false) config.when <- Transition.FromOldSelection;
        if ("duration" in config == false) config.duration <- 1000;
        if ("delay" in config == false) config.delay <- 0;
        if ("reverse" in config == false) config.reverse <- false;
        if ("easing" in config == false) config.easing <- "out";
        if ("tween" in config == false) config.tween <- "back";

        config.started <- false;
        config.current <- 0.0;
        config.which <- which;
    }
        
    function startAnimation(obj) {
        //these are remembered for animation "last" position
        obj.config.lastX <- obj.getX();
        obj.config.lastY <- obj.getY();
        
        //perform initialization prior to the animation
        switch (config.which) {
            case "property":
                if ("property" in config == false) config.property <- "alpha";
                local defaults = {
                    "alpha": [ 0, 255 ],
                    "x": [ "offscreenleft", "start" ],
                    "y": [ "offscreentop", "start" ],
                    "skew_x": 10,
                    "skew_y": 10,
                    "pinch_x": 10,
                    "pinch_y": 10,
                    "width": [ obj.getWidth(), obj.getWidth() + 50 ],
                    "height": [ obj.getHeight(), obj.getHeight() + 50 ],
                    "rotation": [ 0, 90 ],
                }
                if ("from" in config == false) config.from <- defaults[config.property][0];
                if ("to" in config == false) config.to <- defaults[config.property][1];

                //replace string value positions in from and to with correct positions
                if (config.property == "x" || config.property == "y") {
                    local point = 0;
                    if (config.property == "y") point = 1;
                    if (typeof config.from == "string") config.start <- ExtendedObjects.getPosition(config.from, obj)[point] else config.start <- config.from;
                    if (typeof config.to == "string") config.end <- ExtendedObjects.getPosition(config.to, obj)[point] else config.end <- config.to;
                } else {
                    config.start <- config.from;
                    config.end <- config.to;
                }
                break;
            case "translate":
            default:
                //standard point to point animation
                local defaults = {
                    "from": ExtendedObjects.getPosition("start", obj),
                    "to": ExtendedObjects.getPosition("center", obj)
                }
                if ("from" in config == false) config.from <- defaults["from"];
                if ("to" in config == false) config.to <- defaults["to"];

                //replace string value positions in from and to with correct positions
                if (typeof config.from == "string") config.start <- ExtendedObjects.getPosition(config.from, obj) else config.start <- config.from;
                if (typeof config.to == "string") config.end <- ExtendedObjects.getPosition(config.to, obj) else config.end <- config.to;
                break;
        }
    }
    
    function frame(obj, ttime) {
        local t = (ttime.tofloat() / config.duration).tofloat();
        config.current = t;
        switch (config.which) {
            case "property":
                local value;
                if (config.reverse) value = calc(t, ttime, config.end, config.start) else value = calc(t, ttime, config.start, config.end);
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
                break;
            case "translate":
            default:
                //standard point to point animation
                local point;
                if (config.reverse) {
                    if (config.tween == "quadbezier") {
                        local arc = 1.25;
                        local controlpoint = [ (config.end[0] + config.end[1]) / 2 * arc, (config.start[0] + config.start[1]) / 2 * arc ]; 
                        local bezier = quadbezier(config.end[0], config.end[1], controlpoint[0], controlpoint[1], config.start[0], config.start[1], t)
                        point = [ bezier[0], bezier[1] ];
                    } else {
                        point = [   calc(t, ttime, config.end[0], config.start[0]),
                                    calc(t, ttime, config.end[1], config.start[1])
                                ];
                    }
                } else {
                    if (config.tween == "quadbezier") {
                        local arc = 1.25;
                        local controlpoint = [ (config.start[0] + config.start[1]) / 2 * arc, (config.end[0] + config.end[1]) / 2 * arc ]; 
                        local bezier = quadbezier(config.start[0], config.start[1], controlpoint[0], controlpoint[1], config.end[0], config.end[1], t);
                        point = [ bezier[0], bezier[1] ];
                    } else {
                        point = [   calc(t, ttime, config.start[0], config.end[0]),
                                    calc(t, ttime, config.start[1], config.end[1])
                                ];
                    }
                }
                obj.setPosition(point);
                break;
        }
    }
    
    function stopAnimation(obj) {
        //perform finalization after the animation
    }
    
    function reset() {
        config.started = false;
        config.current = 0.0;
    }
    
    function quadbezier(p1x, p1y, cx, cy, p2x, p2y, t) {
        local c1x = p1x + (cx - p1x) * t;
        local c1y = p1y + (cy - p1y) * t;
        local c2x = cx + (p2x - cx) * t;
        local c2y = cy + (p2y - cy) * t;
        local tx = c1x + (c2x - c1x) * t;
        local ty = c1y + (c2y - c1y) * t;
        return [ tx, ty ];
    }
    
    //  Penner's Easing equations
    //  http://www.robertpenner.com/easing/
    //  - t is already pass as (ttime / duration) since many functions need that
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
    
    //t = (ttime / duration) but some functions need ttime instead so it is included
    function calc(t, ttime, start, end, amp = null, period = null) {
        local change = end - start;
        //TODO provide value for p, a or s for back, expo, elastic from config
        if (config.easing == "outin") {
            //TODO fix outin animations (they disappear)
            if (ttime < config.duration / 2) return penner["out"][config.tween](t * 2, start, change / 2, config.duration) else return penner["in"][config.tween]((t * 2) - config.duration, start + change / 2, change / 2, config.duration);
        } else {
            switch (config.tween) {
                case "linear":
                    return penner["linear"](t, start, change, config.duration);
                case "bounce":
                    /*
                        if (config.easing == "in" && config.tween == "bounce") return change - penner["out"]["bounce"](ttime - config.duration, start, change, config.duration) + start;
                        if (config.easing == "inout" && config.tween == "bounce") {
                            if (ttime < config.duration / 2) return penner["in"]["bounce"](ttime * 2, 0, change, config.duration) * 0.5 + start else return penner["out"]["bounce"](ttime * 2 - config.duration, 0, change, config.duration) * 0.5 + change * 0.5 + start;
                        }
                    */
                case "expo":
                case "elastic":
                    return penner[config.easing][config.tween](ttime, start, change, config.duration);
                default:
                    //special case scenarios (it's ugly i know!)
                    return penner[config.easing][config.tween](t, start, change, config.duration);
            }
        }
    }
}
