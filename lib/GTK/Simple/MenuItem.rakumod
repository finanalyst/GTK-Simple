
use v6;
use NativeCall;
use GTK::Simple::Raw :menu-item, :DEFAULT;
use GTK::Simple::Widget;

unit class GTK::Simple::MenuItem does GTK::Simple::Widget;

has $!activate_supply;

submethod BUILD(Str :$label) {
    $!gtk_widget = gtk_menu_item_new_with_label($label);
}

method set-sub-menu($sub-menu) {
    gtk_menu_item_set_submenu($!gtk_widget, $sub-menu.WIDGET);
}

method activate() {
    $!activate_supply //= do {
        my $s = Supplier.new;
        g_signal_connect_wd($!gtk_widget, "activate",
            -> $, $ {
                $s.emit(self);
                CATCH { default { note $_; } }
            },
            OpaquePointer, 0);
        $s.Supply;
    }
}
