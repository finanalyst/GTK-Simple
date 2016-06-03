

use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::Toolbar;

my $app = GTK::Simple::App.new(title => "Toolbar Demo");

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

$app.show-all;
$app.run;
