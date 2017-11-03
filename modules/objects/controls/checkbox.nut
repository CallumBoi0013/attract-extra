class FeCheckBox extends FeButton
{
    checked = false;
    checkbox_template = {
        create = function(view) {
            view.add_image("bg", "images/checkbox-enabled.png", 0, 0, 1, 1, {
                rgba = [ 50, 50, 50, 255 ]
            })
        },
        disabled = function(view) {
            view.set_props( view.find("bg"), {
                file_name = ( view.checked ) ? "images/checkbox-disabled-checked.png" : "images/checkbox-disabled.png"
            });
        }
        enabled = function(view) {
            view.set_props( view.find("bg"), {
                file_name = ( view.checked ) ? "images/checkbox-enabled-checked.png" : "images/checkbox-enabled.png"
            });
        },
        selected = function(view) {
            view.set_props( view.find("bg"), {
                file_name = ( view.checked ) ? "images/checkbox-selected-checked.png" : "images/checkbox-selected.png"
            });
        }
    }
    constructor( x, y, width, height, surface = ::fe, template = null )
    {
        if ( template == null )
            template = checkbox_template;
        base.constructor( x, y, width, height, surface, template );
    }

    function setChecked( bool ) {
        checked = bool;
        if ( checked ) onChecked(); else onUnchecked();
        return this;
    }

    function onChecked() {
        if ( selected ) {
            if ( "selected" in template ) template.selected(this);
        } else {
            if ( "enabled" in template ) template.enabled(this);
        }
    }

    function onUnchecked() {
        if ( selected ) {
            if ( "selected" in template ) template.selected(this);
        } else {
            if ( "enabled" in template ) template.enabled(this);
        }
    }

    function onAction() {
        setChecked(!checked);
        if ( checked ) onChecked(); else onUnchecked();
        if ( action != null && typeof(action) == "function" ) action();
    }
}
