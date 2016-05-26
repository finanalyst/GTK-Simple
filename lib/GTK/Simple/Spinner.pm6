
use v6;

use NativeCall;
use GTK::Simple::Raw :spinner;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Spinner does GTK::Simple::Widget;

submethod BUILD() {
    $!gtk_widget = gtk_spinner_new();
}

method start() {
    gtk_spinner_start($!gtk_widget);
}

method stop() {
    gtk_spinner_stop($!gtk_widget);
}
