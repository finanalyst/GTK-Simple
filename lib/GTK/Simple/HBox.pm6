
use v6;

use NativeCall;
use GTK::Simple::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Widget;
use GTK::Simple::Box;

unit class GTK::Simple::HBox
    does GTK::Simple::Widget
    does GTK::Simple::Box;

sub gtk_hbox_new(int32, int32)
    is native(&gtk-lib)
    returns GtkWidget
    {*}

submethod BUILD() {
    $!gtk_widget = gtk_hbox_new(0, 0);
}
