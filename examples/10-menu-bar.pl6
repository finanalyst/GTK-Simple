#!/usr/bin/env perl6

use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::MenuBar;
use GTK::Simple::Menu;
use GTK::Simple::MenuItem;

my $app = GTK::Simple::App.new(title => "Menu Bar Demo");

my $menu-bar = GTK::Simple::MenuBar.new;

my $file-menu-item = GTK::Simple::MenuItem.new(:label("File"));
my $file-menu = GTK::Simple::Menu.new(:menu-item($file-menu-item));
my $quit-menu-item = GTK::Simple::MenuItem.new(:label("Quit"));
$file-menu.append($quit-menu-item);
$menu-bar.append($file-menu);

$quit-menu-item.clicked.tap: {
    $app.exit;
}

$menu-bar.pack;

$app.show-all;
$app.run;
