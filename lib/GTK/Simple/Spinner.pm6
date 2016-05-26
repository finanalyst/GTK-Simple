
use v6;

use NativeCall;
use GTK::Simple::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Spinner does GTK::Simple::Widget;

sub gtk_spinner_new()
    is native(&gtk-lib)
    returns GtkWidget
    { * }

submethod BUILD() {
    $!gtk_widget = gtk_spinner_new();
}

sub gtk_spinner_start(GtkWidget $widget)
    is native(&gtk-lib)
    { * }

method start() {
    gtk_spinner_start($!gtk_widget);
}

sub gtk_spinner_stop(GtkWidget $widget)
    is native(&gtk-lib)
    { * }

method stop() {
    gtk_spinner_stop($!gtk_widget);
}
