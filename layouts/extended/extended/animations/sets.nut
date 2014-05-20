AnimationSet["left_center_up"] <-  [
    {
        which = "translate",
        kind = "loop",
        when = When.ToNewSelection,
        duration = 500,
        from = "offleft",
        to = "center",
        easing = "out",
        tween = "back"
    },
    {
        which = "translate",
        kind = "loop",
        when = When.FromOldSelection,
        duration = 500,
        from = "current",
        to = "top",
        easing = "out",
        tween = "bounce"
    }
];

AnimationSet["fade_in_out"] <-  [
    { 
        which = "property",
        when = When.ToNewSelection,
        wait = true,
        duration = 500,
        property = "alpha",
        from = 255,
        to = 0,
        easing = "out",
        tween = "quad"
    },
    { 
        which = "property",
        when = When.FromOldSelection,
        wait = false,
        delay = 500,
        duration = 500,
        property = "alpha",
        from = 0,
        to = 255,
        easing = "out",
        tween = "quad"
    }
];

AnimationSet["hover"] <-  [
        {
            which = "property",
            when = When.Always,
            wait = false,
            kind = "yoyo",
            property = "x",
            duration = 1000,
            from = 200,
            to = 240,
            easing = "out",
            tween = "back"
        },
        {
            which = "property",
            when = When.OnDemand,
            wait = false,
            kind = "yoyo",
            property = "y",
            duration = 8000,
            from = 200,
            to = 220,
            easing = "outin",
            tween = "elastic",
        }
];
