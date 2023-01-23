#!/usr/bin/env perl6

use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::MenuBar;
use GTK::Simple::Menu;
use GTK::Simple::MenuItem;
use GTK::Simple::CheckMenuItem;
use GTK::Simple::Label;


my $app = GTK::Simple::App.new(title => "Menu Bar Demo");

my $file-menu-item = GTK::Simple::MenuItem.new(:label("File"));
$file-menu-item.set-sub-menu(
    my $file-menu = GTK::Simple::Menu.new
);

my $option-menu-item = GTK::Simple::CheckMenuItem.new(:label("Check option"));
$file-menu.append($option-menu-item);

my $quit-menu-item = GTK::Simple::MenuItem.new(:label("Quit"));
$file-menu.append($quit-menu-item);

my $menu-bar = GTK::Simple::MenuBar.new;
$menu-bar.append($file-menu-item);

$quit-menu-item.activate.tap: {
    $app.exit;
}

my $vbox = $menu-bar.pack;

my $option-label = GTK::Simple::Label.new(:text("Option not checked"));
$option-menu-item.toggled.tap: {
    $option-label.text = $option-menu-item.active ?? "Option checked" !! "Option not checked";
}

$vbox.pack-start($option-label);

$app.set-content( $vbox );

$app.show-all;
$app.run;
