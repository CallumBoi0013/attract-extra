class FeButton extends FeControl
{
    msg = "";
    button_template = {
        create = function(view) {
            view.add_image("bg", "images/pixel.png", 0, 0, 1, 1, {
                rgba = [ 50, 50, 50, 255 ]
            })
        },
        disabled = function(view) {
            view.set_props( view.find("bg"), {
                rgba = [ 30, 30, 30, 50 ]
            })
        }
        enabled = function(view) {
            view.set_props( view.find("bg"), {
                rgba = [ 200, 200, 200, 255 ]
            })
        },
        selected = function(view) {
            view.set_props( view.find("bg"), {
                rgba = [ 50, 50, 100, 255 ]
            })
        }
    }

    constructor( x, y, width, height, surface = ::fe, template = null )
    {
        if ( template == null )
            template = button_template;
        base.constructor( x, y, width, height, surface, template );
        return this;
    }
}