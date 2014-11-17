///////////////////////////////////////////////////
// Attract-Mode Frontend - ExtendedObjects library
///////////////////////////////////////////////////
//  The extended objects library extends the capabilities of the existing Attract-Mode objects.
//
//  If you are interested in learning squirrel to help with this library, I recommend checking this out:
//  http://electricimp.com/docs/resources/squirrelcrib/
//
//  Usage:
//      //load required file
//      fe.do_nut("extended.nut");
//      //add objects (note the addition of an id before the standard parameters)
//      //you can access objects later by the id you provided
//      ExtendedObjects.add_artwork("screenshot", "snap", 0, 0, fe.layout.width, fe.layout.height);
//      ExtendedObjects.getObject("screenshot").setShadow(true);
//
//  TODO:
//      verify availability of Animate
//      reorder objects on the draw list
//      can we move Animation transition and tick code to Animate?
//      consider how to handle multiple callbacks for transition and tick
//          any callbacks cannot return true or false, which might be needed
//      clones (use weakrefs?)    
//      new objects (marquee wheel, etc)
//      
/////////////////////////////////////////////
enum EXTENDED_CALLBACKS {
    onObjectAdded = 1,
    onTick = 2,
    onTransition = 3,
    onAnimationStart = 4,
    onAnimationStop = 5,
    onAnimationRunning = 6
}

fe.layout.width = ScreenWidth;
fe.layout.height = ScreenHeight;
fe.add_transition_callback( "extended_objects_transition" );
fe.add_ticks_callback( "extended_objects_tick" );

function extended_objects_transition( ttype, var, ttime ) {
    //run animations
    local animated = false;
    foreach (obj in ExtendedObjects.objects) {
        if (obj.animations.len() > 0) {
            foreach (anim in obj.animations) {
                if (ttype == anim.config.when) {
                    if (ttime <= anim.config.duration + anim.config.delay) {
                        //run animation
                        if (!anim.config.started) {
                            anim.config.started = true;
                            anim.startAnimation(obj);
                            ExtendedObjects.run_callback(EXTENDED_CALLBACKS.onAnimationStart, { ttime = ttime, object = obj, animation = anim} );
                        }
                        if (ttime - anim.config.delay > 0) anim.frame(obj, ttime - anim.config.delay);
                        animated = true;
                        ExtendedObjects.run_callback(EXTENDED_CALLBACKS.onAnimationRunning, { ttime = ttime, object = obj, animation = anim} );
                    } else {
                        //final frame and stop animation
                        if (anim.config.started) {
                            anim.config.started = false;
                            anim.frame(obj, anim.config.duration);
                            anim.stopAnimation(obj);
                            anim.reset();
                            ExtendedObjects.run_callback(EXTENDED_CALLBACKS.onAnimationStop, { ttime = ttime, object = obj, animation = anim} );
                        }
                    }
                }
                //add start ONLY of indefinite animations
            }
        }
    }
    switch (ttype) {
        case Transition.EndLayout:
            //stop any indefinite animations
            break;
    }
    ExtendedObjects.run_callback(EXTENDED_CALLBACKS.onTransition, { ttype = ttype, var = var, ttime = ttime });
    if ( animated ) return true;
    return false;
}

function extended_objects_tick( ttime ) {
    //indefinite animations will run here
    ExtendedObjects.run_callback(EXTENDED_CALLBACKS.onTick, { ttime = ttime });
}

class ExtendedObjects {
    VERSION = "1.0";
    ASPECT_RATIO = ScreenWidth / ScreenHeight;
    callbacks = [];
    objects = [];
    
    function add_callback(when, func) {
        callbacks.append(Callback(when, func));
    }

    function run_callback(when, params = {}) {
        foreach (cb in callbacks) {
            if (cb.when == when)  cb.notify(params);
        }
    }
    
    function add_listbox(id, x, y, width, height) {
        local obj = ExtendedListBox(id, x, y, width, height);
        objects.append(obj);
        run_callback(EXTENDED_CALLBACKS.onObjectAdded, { object = obj });
        return getObject(id);
    }

    function add_text(id, text, x, y, width, height) {
        local obj = ExtendedText(id, text, x, y, width, height);
        objects.append(obj);
        run_callback(EXTENDED_CALLBACKS.onObjectAdded, { object = obj });
        return getObject(id);
    }
    
    function add_image(id, image, x, y, width, height) {
        local obj = ExtendedImage(id, image, x, y, width, height);
        objects.append(obj);
        run_callback(EXTENDED_CALLBACKS.onObjectAdded, { object = obj });
        return getObject(id);
    }
    
