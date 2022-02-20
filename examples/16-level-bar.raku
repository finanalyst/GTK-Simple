#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::Button;
use GTK::Simple::HBox;
use GTK::Simple::LevelBar;
use GTK::Simple::TextView;
use GTK::Simple::ToggleButton;
use GTK::Simple::VBox;

my $app = GTK::Simple::App.new(title => 'Level Bar Demo');

my $level-bar       = GTK::Simple::LevelBar.new;
my $inc-button      = GTK::Simple::Button.new(:label("+"));
my $dec-button      = GTK::Simple::Button.new(:label("-"));
my $inverted-button = GTK::Simple::ToggleButton.new(:label("Inverted"));
my $text-view       = GTK::Simple::TextView.new;

sub update-status {
    $text-view.text = sprintf("value=%3.2f, min=%3.2f, max=%3.2f, inverted=%s\n",
        $level-bar.value, $level-bar.min-value, $level-bar.max-value,
        $level-bar.inverted);
}

$inc-button.clicked.tap: {
    $level-bar.value = Num(min($level-bar.value + 0.1, $level-bar.max-value));
    update-status;
}

$dec-button.clicked.tap: {
    $level-bar.value = Num(max($level-bar.value - 0.1, $level-bar.min-value));
    update-status;
}

$inverted-button.clicked.tap: {
    $level-bar.inverted = $inverted-button.status;
    update-status;
}


$level-bar.offset-changed.tap: {
    $text-view.text ~= "offset-changed triggered\n";
    update-status;
}

update-status;

$app.set-content(
    GTK::Simple::VBox.new([
        GTK::Simple::HBox.new($inc-button, $dec-button, $inverted-button),
        $level-bar,
        $text-view,
    ])
);

$app.border-width = 20;
$app.run;
