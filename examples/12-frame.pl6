#!/usr/bin/env perl6

use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::Frame;
use GTK::Simple::TextView;
use GTK::Simple::VBox;

my $app        = GTK::Simple::App.new(:title("Frame Demo"));
my $text-view  = GTK::Simple::TextView.new(:text("Some Text"));
my $frame      = GTK::Simple::Frame.new(:label("Some Label"));

my $vbox           = GTK::Simple::VBox.new($text-view);
$vbox.border-width = 20;
$frame.set-content( $vbox );
$app.set-content( $frame );
$app.border-width = 20;

$app.run;
