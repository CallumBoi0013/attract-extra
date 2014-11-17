///////////////////////////////////////////////////
// Attract-Mode Frontend - Debug library
///////////////////////////////////////////////////
//  The debug library provides onscreen feedback about your objects, helpful for testing layouts
//
//  Requirements:
//      This library requires the 'extended' objects library (extended.nut)
//
//  Usage:
//      //load required files
//      fe.do_nut("extended.nut");
//      fe.do_nut("debug.nut");
//      ...
//      //add debugger to the end of your layout
//      Debug.start();
//      Debug.disableDuringAnimations(false);
//      Debug.getObject("snap").setText("hi snap!");
//  
//  Todo:
//      verify availability of Animate
/////////////////////////////////////////////
/*
try {
    exists = ExtendedObjects.VERSION;
} catch (err) {
    local error = fe.add_text("Required library ExtendedObjects not found.", 0, fe.layout.height / 2, fe.layout.width, 30);
}
*/

class Debug {
    VERSION = "1.0";
    objects = [];
    config = {
        "disableDuringAnimations": false
    }
    constructor () {
    
    }
    
    function disableDuringAnimations(enabled) {
        config.disableDuringAnimations = enabled;
    }
    
    function setEnabled(enabled) {
        //shows or hides all debug objects
        foreach (o in objects) {
            o.object.visible = enabled;
        }
    }
    
    function start() {
        //first we add ExtendedText objects to each object in the layout
        local co = 0;
        foreach (o in ExtendedObjects.objects) {
            co += o.objects.len();
            objects.append(DebugText(o.getId(), "", o.getX(), o.getY(), o.getWidth(), 30));
        }

        //now we add some callbacks to extended
        ExtendedObjects.add_callback(EXTENDED_CALLBACKS.onTick, onTick);
        ExtendedObjects.add_callback(EXTENDED_CALLBACKS.onAnimationStart, onAnimationStart);
        ExtendedObjects.add_callback(EXTENDED_CALLBACKS.onAnimationRunning, onAnimationRunning);
        ExtendedObjects.add_callback(EXTENDED_CALLBACKS.onAnimationStop, onAnimationStop);
        ExtendedObjects.add_callback(EXTENDED_CALLBACKS.onObjectAdded, onObjectAdded);
        ExtendedObjects.add_callback(EXTENDED_CALLBACKS.onTransition, onTransition);

        //Finally we add a few debug lines
        objects.append(DebugText("_title_", "", fe.layout.width - 200, 0, fe.layout.width, 30));
        objects.append(DebugText("_ticks_", "", fe.layout.width - 200, 30, fe.layout.width, 30));
        objects.append(DebugText("_info_", "", fe.layout.width - 200, 60, fe.layout.width, 30));
        getObject("_title_").setText("Debugger ready... (v" + VERSION + ")");

        Debug.updateDebugText();
    }
    
    function getObject(id) {
        foreach (o in objects) {
            if (o.id == id) return o;
        }
        return null;
    }
    
    function setInfo(info) {
        if (Debug.getObject("_info_") != null) Debug.getObject("_info_").setText(info);
    }
    
    function onAnimationStart(params) {
            //Debug.getObject("_info_").setText("started: " + params.animation.config.current + ": " + params.animation.config.which);
    }

    function onAnimationRunning(params) {
        if (Debug.config.disableDuringAnimations) {
            Debug.setEnabled(false);
        } else {
            Debug.getObject("_ticks_").setText("Anim ticks: " + params.ttime);
            Debug.updateDebugText();
        }
    }
    
    function onAnimationStop(params) {
        Debug.updateDebugText();
        if (Debug.config.disableDuringAnimations) Debug.setEnabled(true);
        //Debug.getObject("_info_").setText("");
    }

    function onObjectAdded(params) {
            //Debug.getObject("_info_").setText("object added: " + params.object.getId());
    }
    
    function onTransition(params) {
        
    }
    
    function onTick(params) {
        Debug.getObject("_ticks_").setText("Ticks: " + params.ttime);
    }
    
    function updateDebugText() {
        foreach (o in ExtendedObjects.objects) {
            Debug.getObject(o.id).setText(o.toString());
            Debug.getObject(o.id).setLocation(o.getX(), o.getY(), o.getWidth(), 30);
        }
    }
}

class DebugText {
    id = null;
    object = null;
    config = {
        "align": Align.Left,
        "alpha": 90,
        "bg": [20, 20, 20],
        "color": [255, 255, 0],
        "charsize": 12,
        "wordwrap": true
    }
    constructor(id, text, x, y, w, h) {
        this.id = id;
        object = fe.add_text(text, 0, 0, 0, 0);
        object.align = config.align;
        object.set_rgb(config.color[0], config.color[1], config.color[2]);
        object.set_bg_rgb(config.bg[0], config.bg[1], config.bg[2]);
        object.bg_alpha = config.alpha;
        object.charsize = config.charsize;
        object.word_wrap = config.wordwrap;
        setLocation(x, y, w, h);
    }
    
    function setLocation(x, y, w, h) {
        object.x = x;
        object.y = y;
        object.width = w;
        object.height = h;
    }
    
    function setText(text) {
        object.msg = text;
    }
}