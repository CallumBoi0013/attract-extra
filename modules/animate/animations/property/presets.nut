/* PRESETS */
PropertyAnimations <- {
    "hide": { property = "alpha", start = 255, end = 0, when = When.ToNewSelection, time = 2000 },
    "show": { property = "alpha", start = 0, end = 255, when = When.FromOldSelection, delay = 2000, time = 2000 },
    "enlarge": { property = "scale", start = 1.0, end = 2.0, when = When.ToNewSelection, time = 1500, tween = Tween.Bounce },
    "shrink": { property = "scale", start = 1.0, end = 2.0, when = When.ToNewSelection, time = 1500, tween = Tween.Bounce },
    "slide_left": { property = "position", end = "-10", when = When.ToNewSelection, time = 1500, tween = Tween.Quad },
    "slide_right": { property = "position", end = "+10", when = When.ToNewSelection, time = 1500, tween = Tween.Quad },
    "rise": { property = "position", end = { x = 0, y = "-25" }, when = When.ToNewSelection, tween = Tween.Elastic, time = 1200, delay = 750 },
    "fall": { property = "position", end = { x = 0, y = "+25" }, when = When.ToNewSelection, tween = Tween.Elastic, time = 1200, delay = 750 },
    "turn45": { property = "rotation", start = 0, end = 45, when = When.ToNewSelection, time = 1500 },
}