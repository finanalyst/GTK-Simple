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
my $vbox          = GTK::Simple::VBox.new($text-view);
$text-view.text = q:to/SAMPLE/;
    This is some lines of text to show alignment of box
    All the lines should be aligned RIGHT
    Default for a TextView is align CENTER
    Also possible are LEFT and FILL
    SAMPLE
$text-view.alignment = RIGHT;
$vbox.border-width = 20;
$frame.set-content( $vbox );
$app.set-content( $frame );
$app.border-width = 20;

$app.run;
