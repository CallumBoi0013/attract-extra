#ExtendedObjects and Animate library

The extended objects library extends the capabilities of the existing Attract-Mode objects.

**ExtendedObjects**
ExtendedObjects is a .nut file you can include with your Attract-Mode layout to provide more functionality. It is also designed for expandibility, allowing developers to create new objects made from multiple other objects or add new animations to be used in your layout.

**Animate**
Animate is a .nut file that relies on ExtendedObjects to make it easy to add animations to objects in your Attract-Mode layout.


##ExtendedObjects Usage
----------------
    //load required file
    fe.do_nut("extended\extended.nut");
    //add objects (note the addition of an id before the standard parameters)
    //you can access objects later by the id you provided
    ExtendedObjects.add_artwork("screenshot", "snap", 0, 0, fe.layout.width, fe.layout.height);
    ExtendedObjects.get("screenshot").setShadow(true);
    //add the debug overlay
    ExtendedObjects.add_debug();

If you want to use additional objects, you will need to include them currently:
    fe.do_nut("extended\objects\orbit_wheel.nut");
    ExtendedObjects.add_wheel("mywheel", 5, 0, 0, fe.layout.width, fe.layout.height);

##Animate Usage
----------------
```Squirrel
    //load required files
    fe.do_nut("extended\extended.nut");
    fe.do_nut("extended\animate.nut");
    //add objects (note the addition of an id before the standard parameters)
    //you can access objects later by the id you provided
    ExtendedObjects.add_image("logo", "logo.png", 0, 0, fe.layout.width, fe.layout.height);
    ExtendedObjects.add_artwork("game", "snap", 0, 0, fe.layout.width, fe.layout.height);
    //add your animations - object.animate_translate(cfg) or object.animate_property(cfg);
    ExtendedObjects.getObject("logo").animate_translate();
    //you can provide your own configuration options for the animation in a table, options are shown below
    ExtendedObjects.getObject("game").animate_translate({ duration = 1500, when = Transition.FromOldSelection, easing = "out", tween = "back", from = "offscreenbottom", to = "bottom" });
```

###Animation Parameters
    cfg:                 optional table (surround with { } ) that contains your animation config options

