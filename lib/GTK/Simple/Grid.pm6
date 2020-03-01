
use v6;

use GTK::Simple::Raw :grid, :DEFAULT;
use GTK::Simple::Widget;
use GTK::Simple::Common;

unit class GTK::Simple::Grid does GTK::Simple::Widget;

method new(*@pieces) {
    my $grid = self.bless();
    for @pieces -> $pair {
        die "please provide pairs with a 4-tuple of coordinates => the widget" unless +@($pair.key) == 4;
        gtk_grid_attach($grid.WIDGET, $pair.value.WIDGET, |@($pair.key));
        gtk_widget_show($pair.value.WIDGET);
    }
    $grid;
}

submethod BUILD() {
    $!gtk_widget = gtk_grid_new();
}

method row-spacing($spacing)
    returns int32
    is gtk-property(&gtk_grid_get_row_spacing, &gtk_grid_set_row_spacing)
    {*}

method column-spacing($spacing)
        returns int32
        is gtk-property(&gtk_grid_get_column_spacing, &gtk_grid_set_column_spacing)
        {*}