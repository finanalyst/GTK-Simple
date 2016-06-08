
use v6;
use NativeCall;
use GTK::Simple::Raw :radio-button, :toggle-button, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::RadioButton does GTK::Simple::Widget;

has $!toggled_supply;

submethod BUILD(:$label = '') {
    $!gtk_widget = gtk_radio_button_new_with_label(Nil, $label);
}

method add(GTK::Simple::RadioButton $radio-button) {
    gtk_radio_button_join_group($!gtk_widget, $radio-button.WIDGET)
}

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
