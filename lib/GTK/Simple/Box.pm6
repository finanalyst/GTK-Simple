
use v6;

use NativeCall;
use GTK::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::Container;

unit role GTK::Simple::Box does GTK::Simple::Container;

sub gtk_box_pack_start(GtkWidget, GtkWidget, int32, int32, int32)
    is native(&gtk-lib)
    is export
    {*}

sub gtk_box_get_spacing(GtkWidget $box)
    returns int32
    is native(&gtk-lib)
    is export
    {*}

sub gtk_box_set_spacing(GtkWidget $box, int32 $spacing)
    is native(&gtk-lib)
    is export
    {*}

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
