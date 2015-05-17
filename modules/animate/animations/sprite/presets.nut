/* Sprite Presets */

SpriteAnimations <- {
    "pacland": {
        when = When.ToNewSelection,
        width = 32,
        height = 48,
        frame = 0,
        time = 1000,
        loop = 2,
        resource = SpriteAnimation.BASE_PATH + "images/pacland.gif",
        onStop = function( anim )
        {
            anim.frame(0);
        }
    }
}