    function add_artwork(id, artwork, x, y, width, height) {
        local obj = ExtendedImage(id, artwork, x, y, width, height, "artwork");
        objects.append(obj);
        run_callback(EXTENDED_CALLBACKS.onObjectAdded, { object = obj });
        return getObject(id);
    }
    
    function add_wheel(id, slots, artwork, x, y, width, height) {
        local obj = ExtendedWheel(id, slots, artwork, x, y, width, height);
        objects.append(obj);
        run_callback(EXTENDED_CALLBACKS.onObjectAdded, { object = obj });
        return getObject(id);
    }

    function getObject(id) {
        foreach (o in objects) {
            if (o.id == id) return o;
        }
        return null;
    }
    
    //returns calculated positions to be used in the from/to config variables
    function getPosition(position, obj) {
        local OFFSCREEN = 20;
        local CENTER_X = fe.layout.width / 2;
        local CENTER_Y = fe.layout.height / 2;
        switch (position) {
            case "start":
                return [ obj.config.startX, obj.config.startY ];
            case "last":
                if ("lastX" in obj.config && "lastY" in obj.config) return [ obj.config.lastX, obj.config.lastY ];
                //otherwise, just return the start position
                return [ obj.config.startX, obj.config.startY ];
            case "current":
                return [ obj.getX(), obj.getY() ];
            case "top":
                return [ CENTER_X - (obj.getWidth() / 2), 0 ];
            case "left":
                return [ 0, CENTER_Y - (obj.getHeight() / 2) ];
            case "bottom":
                return [ CENTER_X - (obj.getWidth() / 2), fe.layout.height - obj.getHeight() ];
            case "right":
                return [ fe.layout.width - obj.getWidth(), CENTER_Y - (obj.getHeight() / 2) ];
            case "topleft":
                return [ 0, 0 ];
            case "topright":
                return [ fe.layout.width - obj.getWidth(), 0 ];
            case "bottomleft":
                return [ 0, fe.layout.height - obj.getHeight() ];
            case "bottomright":
                return [ fe.layout.width - obj.getWidth(), fe.layout.height - obj.getHeight() ];
            case "offscreentop":
                return [ (fe.layout.width / 2) - (obj.getWidth() / 2), -obj.getHeight() - OFFSCREEN ];
            case "offscreenbottom":
                return [ (fe.layout.width / 2) - (obj.getWidth() / 2), fe.layout.height + obj.getHeight() + OFFSCREEN ];
            case "offscreenleft":
                return [ - obj.getWidth() - OFFSCREEN, CENTER_Y - (obj.getHeight() / 2) ];
            case "offscreenright":
                return [ fe.layout.width + obj.getWidth() + OFFSCREEN, CENTER_Y - (obj.getHeight() / 2) ];
            case "offscreentopleft":
                return [ - obj.getWidth() - OFFSCREEN, - obj.getHeight() - OFFSCREEN ];
            case "offscreentopright":
                return [ fe.layout.width + OFFSCREEN, - obj.getHeight() - OFFSCREEN ];
            case "offscreenbottomleft":
                return [ - obj.getWidth() - OFFSCREEN, fe.layout.height + OFFSCREEN ];
            case "offscreenbottomright":
                return [ fe.layout.width + OFFSCREEN, fe.layout.height + OFFSCREEN ];
            case "center":
            default:
                return [ (fe.layout.width / 2) - (obj.getWidth() / 2), (fe.layout.height / 2) - (obj.getHeight() / 2) ];
        }
    }
    
    //returns the name of a numbered transition
    function getTransition(num) {
        local trans = ["StartLayout", "EndLayout", "ToNewSelection", "FromOldSelection", "ToGame", "FromGame", "ToNewList"];
        //add indefinite animation transition
        return trans[num];
    }
        
}

class Callback {
    when = null;
    notify = null;
    constructor(when, func) {
        this.when = when;
        this.notify = func;
    }
}

class ExtendedObject {
    id = null;
    objects = null;
    animations = null;
    config = null;
    
    constructor(id) {
        this.id = id;
        objects = {}
        objects.primary <- null;
        animations = []
        config = {
            "alpha": 255,
            "color": [255, 255, 0],
            "shadowColor": [ 20, 20, 20 ],
            "shadowAlpha": 100,
            "shadowEnabled": true,
            "shadowOffset": 2,
        }
    }
    
    function initialize() {
        //base functions
        setAlpha(config.alpha);
        setShadow(config.shadowEnabled);
        setShadowRGB(config.shadowColor[0], config.shadowColor[1], config.shadowColor[2]);
        setShadowAlpha(config.shadowAlpha);
        setShadow(config.shadowEnabled);        
    }

