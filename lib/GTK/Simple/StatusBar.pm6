
use v6;

use NativeCall;
use GTK::Simple::Raw :status-bar;
use GTK::Simple::Common;
use GTK::Simple::Widget;
use GTK::Simple::Box;

unit class GTK::Simple::StatusBar
    does GTK::Simple::Widget
    does GTK::Simple::Box;

submethod BUILD() {
    $!gtk_widget = gtk_statusbar_new();
}

method get-context-id(Str $description) returns Int {
    gtk_statusbar_get_context_id($!gtk_widget, $description);
}

method push-status(Int $context-id, Str $text) returns Int {
    gtk_statusbar_push($!gtk_widget, $context-id, $text);
}

method pop-status(Int $context-id) {
    gtk_statusbar_pop($!gtk_widget, $context-id);
}

method remove-status(Int $context-id, Int $message-id) {
    gtk_statusbar_remove($!gtk_widget, $context-id, $message-id);
}

method remove-status-all(Int $context-id) {
    gtk_statusbar_remove_all($!gtk_widget, $context-id);
}
