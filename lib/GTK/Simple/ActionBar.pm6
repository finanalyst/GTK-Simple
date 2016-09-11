
use v6;

use GTK::Simple::Raw :action-bar;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::ActionBar does GTK::Simple::Widget;

submethod BUILD() {
    $!gtk_widget = gtk_action_bar_new();
}

method pack-start(GTK::Simple::Widget $child) {
    gtk_action_bar_pack_start($!gtk_widget, $child.WIDGET);
    $child.show;
}

method pack-end(GTK::Simple::Widget $child) {
    gtk_action_bar_pack_end($!gtk_widget, $child.WIDGET);
    $child.show;
}

# For the time being it's tricky to expose these as *what* the
# widget is is difficult to find out afaik
