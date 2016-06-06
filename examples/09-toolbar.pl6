#!/usr/bin/env perl6

use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::Button;
use GTK::Simple::MenuToolButton;
use GTK::Simple::Toolbar;
use GTK::Simple::VBox;

my $app = GTK::Simple::App.new(title => "Toolbar Demo");

my $toolbar = GTK::Simple::Toolbar.new;
$toolbar.add-menu-item(
    my $new-toolbar-button  = GTK::Simple::MenuToolButton.new(:icon(GTK_STOCK_NEW))
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

my $toolbar-vbox  = $toolbar.pack;
my $bottom-button = GTK::Simple::Button.new(:label("Bottom space")),

$app.set-content(
    GTK::Simple::VBox.new(
        [
            { :widget($toolbar-vbox), :expand(False) },
            $bottom-button
        ]
    )
);

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
