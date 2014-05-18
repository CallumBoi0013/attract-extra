AnimationSet["left_center_up"] <-  [
    {
        kind = "loop",
        when = Transition.ToNewSelection,
        duration = 500,
        from = "offleft",
        to = "center",
        easing = "out",
        tween = "back"
    },
    {
        kind = "loop",
        when = Transition.FromOldSelection,
        duration = 500,
        from = "current",
        to = "top",
        easing = "out",
        tween = "bounce"
    }
];

AnimationSet["fade_in_out"] <-  [
    { 
        when = Transition.ToNewSelection,
        duration = 500,
        property = "alpha",
        from = 255,
        to = 0,
        easing = "out",
        tween = "quad"
    },
    { 
        when = Transition.FromOldSelection,
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
            kind = "yoyo",
            when = Transition.StartLayout,
            property = "x",
            duration = 2000,
            from = 200,
            to = 210,
            easing = "out",
            tween = "bounce"
        },
        {
            kind = "yoyo",
            when = Transition.StartLayout,
            property = "y",
            duration = 7000,
            from = 200,
            to = 220,
            easing = "in",
            tween = "elastic",
        }
];
