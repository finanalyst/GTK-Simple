
use v6;

use NativeCall;
use GTK::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Button does GTK::Simple::Widget;

sub gtk_button_new_with_label(Str $label)
    is native(&gtk-lib)
    returns GtkWidget
    {*}

submethod BUILD(:$label!) {
    $!gtk_widget = gtk_button_new_with_label($label);
}

sub gtk_button_get_label(GtkWidget $widget)
    is native(&gtk-lib)
    returns Str
    { * }

sub gtk_button_set_label(GtkWidget $widget, Str $label)
    is native(&gtk-lib)
    { * }

method label() 
    returns Str
    is gtk-property(&gtk_button_get_label, &gtk_button_set_label)
    { * }

has $!clicked_supply;
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
