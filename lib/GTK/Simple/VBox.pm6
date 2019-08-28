
use v6;

use GTK::Simple::Raw :vbox;
use GTK::Simple::Widget;
use GTK::Simple::Box;

unit class GTK::Simple::VBox
    does GTK::Simple::Widget
    does GTK::Simple::Box;

submethod BUILD(Bool :$homogeneous, Int :$spacing) {
    $!gtk_widget = gtk_vbox_new($homogeneous, $spacing);
}
