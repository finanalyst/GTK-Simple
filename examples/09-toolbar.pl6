

use v6;

use lib 'lib';
use NativeCall;
use GTK::Simple::Raw :box, :vbox, :DEFAULT;
use GTK::Simple::NativeLib;
use GTK::Simple::App;
use GTK::Simple::VBox;

enum GtkToolbarStyle is export (
    GTK_TOOLBAR_ICONS      => 0,
    GTK_TOOLBAR_TEXT       => 1,
    GTK_TOOLBAR_BOTH       => 2,
    GTK_TOOLBAR_BOTH_HORIZ => 3,
);

enum GtkWindowPosition is export (
    GTK_WIN_POS_NONE               => 0,
    GTK_WIN_POS_CENTER             => 1,
    GTK_WIN_POS_MOUSE              => 2,
    GTK_WIN_POS_CENTER_ALWAYS      => 3,
    GTK_WIN_POS_CENTER_ON_PARENT   => 4,
);

constant GTK_STOCK_NEW  is export = "gtk-new";
constant GTK_STOCK_OPEN is export = "gtk-open";
constant GTK_STOCK_SAVE is export = "gtk-save";
constant GTK_STOCK_QUIT is export = "gtk-quit";

sub gtk_window_set_position(GtkWidget $window, int32 $position)
    is native(&gtk-lib)
    is export
    { * }

sub gtk_window_set_default_size(GtkWidget $window, int32 $width, int32 $height)
    is native(&gtk-lib)
    is export
    { * }

sub gtk_toolbar_new()
    returns GtkWidget
    is native(&gtk-lib)
    is export(:toolbar)
    { * }

sub gtk_tool_button_new_from_stock(Str)
    returns GtkWidget
    is native(&gtk-lib)
    is export(:toolbar)
    { * }

sub gtk_separator_tool_item_new()
    returns GtkWidget
    is native(&gtk-lib)
    is export(:toolbar)
    { * }

sub gtk_toolbar_set_style(Pointer $toolbar, int32 $style)
    is native(&gtk-lib)
    is export(:toolbar)
    { * }

sub gtk_toolbar_insert(Pointer $toolbar, Pointer $button, int32)
    is native(&gtk-lib)
    is export(:toolbar)
    { * }

class GTK::Simple::Toolbar 
    does GTK::Simple::Widget
    does GTK::Simple::Box
{
    has $!item-count = 0;

    submethod BUILD(GtkToolbarStyle :$style = GTK_TOOLBAR_ICONS) {
        $!gtk_widget = gtk_toolbar_new;
        gtk_toolbar_set_style($!gtk_widget, $style);
    }

    method add-stock-menu-item(Str $icon) {
        my $button = gtk_tool_button_new_from_stock($icon);
        gtk_toolbar_insert($!gtk_widget, $button, -1);
        $!item-count++;
        $button;
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
}

my $app = GTK::Simple::App.new(title => "Toolbar Demo");

gtk_window_set_default_size($app.WIDGET, 300, 200);
gtk_window_set_position($app.WIDGET, GTK_WIN_POS_CENTER);

my $toolbar = GTK::Simple::Toolbar.new;
my $newTb  = $toolbar.add-stock-menu-item(GTK_STOCK_NEW);
my $openTb = $toolbar.add-stock-menu-item(GTK_STOCK_OPEN);
my $saveTb = $toolbar.add-stock-menu-item(GTK_STOCK_SAVE);
my $sep    = $toolbar.add-separator();
my $exitTb = $toolbar.add-stock-menu-item(GTK_STOCK_QUIT);
my $vbox = $toolbar.pack;
$app.set-content( $vbox );

#TODO events via supplies
#
#  g_signal_connect(G_OBJECT(exitTb), "clicked", 
#        G_CALLBACK(gtk_main_quit), NULL);
#
#  g_signal_connect(G_OBJECT(window), "destroy",
#        G_CALLBACK(gtk_main_quit), NULL);

gtk_widget_show_all($app.WIDGET);
$app.run;
