
use v6;

use GTK::Simple::Raw :grid, :DEFAULT;
use GTK::Simple::Widget;

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
