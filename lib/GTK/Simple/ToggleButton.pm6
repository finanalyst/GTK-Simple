
use v6;

use NativeCall;
use GTK::Simple::Raw :toggle-button, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::ToggleButton does GTK::Simple::Widget;

method creation-sub {
    &gtk_toggle_button_new_with_label
}

submethod BUILD(:$label!) {
    $!gtk_widget = self.creation-sub.($label);
}

has $!toggled_supply;
method toggled() {
    $!toggled_supply //= do {
        my $s = Supplier.new;
        g_signal_connect_wd($!gtk_widget, "toggled",
            -> $, $ {
                $s.emit(self);
                CATCH { default { note $_; } }
            }, OpaquePointer, 0);
        $s.Supply;
    }
}

method status()
    returns Bool 
    is gtk-property(&gtk_toggle_button_get_active, &gtk_toggle_button_set_active) 
    { * }
