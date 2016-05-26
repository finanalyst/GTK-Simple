
use v6;

use NativeCall;
use GTK::Simple::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::ActionBar does GTK::Simple::Widget;

sub gtk_action_bar_new()
    is native(&gtk-lib)
    returns GtkWidget
    { * }

submethod BUILD() {
    $!gtk_widget = gtk_action_bar_new();
}

sub gtk_action_bar_pack_start(GtkWidget $widget, GtkWidget $child)
    is native(&gtk-lib)
    { * }

method pack-start(GTK::Simple::Widget $child) {
    gtk_action_bar_pack_start($!gtk_widget, $child.WIDGET);
    $child.show;
}

sub gtk_action_bar_pack_end(GtkWidget $widget, GtkWidget $child)
    is native(&gtk-lib)
    { * }

method pack-end(GTK::Simple::Widget $child) {
    gtk_action_bar_pack_end($!gtk_widget, $child.WIDGET);
    $child.show;
}


# For the time being it's tricky to expose these as *what* the
# widget is is difficult to find out afaik

sub gtk_action_bar_get_center_widget(GtkWidget $widget)
    is native(&gtk-lib)
    returns GtkWidget
    { * }

sub gtk_action_bar_set_center_widget(GtkWidget $widget, GtkWidget $centre-widget)
    is native(&gtk-lib)
    { * }
