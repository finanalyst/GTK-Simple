
use v6;

use NativeCall;
use GTK::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::Widget;
use GTK::Simple::Container;

unit class GTK::Simple::Frame does GTK::Simple::Widget does GTK::Simple::Container;

sub gtk_frame_new(Str $label)
    is native(&gtk-lib)
    returns GtkWidget
    { * }

submethod BUILD(Str :$label) {
    $!gtk_widget = gtk_frame_new($label);
}

sub gtk_frame_get_label(GtkWidget $widget)
    is native(&gtk-lib)
    returns Str
    { * }

sub gtk_frame_set_label(GtkWidget $widget, Str $label)
    is native(&gtk-lib)
    { * }

method label() 
    returns Str 
    is gtk-property(&gtk_frame_get_label, &gtk_frame_set_label)
    { * }