###Animation Config variables
    OPTION              DEFAULT                         DESCRIPTION
    when                Transition.FromOldSelection     when to run animation, one of Transition.TYPE provided by Attract-mode
    delay:              0                               delay before the animation starts in ms
    duration:           1000                            length of animation in ms
    easing              out                             easing animation type to use: in, out, inout, outin
    tween               quad                            tween animation to use:
                                                      You can use one of the following: (See: http:easings.net/# for more info)
                                                      back, bounce, circle, cubic, elastic
                                                      expo, linear, quad, quart, quint, sine
                                                      quadbezier (an arc - WIP)
                                                      
    reverse             false                           perform animation in reverse (true|false)

###Property Animation (object.animate_property(cfg))
    property            alpha                           the property to animate
    from                                                animation starts at this
    to:                                                 animation ends at this
    Default 'from' and 'to' differ depending on property
                      alpha: 0 to 255
                      x: offscreenleft to start
                      y: offscreentop to start
                      width: object current width
                      height: object current height
                      rotate: 0 to 90

###Translate Animation (object.animate_translate(cfg))
    from:               offscreenbottom                 animation starts from this position - an array [ x, y ] or position "center"
    to:                 center                          animation goes to this position - an array [ x, y ] or position "bottom"

###Positions
A nice feature of using ExtendedObjects is you can use positions to easily place objects at certain locations. These positions can also be used for animations 'from' or 'to' variables in your animation config:
**object positions**
```
    start|last|current
```
**screen positions**
```
    top|left|right|bottom|center
    topleft|topright|bottomleft|bottomright
```
**offscreen positions**
```
    offtop|offleft|offright|offbottom
    offtopleft|offtopright|offbottomleft|offbottomright
    offtopleftx|offtoprightx|offbottomleftx|offbottomrightx
    offtoplefty|offtoprighty|offbottomlefty|offbottomrighty
```

###A Few Notes:
* positions are primarily for translate animations, but do work for x and y property animations
* positions for x and y - remember you are only setting x or y - so if you go to 'bottomright', it's only going to go along the x or y axis
* from = "current" to = wherever would be a one-time animation since on the next animation the from location would be the same as where its already at
* from = "last" might be tricky to use, but if one animation finishes before the other starts, it might be useful
* certain 'easing' and 'tween' options might be odd in some situations
* easing 'out' animations probably aren't what you expect, these would be best used if you are 

##Developers
*** WIP ***
Another nice feature of ExtendedObjects is it makes it pretty simple for coders to create new objects or animations.

###Creating Objects
You can look at some of the WIP objects for examples in extended\objects\.

To create a new object that can be used with ExtendedObjects:
*create a new folder & file in: layouts\extended\objects\myobject\myobject.nut
*create a class extending ExtendedObject
```Squirrel
    class MyObject extends ExtendedObject {
        constructor(id, x, y, w, h) {
            base.constructor(id, x, y);
            //initialize your objects
            //NOTE: current you must set at least one object, working on this
            object = fe.add_text("", 0, 0, 0, 0);
            //add any callbacks you are interested in using
            ExtendedObjects.add_callback(this, "onTick");
            ExtendedObjects.add_callback(this, "onTransition");
        }
        function onTick(params) {
            //Note all params for callbacks are past in through a 'params' object
            local ttime = params.ttime;
            //do your work here
        }
        function onTransition(params) {
            local ttype = params.ttype;
            local var = params.var;
            local ttime = params.ttime;
            //do your work here
            
            //You must return false if you are not doing continuous work
            return false;
        }
    }
```
*add a hook so users can add your object:
```Squirrel
    ExtendedObjects.add_myobject <- function(id, x, y, w, h) {
        return ExtendedObjects.add(Wheel(id, x, y, w, h));
    }
```
*In your layout.nut file, add your includes and object:
```Squirrel
    fe.do_nut("extended\extended.nut");
    fe.do_nut("extended\animate.nut");
    fe.do_nut("extended\objects\myobject\myobject.nut");
    ExtendedObjects.add_myobject("cool", 0, 0, 100, 100);
```

###Creating Animations
***WIP***
You can look at some of the WIP animations for examples in extended\anims\.

To create a new animation that can be used with ExtendedObjects:
*create a new folder & file in: layouts\extended\anims\myanim\myanim.nut
*create a class extending ExtendedAnimation:
```Squirrel
    class MyAnim extends ExtendedAnimation {
        constructor(config) {
            base.constructor(config);
            //add any properties and their defaults to the config that you might want users to change
            if ("my_property" in config == false) config.my_property <- "my_value";
        }
        //return a name for your object type
        function getType() { return "MyAnim"; }
        function start(obj) {
            base.start(obj);
            //your animation is starting, initialize it
            //obj is an ExtendedObject the animation will run on
            
            //add a function to your animation when an ExtendedObject has been added to a layout
            ExtendedObjects.add_callback(this, "onObjectAdded");
        }
        function frame(obj, ttime) {
            base.frame(obj);
            //run your animated frame
            //protip: you can use the calculate(time, duration, start, end) to get automated easings from point to point
        }
        function stop(obj) {
            base.stop(obj);
            //finish up
        }
        function onObjectAdded(params) {
            local o = params.object;
            o.getclass().newmember("animate_myanim", function(c = {}) {
                o.config.animations.append(MyAnim(c));
            });
        }
    }
```
*In your layout.nut file, add your includes and object:
```Squirrel
    fe.do_nut("extended\extended.nut");
    fe.do_nut("extended\animate.nut");
    fe.do_nut("extended\anims\myanim\myanim.nut");
    local obj = ExtendedObjects.add_image("img", "frame.png", 0, 0, 100, 100);
    local cfg = {
                    when = ...
                    ...
                    my_property = ""
                }
    obj.my_anim(cfg);
```

### Developing Further
***WIP***
ExtendedObjects and Animate can be extended even further than objects and animations. Any class you create can hook into ExtendedObjects or Animations via callbacks:

*Create a nut file: my.nut
*Create a class
```Squirrel
    class MyThing {
        constructor() {
            //hook into ExtendedObjects or Animate callbacks
            ExtendedObjects.add_callback(this, "onObjectAdded");
            ExtendedObjects.add_callback(this, "onTick");
            ExtendedObjects.add_callback(this, "onTransition");
            ExtendedObjects.add_callback(this, "onAnimationStart");
            ExtendedObjects.add_callback(this, "onAnimationFrame");
            ExtendedObjects.add_callback(this, "onAnimationStop");
            //add your own callbacks for other interested listeners
            local params = {
                param1 = "a",
                param2 = "b"
            }
            ExtendedObjects.run_callback("onMyThingInitialized", params);
        }
        //if the callback functions exist, they will be executed
    }
```
* Other interested classes can now listen for your callbacks using ExtendedObjects.add_callback("onMyThingInitialized");

##Issues
This is a list of current issues I am addressing:
* does not verify availability of ExtendedObjects and Animate library
* animations cannot be interrupted (move to tick instead of transition)
* fix these anims: bounce, inout expo, all outin anims
* ExtendedObject must currently add an empty object
* does not validate user entered config variables
* animations currently added as add_property(cfg) and add_translate(cfg), should be animate("animation", cfg)

##Enhancements
This is a list of todo items I am considering adding to the library:
* improve method chaining config creator
* easy include custom objects or animation classes (add_object("objectname"))
* allow positions when adding objects
* transform - scale + rotate from center
* color - from rgb to rgb
* multiple transitions in animation config
* reorder objects on the draw list
* clones (use weakrefs?)    
* new objects (marquee wheel, etc)
* indefinite animations and loop (reverse, restart, indefinite or set # of times)
* quad bezier improvements (control point, arc option)
* animation chains - chain multiple animations together (without needing multiple and delays)
* animation paths - multiple points animations
* screen transitions - move all objects on screen (ex. everything at top of screen slides up, everything at bottom slides down)
* work with shaders, sound, plugin_command
* utilities library? (user friendly string handling for game_info)
* animation presets
* other animations: Arc Grow, Blur, Bounce, Bounce Around 3D, Bounce Random, Chase Ease, Elastic, Elastic Bounce, Fade, Flag, Flip, Grow, Grow Blur Grow Bounce, Grow Center Shrink, Grow X, Grow Y, Pendulum Pixelate, Pixelate Zoom out, Rain Float, Scroll, Stripes, Stripes 2 Strobe, Sweep Left, Sweep Right
* other animations: Fade, Fly In, Float In, Split, Wipe, Shape, Wheel, Random Bars, Grow & Turn, Zoom, Swivel, Bounce, Pulse, Color Pulse, Teeter, Spin, Grow/Shrink,  Desaturate, Darken, Lighten, Transparency, Object Color,   Cut, Fade, Push, Wipe, Split, Reveal, Random bars, Shape, Uncover, Flash Fall Over, Drape, Curtains, Wind, Prestige, Fracture, Crush, Peel off Page Curl
* resting animations: Hover, Pulse, Rock, Spin
* Modified Orbit with options (# of slots, horizontal/vertical, spacing)