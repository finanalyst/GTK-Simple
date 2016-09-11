use v6;

use NativeCall;
use GTK::Simple::Raw :entry, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Entry does GTK::Simple::Widget;

has $!changed_supply;

submethod BUILD(:$text) {
    $!gtk_widget = gtk_entry_new();
    gtk_entry_set_text(self.WIDGET, $text.Str) if defined $text;
}

method text()
    returns Str 
    is gtk-property(&gtk_entry_get_text, &gtk_entry_set_text)
    { * }

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
