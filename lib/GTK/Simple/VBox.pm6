
use v6;

use NativeCall;
use GTK::Simple::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Widget;
use GTK::Simple::Box;

unit class GTK::Simple::VBox
    does GTK::Simple::Widget
    does GTK::Simple::Box;

sub gtk_vbox_new(int32, int32)
    is native(&gtk-lib)
    returns GtkWidget
    {*}

submethod BUILD() {
    $!gtk_widget = gtk_vbox_new(0, 0);
}
