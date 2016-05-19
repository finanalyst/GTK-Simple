#!/usr/bin/env perl6

use GTK::Simple;

my $app = GTK::Simple::App.new(title => 'Text');

my $editable    = GTK::Simple::CheckButton.new(label => 'Editable');
$editable.status = True;
my $show-cursor = GTK::Simple::CheckButton.new(label => 'Show Cursor');
$show-cursor.status = True;
my $text-view   = GTK::Simple::TextView.new;

$editable.toggled.tap(-> $w { $text-view.editable = $w.status });
$show-cursor.toggled.tap( -> $w { $text-view.cursor-visible = $w.status });

my $vbox = GTK::Simple::VBox.new($editable, $show-cursor, $text-view);

$app.set_content($vbox);


$app.run;

# vim: expandtab shiftwidth=4 ft=perl6
