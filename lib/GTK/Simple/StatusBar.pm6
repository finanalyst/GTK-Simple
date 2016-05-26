
use v6;

use NativeCall;
use GTK::Simple::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::Widget;
use GTK::Simple::Box;

unit class GTK::Simple::StatusBar
    does GTK::Simple::Widget
    does GTK::Simple::Box;

sub gtk_statusbar_new()
    is native(&gtk-lib)
    returns GtkWidget
    { * }

submethod BUILD() {
    $!gtk_widget = gtk_statusbar_new();
}

sub gtk_statusbar_get_context_id(GtkWidget $widget, Str $description)
    is native(&gtk-lib)
    returns uint32
    { * }

method get-context-id(Str $description) returns Int {
    gtk_statusbar_get_context_id($!gtk_widget, $description);
}

sub gtk_statusbar_push(GtkWidget $widget, uint32 $context_id, Str $text)
    is native(&gtk-lib)
    returns uint32
    { * }

method push-status(Int $context-id, Str $text) returns Int {
    gtk_statusbar_push($!gtk_widget, $context-id, $text);
}

sub gtk_statusbar_pop(GtkWidget $widget, uint32 $context-id)
    is native(&gtk-lib)
    { * }

method pop-status(Int $context-id) {
    gtk_statusbar_pop($!gtk_widget, $context-id);
}

sub gtk_statusbar_remove(GtkWidget $widget, uint32 $context-id, uint32 $message-id)
    is native(&gtk-lib)
    { * }

method remove-status(Int $context-id, Int $message-id) {
    gtk_statusbar_remove($!gtk_widget, $context-id, $message-id);
}

sub gtk_statusbar_remove_all(GtkWidget $widget, uint32 $context-id)
    is native(&gtk-lib)
    { * }

method remove-status-all(Int $context-id) {
    gtk_statusbar_remove_all($!gtk_widget, $context-id);
}
