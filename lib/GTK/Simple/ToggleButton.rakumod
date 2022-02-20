
use v6;

use NativeCall;
use GTK::Simple::Raw :toggle-button, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Button;

unit class GTK::Simple::ToggleButton is GTK::Simple::Button;

has $!toggled_supply;

submethod BUILD(:$label!) {
    self.WIDGET( gtk_toggle_button_new_with_label($label) );
}

method toggled() {
    $!toggled_supply //= do {
        my $s = Supplier.new;
        g_signal_connect_wd(self.WIDGET, "toggled",
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
