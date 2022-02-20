#!/usr/bin/env perl6

use v6.c;
use lib 'lib';
use GTK::Simple;
use GTK::Simple::App;

my $app = GTK::Simple::App.new(title=> 'Example 17');
my $send-history = GTK::Simple::TextView.new(text=>'Old stuff');
my $flood-data = GTK::Simple::ToggleButton.new(label=>'Flood with stuff');
my $exit-b = GTK::Simple::ToggleButton.new(label=>'Exit');

my $scrolled = GTK::Simple::ScrolledWindow.new;

=comment
    ScrolledWindow is a container, so standard container commands work

$scrolled.set-content( $send-history );

my $v  = GTK::Simple::VBox.new( 
    $flood-data,
    $scrolled,
    $exit-b
);

$flood-data.toggled.tap: -> $b { 
    my $s = 'Twas brillig and the slithy toothes did gyre and gymbol';
    for ^25 { $send-history.text ~= (' ' x $_) ~ "$s\n" }
};
$exit-b.toggled.tap(-> $b { $app.exit } );

$app.set-content( $v );
$app.border-width = 20;
$app.run;
