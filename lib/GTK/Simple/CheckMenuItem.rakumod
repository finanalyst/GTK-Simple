use v6.d;

use GTK::Simple::MenuItem;
use GTK::Simple::Common;
use GTK::Simple::Raw :menu-item;

unit class GTK::Simple::CheckMenuItem is GTK::Simple::MenuItem;

has $!toggled_supply;

submethod BUILD(Str :$label) {
    self.WIDGET(gtk_check_menu_item_new_with_label($label));
}

method active
    returns Bool
    is gtk-property(&gtk_check_menu_item_get_active, &gtk_check_menu_item_set_active)
    { * }

method toggled() {
    $!toggled_supply //= self.signal-supply("toggled");
}