

use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::Toolbar;
use GTK::Simple::MenuToolButton;

my $app = GTK::Simple::App.new(title => "Toolbar Demo");

my $toolbar = GTK::Simple::Toolbar.new;
$toolbar.add-menu-item(
    my $new-toolbar-button = GTK::Simple::MenuToolButton.new(:icon(GTK_STOCK_NEW))
);
$toolbar.add-menu-item(
    my $open-toolbar-button = GTK::Simple::MenuToolButton.new(:icon(GTK_STOCK_OPEN))
);
$toolbar.add-menu-item(
    my $save-toolbar-button = GTK::Simple::MenuToolButton.new(:icon(GTK_STOCK_SAVE))
);
$toolbar.add-separator;
$toolbar.add-menu-item(
    my $exit-toolbar-button = GTK::Simple::MenuToolButton.new(:icon(GTK_STOCK_QUIT))
);

my $vbox = $toolbar.pack;
$app.set-content( $vbox );

$new-toolbar-button.clicked.tap: {
    "New toolbar button clicked".say;
}
$open-toolbar-button.clicked.tap: {
    "Open toolbar button clicked".say;
}
$save-toolbar-button.clicked.tap: {
    "Save toolbar button clicked".say;
}
$exit-toolbar-button.clicked.tap: {
    $app.exit;
}

$app.show-all;
$app.run;
