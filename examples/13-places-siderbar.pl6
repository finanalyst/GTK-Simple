#!/usr/bin/env perl6

use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::PlacesSidebar;

my $app             = GTK::Simple::App.new(:title("Places Sidebar Demo"));
my $places-sidebar  = GTK::Simple::PlacesSidebar.new;

$app.set-content( $places-sidebar );
$app.border-width = 20;

$app.run;
