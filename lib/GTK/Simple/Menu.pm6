
use v6;
use GTK::Simple::Raw :menu, :menu-item, :DEFAULT;
use GTK::Simple::Widget;

unit class GTK::Simple::Menu does GTK::Simple::Widget;

use GTK::Simple::MenuItem;

submethod BUILD() {
    $!gtk_widget = gtk_menu_new;
}

method append(GTK::Simple::MenuItem $menu-item) {
    gtk_menu_shell_append($!gtk_widget, $menu-item.WIDGET);
}
