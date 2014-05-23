ExtendedObjects["debugger"] <- function () {
    return ExtendedDebugger();
}

class ExtendedDebugger {
    objects = [];
    config = {
        "max_lines": 3,
        "align": Align.Centre,
        "alpha": 255,
        "bg": [60, 60, 60],
        "bg_alpha": 50,
        "rgb": [255, 255, 0],
        "charsize": 14,
        "word_wrap": false
    }
    constructor() {
        foreach(o in ExtendedObjects.objects) {
            local obj = ExtendedText("debug_" + o.id, o.toString(), o.getX(), o.getY(), o.getWidth(), o.getHeight());
            setDefaults(obj);
            objects.append(obj);
        }
        
        local notice = ExtendedText("debug_notice", "", 0, 0, fe.layout.width, 20);
        ExtendedObjects.add_callback(this, "onObjectAdded");
        ExtendedObjects.add_callback(this, "onTransition");
        ExtendedObjects.add_callback(this, "onTick");
        ExtendedObjects.add_callback(this, "onAnimationFrame");
        ExtendedObjects.add_callback(this, "onAnimationStart");
        ExtendedObjects.add_callback(this, "onAnimationStop");
        objects.append(notice);
        setDefaults(notice);
    }
    
    function onObjectAdded(params) {
        //ExtendedDebugger.notice("object added: " + params.object.id);
    }
    function onAnimationFrame(params) {
        //ExtendedDebugger.notice("animating: " + params.object.id);        
    }
    
    function onAnimationStart(params) {
        //ExtendedDebugger.notice("animation started: " + params.object.id);
    }
    
    function onAnimationStop(params) {
        //ExtendedDebugger.notice("animation stopped: " + params.object.id);
    }
    
    function onTick(params) {
        //ExtendedDebugger.notice(params.ttime);
        updateObjects();
    }
    
    function updateObjects() {
        foreach(o in ExtendedObjects.objects) {
            local dobj = get(o.id);
            if (dobj != null) {
                dobj.setPosition( [ o.getX(), o.getY() ]);
                dobj.setText(o.toString());
            }
        }
    }
    
    function onTransition(params) {
        local ttype = params.ttype;
        local var = params.var;
        local ttime = params.ttime;
        //ExtendedDebugger.notice("Transition: " + Animate.getWhen(ttype));
        updateObjects();
        if (ttype == Transition.StartLayout) {
            local msg = "Found objects: ";
            foreach(o in ExtendedObjects.objects) {
                msg += o.id + "-";
            }
            notice(msg);
        }
        return false;
    }
    
    function setDefaults(obj) {
        obj.setAlign(config.align);
        obj.setAlpha(config.alpha);
        obj.setColor(config.rgb[0], config.rgb[1], config.rgb[2]);
        obj.setBGColor(config.bg[0], config.bg[1], config.bg[2]);
        obj.setBGAlpha(config.bg_alpha);
        obj.setCharSize(config.charsize);
        obj.setWordWrap(config.word_wrap);
        obj.setShadow(false);
    }
    
    function notice(text) {
        local notice = get("notice");
        if (notice != null) {
            notice.setText(text + "\n");
        }
    }
    
    function get(id) { foreach (o in objects) { if ("debug_" + id == o.id) return o; } return null; }
    function setVisible(v) { foreach(o in objects) o.setVisible(v); }
}
