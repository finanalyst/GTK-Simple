
use v6;
use NativeCall;
use GTK::Simple::Common;
use GTK::Simple::Raw :menu-item, :DEFAULT;
use GTK::Simple::Widget;

class GTK::Simple::MenuItem does GTK::Simple::Widget {
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
}

class GTK::Simple::MenuItem::Check is GTK::Simple::MenuItem does GTK::Simple::Widget {
    has $!toggled_supply;

    submethod BUILD(Str :$label) {
        $!gtk_widget = gtk_check_menu_item_new_with_label($label);
    }

    method active
        returns Bool
        is gtk-property(&gtk_check_menu_item_get_active, &gtk_check_menu_item_set_active)
        { * }

    method toggled() {
        $!toggled_supply //= do {
            my $s = Supplier.new;
            g_signal_connect_wd($!gtk_widget, "toggled",
                    -> $, $ {
                        $s.emit(self);
                        CATCH { default { note $_; } }
                    },
                    OpaquePointer, 0);
            $s.Supply;
        }
    }
}
