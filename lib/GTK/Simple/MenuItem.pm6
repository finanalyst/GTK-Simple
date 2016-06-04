
use v6;
use NativeCall;
use GTK::Simple::Raw :menu-item, :DEFAULT;
use GTK::Simple::Widget;

unit class GTK::Simple::MenuItem does GTK::Simple::Widget;

has $!clicked_supply;

submethod BUILD(Str :$label = '') {
    $!gtk_widget = gtk_menu_item_new_with_label($label);
}

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
