

use v6;

use GTK::Simple::Common;
use GTK::Simple::Raw;

unit role GTK::Simple::Container;

method set-content($widget) {
    gtk_container_add(self.WIDGET, $widget.WIDGET);
    gtk_widget_show($widget.WIDGET);
}

method set_content($widget) {
    DEPRECATED('set-content',Any,'0.3.2');
    self.set-content($widget);
}

method border-width 
    returns Int
    is gtk-property(&gtk_container_get_border_width, &gtk_container_set_border_width)
    { * }

method border_width() { 
    DEPRECATED('border-width',Any,'0.3.2');
    self.border-width
}