    function addAnimation(which, userconfig = null) {
        if (userconfig == null) userconfig = {};
        //TODO check if animation library exists
        animations.append(Animate(which, userconfig));
    }

    function getAlpha() { return objects.primary.alpha; }    
    function getId() { return id; }
    function getX() { return objects.primary.x; }
    function getY() { return objects.primary.y; }
    function getWidth() { return objects.primary.width; }
    function getHeight() { return objects.primary.height; }    
    function getRotation() { return objects.primary.rotation; }
    function getType() { return typeof(this); }

    function setAlpha(a) {
        if (a < 0) a = 0;
        if (a > 255) a = 255;
        foreach (o in objects) {
            o.alpha = a;
        }
        if ("shadow" in objects && a > 0) objects.shadow.alpha = floor(a / 2.0) else if ("shadow" in objects) objects.shadow.alpha = 0;
    }
    function setHeight(h) { 
        foreach (o in objects) {
            o.height = h;
        }
    }
    
    function setPosition( pos ) {

        //convert string positions to appropriate value
        if (typeof pos == "string") {
            pos = ExtendedObjects.getPosition(pos, this);
        }
        
        if ("startX" in config == false) config.startX <- pos[0];
        if ("startY" in config == false) config.startY <- pos[1];

        foreach (o in objects) {
            o.x = pos[0];
            o.y = pos[1];
        }
        if ("shadow" in objects) {
            objects.shadow.x = pos[0] + config.shadowOffset;
            objects.shadow.y = pos[1] + config.shadowOffset;
        }
    }
    
    function setRotation(r) {
        foreach (o in objects) {
            o.rotation = r;
        }
    }
    function setSize(w, h) {
        foreach (o in objects) {
            o.width = w;
            o.height = h;
        }
    }
    function setWidth(w) {
        foreach (o in objects) {
            o.width = w;
        }
    }
    function setX(x) {
        if ("startX" in config == false) config.startX <- x;
        foreach (o in objects) {
            o.x = x;
        }
    }
    function setY(y) { 
        if ("startY" in config == false) config.startY <- y;
        foreach (o in objects) {
            o.y = y;
        }
    }
        
    function setShadow(enabled) { if ("shadow" in objects) objects.shadow.visible = enabled; }

    function setShadowAlpha(a) {
        if ("shadow" in objects) {
            config.shadowAlpha = a;
            objects.shadow.alpha = a;
        }
    }
    
    function setShadowRGB(r, g, b) {
        if ("shadow" in objects) {
            config.shadowColor = [ r, g, b ];
            objects.shadow.set_rgb(r, g, b);
        }
    }

    //gives us a string representation of this object
    function toString() {
        local str = "pos (" + getX() + "," + getY() + ")" +
                    " size (" + getWidth() + "x" + getHeight() + ")";
        if (animations.len() > 0) {
            str +=  " anims (";
            for (local i = 0; i < animations.len(); i++)
                str +=  "[" + i + "] " + animations[i].config.which + " : " + ExtendedObjects.getTransition(animations[i].config.when) + " : " + animations[i].config.duration;
            str += ")";
        }
        return str;
    }
}

class ExtendedImage extends ExtendedObject {
    constructor(id, image, x, y, width, height, t = null) {
        base.constructor(id);
        
        //add objects to the objects table (must at least include object.primary)
        switch (t) {
            case "artwork":
                objects.shadow <- fe.add_artwork(image, 0, 0, 0, 0);
                break;
            default:
                objects.shadow <- fe.add_image(image, 0, 0, 0, 0);
            break;
        }
        objects.primary = fe.add_clone(objects.shadow);
        
        //modify or add config options
        config.color <- [ 255, 0, 0 ];
        config.shadowEnabled <- false;
        config.shadowOffset <- 3;
                
        //initialize the object
        setPosition([x, y]);
        setSize(width, height);
        setPreserveAspectRatio(true);
        //setColor(config.color[0], config.color[1], config.color[2]);
        initialize();
    }
    
    function setSkewX(x) {
        foreach (o in objects) {
            o.skew_x = x;
        }
    }

    function setSkewY(y) {
        foreach (o in objects) {
            o.skew_y = y;
        }
    }

    function setPinchX(x) {
        foreach (o in objects) {
            o.pinch_x = x;
        }
    }

    function setPinchY(y) {
        foreach (o in objects) {
            o.pinch_y = y;
        }
    }
    
