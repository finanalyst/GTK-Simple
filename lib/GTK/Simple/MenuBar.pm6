
use v6;
use GTK::Simple::Raw :menu-bar, :menu, :box, :vbox, :DEFAULT;
use GTK::Simple::VBox;
use GTK::Simple::Widget;

unit class GTK::Simple::MenuBar does GTK::Simple::Widget;

use GTK::Simple::MenuItem;

submethod BUILD() {
    $!gtk_widget = gtk_menu_bar_new;
}

method append(GTK::Simple::MenuItem $menu-item) {
    gtk_menu_shell_append($!gtk_widget, $menu-item.WIDGET);
}

method pack() {
    my $vbox = GTK::Simple::VBox.new;
    gtk_box_pack_start($vbox.WIDGET, $!gtk_widget, 0, 0, 0);
    $vbox;
}
