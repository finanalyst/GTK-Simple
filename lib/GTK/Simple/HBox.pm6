
use v6;

use GTK::Simple::Raw :hbox;
use GTK::Simple::Widget;
use GTK::Simple::Box;

unit class GTK::Simple::HBox
    does GTK::Simple::Widget
    does GTK::Simple::Box;

submethod BUILD() {
    $!gtk_widget = gtk_hbox_new(0, 0);
}
