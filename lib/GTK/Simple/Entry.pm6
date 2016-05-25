use v6;

use NativeCall;
use GTK::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Entry does GTK::Simple::Widget;
sub gtk_entry_new()
    is native(&gtk-lib)
    returns GtkWidget
    {*}

sub gtk_entry_get_text(GtkWidget $entry)
    is native(&gtk-lib)
    returns Str
    {*}

sub gtk_entry_set_text(GtkWidget $entry, Str $text)
    is native(&gtk-lib)
    {*}

submethod BUILD(:$text) {
    $!gtk_widget = gtk_entry_new();
    gtk_entry_set_text(self.WIDGET, $text.Str) if defined $text;
}

method text()
    returns Str 
    is gtk-property(&gtk_entry_get_text, &gtk_entry_set_text)
    { * }

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