    function setColor(r, g, b) { config.color = [ r, g, b ]; objects.primary.set_rgb(r, g, b); }

    function setIndexOffset(index) {
        objects.primary.index_offset = objects.shadow.index_offset = index;
    }
    
    function setPreserveAspectRatio(enabled) {
        foreach (o in objects) {
            o.preserve_aspect_ratio = enabled;
        }
    }
}

class ExtendedText extends ExtendedObject {
    constructor(id, text, x, y, width, height) {
        base.constructor(id);

        //add objects to the objects table (must at least include object.primary)
        objects.shadow <- fe.add_text(text, 0, 0, 0, 0);
        objects.primary = fe.add_text(text, 0, 0, 0, 0);
        
        //modify or add config options
        config.color <- [ 255, 0, 0 ];
        config.align <- Align.Left;
        
        //initialize the object
        setPosition([x, y]);
        setSize(width, height);
        initialize();
    }
    
    function initialize() {
        base.initialize();
        setAlign(config.align);
        setColor(config.color[0], config.color[1], config.color[2]);
        //setColor(config.color[0], config.color[1], config.color[2]);
    }
    
    function setAlign(a) { objects.primary.align = objects.shadow.align = a; }
    function setColor(r, g, b) { config.color = [ r, g, b ]; objects.primary.set_rgb(r, g, b); }

    function setText(text) {
        objects.primary.msg = objects.shadow.msg = text;
    }
}

class ExtendedListBox extends ExtendedObject {
    constructor(id, x, y, width, height) {
        base.constructor(id);

        //add objects to the objects table (must at least include object.primary)
        objects.primary <- fe.add_listbox(0, 0, 0, 0);
        
        //modify or add config options
        
        //initialize the object
        setPosition([x, y]);
        setSize(width, height);
        initialize();
    }
    
    function initialize() {
        base.initialize();
    }   
}

class ExtendedWheel extends ExtendedObject {
    constructor(id, slots, artwork, x, y, width, height) {
        base.constructor(id);
        //workaround
        objects.primary = fe.add_text("", x, y, width, height);
        
        ExtendedObjects.add_callback(EXTENDED_CALLBACKS.onAnimationStop, onAnimationStop);

        local aspect = (ScreenWidth / ScreenHeight);
        config.slots <- slots;
        config.selected <- 4;
        config.artwork <- artwork;
        config.spacing <- 5;
        config.orientation <- "horizontal";
        if (config.orientation == "vertical") {
            config.slotHeight <- (height - (slots - 1 * config.spacing))/slots;
            config.slotWidth <- config.slotHeight * aspect;
        } else {
            config.slotWidth <- (width - (slots - 1 * config.spacing))/slots;
            config.slotHeight <- config.slotWidth / aspect;
        }
        local index = 0;
        for (local i = 0; i < config.slots; i++) {
            index = (i + 1) - config.selected;
            local obj = null;
            if (config.orientation == "vertical") {
                //obj = fe.add_artwork(config.artwork, x, y + (i * config.slotHeight) + (i * config.spacing), config.slotWidth, config.slotHeight);
                obj = ExtendedObjects.add_artwork("wheel" + i, config.artwork, x, y + (i * config.slotHeight) + (i * config.spacing), config.slotWidth, config.slotHeight);
            } else {
                //obj = fe.add_artwork(config.artwork, x + (i * config.slotWidth) + (i * config.spacing), y, config.slotWidth, config.slotHeight);
                obj = ExtendedObjects.add_artwork("wheel" + i, config.artwork, x + (i * config.slotWidth) + (i * config.spacing), y, config.slotWidth, config.slotHeight);
                if (i == 0 || i == config.slots - 1) {
                    //first and last objects
                    obj.addAnimation("property", { stopcallback = onAnimationStop, when = Transition.ToNewSelection, property = "alpha", from = 255, to = 100 } );
                    obj.addAnimation("property", { when = Transition.FromOldSelection, property = "alpha", from = 100, to = 255 } );
                }
            }
            obj.setPreserveAspectRatio(true);
            obj.setIndexOffset(index);
            //obj.preserve_aspect_ratio = true;
            //obj.index_offset = index;
            
            objects["wheel" + i] <- obj;
        }
    }
    
    function onAnimationStop(params) {
        local obj = params.object;
        if (obj.getId() == "wheel0" && params.animation.config.when == Transition.ToNewSelection) obj.setPosition([ 50, 250 ]);
        if (obj.getId() == "wheel0" && params.animation.config.when == Transition.ToNewSelection) obj.setPosition([ 50, 450 ]);
        Debug.setInfo("anim stopped");
    }
}