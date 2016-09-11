
use v6;

use NativeCall;
use GTK::Simple::Raw :combo-box-text, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;

# This is actually a container but most of the interface
# isn't necessary
unit class GTK::Simple::ComboBoxText does GTK::Simple::Widget;

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

method remove-all() {
    gtk_combo_box_text_remove_all($!gtk_widget)
}

method active-text() returns Str {
    gtk_combo_box_text_get_active_text($!gtk_widget);
}

method set-active( $index ) {
    gtk_combo_box_set_active($!gtk_widget,$index)
}

method get-active() returns Int {
    gtk_combo_box_get_active($!gtk_widget)
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
