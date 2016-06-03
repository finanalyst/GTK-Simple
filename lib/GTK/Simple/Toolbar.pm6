
use v6;
use GTK::Simple::Raw :toolbar, :box, :vbox, :DEFAULT;
use GTK::Simple::VBox;
use GTK::Simple::Widget;

unit class GTK::Simple::Toolbar does GTK::Simple::Widget;

use GTK::Simple::MenuToolButton;

has $!item-count = 0;

enum GtkToolbarStyle is export (
    GTK_TOOLBAR_ICONS      => 0,
    GTK_TOOLBAR_TEXT       => 1,
    GTK_TOOLBAR_BOTH       => 2,
    GTK_TOOLBAR_BOTH_HORIZ => 3,
);

constant GTK_STOCK_NEW  is export = "gtk-new";
constant GTK_STOCK_OPEN is export = "gtk-open";
constant GTK_STOCK_SAVE is export = "gtk-save";
constant GTK_STOCK_QUIT is export = "gtk-quit";

submethod BUILD(GtkToolbarStyle :$style = GTK_TOOLBAR_ICONS) {
    $!gtk_widget = gtk_toolbar_new;
    gtk_toolbar_set_style($!gtk_widget, $style);
}

method add-menu-item(GTK::Simple::MenuToolButton $button) {
    gtk_toolbar_insert($!gtk_widget, $button.WIDGET, -1);
    $!item-count++;
}

method add-separator() {
    my $sep = gtk_separator_tool_item_new;
    gtk_toolbar_insert($!gtk_widget, $sep, -1);
    $!item-count++;
    $sep;
}

method pack() {
    my $vbox = GTK::Simple::VBox.new;
    gtk_box_pack_start($vbox.WIDGET, $!gtk_widget, 0, 0, $!item-count);
    $vbox;
}
