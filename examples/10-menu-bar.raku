#!/usr/bin/env perl6

use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::MenuBar;
use GTK::Simple::Menu;
use GTK::Simple::MenuItem;


my $app = GTK::Simple::App.new(title => "Menu Bar Demo");

my $file-menu-item = GTK::Simple::MenuItem.new(:label("File"));
$file-menu-item.set-sub-menu(
    my $file-menu = GTK::Simple::Menu.new
);

my $quit-menu-item = GTK::Simple::MenuItem.new(:label("Quit"));
$file-menu.append($quit-menu-item);

my $menu-bar = GTK::Simple::MenuBar.new;
$menu-bar.append($file-menu-item);

$quit-menu-item.activate.tap: {
    $app.exit;
}

my $vbox = $menu-bar.pack;
$app.set-content( $vbox );

$app.show-all;
$app.run;
