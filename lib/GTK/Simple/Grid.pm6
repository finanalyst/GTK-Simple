
use v6;

use NativeCall;
use GTK::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Widget;

unit class GTK::Simple::Grid does GTK::Simple::Widget;

sub gtk_grid_new()
    is native(&gtk-lib)
    returns GtkWidget
    {*}

sub gtk_grid_attach(GtkWidget $grid, GtkWidget $child, int32 $x, int32 $y, int32 $w, int32 $h)
    is native(&gtk-lib)
    {*}

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
