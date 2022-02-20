
use v6;
use NativeCall;
use GTK::Simple::Raw :toolbar, :DEFAULT;
use GTK::Simple::Widget;

unit class GTK::Simple::MenuToolButton does GTK::Simple::Widget;

has $!clicked_supply;

submethod BUILD(:$icon) {
    if $icon {
        $!gtk_widget = gtk_tool_button_new_from_stock($icon);
    } else {
        $!gtk_widget = gtk_toolbar_new;
    }
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
