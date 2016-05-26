
use v6;

use NativeCall;
use GTK::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::Widget;

# This is actually a container but most of the interface
# isn't necessary
unit class GTK::Simple::ComboBoxText does GTK::Simple::Widget;

sub gtk_combo_box_text_new()
    is native(&gtk-lib)
    returns GtkWidget
    { * }

sub gtk_combo_box_text_new_with_entry()
    is native(&gtk-lib)
    returns GtkWidget
    { * }

sub gtk_combo_box_text_prepend_text(GtkWidget $widget, Str $text)
    is native(&gtk-lib)
    { * }

sub gtk_combo_box_text_append_text(GtkWidget $widget, Str $text)
    is native(&gtk-lib)
    { * }

sub gtk_combo_box_text_insert_text(GtkWidget $widget, int32 $position, Str $text)
    is native(&gtk-lib)
    { * }

sub gtk_combo_box_set_active(GtkWidget $widget, int32 $index)
    is native(&gtk-lib)
    { * }

sub gtk_combo_box_text_get_active_text(GtkWidget $widget)
    is native(&gtk-lib)
    returns Str
    { * }

sub gtk_combo_box_text_remove(GtkWidget $widget, int32 $position)
    is native(&gtk-lib)
    { * }

submethod BUILD(Bool :$entry = False) {
    $!gtk_widget = do {
        if $entry {
            gtk_combo_box_text_new_with_entry()
        }
        else {
            gtk_combo_box_text_new()
        }
    }
}

method append-text(Str $text) {
    gtk_combo_box_text_append_text($!gtk_widget, $text);
}

method prepend-text(Str $text) {
    gtk_combo_box_text_prepend_text($!gtk_widget, $text);
}

method insert-text(Int $position, Str $text) {
    gtk_combo_box_text_insert_text($!gtk_widget, $position, $text);
}

method remove(Int $position) {
    gtk_combo_box_text_remove($!gtk_widget, $position);
}

sub gtk_combo_box_text_remove_all(GtkWidget $widget)
    is native(&gtk-lib)
    { * }

method remove-all() {
    gtk_combo_box_text_remove_all($!gtk_widget)
}

method active-text() returns Str {
    gtk_combo_box_text_get_active_text($!gtk_widget);
}

method set-active( $index ) {
    gtk_combo_box_set_active($!gtk_widget,$index)
}

has $!changed_supply;
method changed() {
    $!changed_supply //= do {
        my $s = Supplier.new;
        g_signal_connect_wd($!gtk_widget, "changed",
            -> $, $ {
                $s.emit(self);
                CATCH { default { note $_; } }
            },
            OpaquePointer, 0);
        $s.Supply;
    }
}
