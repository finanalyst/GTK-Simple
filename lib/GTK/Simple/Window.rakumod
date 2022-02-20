
use v6;

use GTK::Simple::Raw;
use GTK::Simple::Widget;
use GTK::Simple::Container;

unit class GTK::Simple::Window
    does GTK::Simple::Widget
    does GTK::Simple::Container;

submethod BUILD(Cool :$title = "Gtk Window") {
    $!gtk_widget = gtk_window_new(0);
    gtk_window_set_title($!gtk_widget, $title.Str);
}
