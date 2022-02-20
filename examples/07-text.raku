#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple;
use GTK::Simple::App;

my GTK::Simple::App $app = GTK::Simple::App.new(title => 'Text');

my $editable    = GTK::Simple::CheckButton.new(label => 'Editable');
$editable.status = True;
my $show-cursor = GTK::Simple::CheckButton.new(label => 'Show Cursor');
$show-cursor.status = True;

my $monospace = GTK::Simple::CheckButton.new(label => 'Monospaced');
$monospace.status = False;

my $text-view   = GTK::Simple::TextView.new;

$editable.toggled.tap(-> $w { $text-view.editable = $w.status });
$show-cursor.toggled.tap( -> $w { $text-view.cursor-visible = $w.status });
$monospace.toggled.tap( -> $w { $text-view.monospace = $w.status });

my $vbox = GTK::Simple::VBox.new($editable, $show-cursor, $monospace, $text-view);

$app.set-content($vbox);


$app.run;

# vim: expandtab shiftwidth=4 ft=perl6
