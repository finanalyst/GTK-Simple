
use v6;

use NativeCall;
use GTK::Simple::Raw :button, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Button does GTK::Simple::Widget;

has $!clicked_supply;

submethod BUILD(:$label!) {
    $!gtk_widget = gtk_button_new_with_label($label);
}

method label() 
    returns Str
    is gtk-property(&gtk_button_get_label, &gtk_button_set_label)
    { * }

method clicked() {
    $!clicked_supply //= do {
        my $s = Supplier.new;
        g_signal_connect_wd($!gtk_widget, "clicked",
            -> $, $ {
                $s.emit(self);
                CATCH { default { note $_; } }
            },
            OpaquePointer, 0);
        $s.Supply;
    }
}
