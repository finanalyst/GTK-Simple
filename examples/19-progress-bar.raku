#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple;
use GTK::Simple::App;

my $app = GTK::Simple::App.new(title => 'Progress Bar');
my $percent = GTK::Simple::Label.new(text => "0%");
my $progress-bar = GTK::Simple::ProgressBar.new;
my $progress-bar-pulse = GTK::Simple::ProgressBar.new;
my $start-button = GTK::Simple::Button.new(label => "Click to increment progress..");

$start-button.clicked.tap({
    my $increase-fraction = 0.01;
    $progress-bar.fraction += $increase-fraction;

    my $by-percentage = 100;
    $percent.text = Str($progress-bar.fraction * $by-percentage) ~ "%";
    $progress-bar-pulse.pulse;

    my $full = 1.0;
    if $progress-bar.fraction == $full {
        $start-button.label = "Done";
        $start-button.clicked.tap({$app.exit});
    }
});

my $grid = GTK::Simple::Grid.new(
    [0, 0, 1, 1] => $percent,
    [0, 1, 1, 1] => $progress-bar,
    [0, 2, 1, 1] => $progress-bar-pulse,
    [0, 3, 1, 1] => $start-button
);

$app.set-content($grid);
$app.run;
