
use v6;

use GTK::Simple::Raw :box, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Container;

unit role GTK::Simple::Box does GTK::Simple::Container;

multi method new(*@packees) {
    my $box = self.bless();
    $box.pack-start($_) for @packees;
    $box
}

method pack-start($widget) {
    gtk_box_pack_start(self.WIDGET, $widget.WIDGET, 1, 1, 0);
    gtk_widget_show($widget.WIDGET);
}

method pack_start($widget) {
    DEPRECATED('pack-start',Any,'0.3.2');
    self.pack-start($widget);
}

method spacing 
    returns Int
    is gtk-property(&gtk_box_get_spacing, &gtk_box_set_spacing)
    { * }
