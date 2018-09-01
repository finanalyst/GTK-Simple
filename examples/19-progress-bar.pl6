#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple;
use GTK::Simple::App;

my $app = GTK::Simple::App.new(title => 'Progress Bar');
my $percent = GTK::Simple::Label.new(text => "0%");
my $probar = GTK::Simple::ProgressBar.new;
my $probar-pulse = GTK::Simple::ProgressBar.new;

my $start-button = GTK::Simple::Button.new(label => "Click to increment progress..");
$start-button.clicked.tap({
    
    $probar.fraction += 0.01; 
    $percent.text = Str($probar.fraction * 100) ~ "%";

    $probar-pulse.pulse;

    if $probar.fraction == 1.0 {
        $start-button.label = "Done";

        $start-button.clicked.tap({
            $app.exit;
        });
    }
});

my $vbox = GTK::Simple::VBox.new(
    $percent,
    $probar,
    $probar-pulse,
    $start-button
);
$vbox.spacing = 10;

$app.set-content($vbox);
$app.border-width = 20;
$app.run;

