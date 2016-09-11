#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::HBox;
use GTK::Simple::RadioButton;
use GTK::Simple::TextView;
use GTK::Simple::VBox;

my $app = GTK::Simple::App.new(title => 'Radio Button Demo');

my $radio1-button = GTK::Simple::RadioButton.new(:label("Bread"));
my $radio2-button = GTK::Simple::RadioButton.new(:label("Cheese"));
my $radio3-button = GTK::Simple::RadioButton.new(:label("Milk"));
my $radio4-button = GTK::Simple::RadioButton.new(:label("Meat"));
my $text-view     = GTK::Simple::TextView.new();

$radio2-button.add($radio1-button);
$radio3-button.add($radio1-button);
$radio4-button.add($radio1-button);

sub show-radio-button-status($) {
    my @radio-buttons = ($radio1-button, $radio2-button, $radio3-button,
        $radio4-button);
    my $text = '';
    for @radio-buttons -> $radio-button {
        my $status = $radio-button.status ?? "Selected" !! "Unselected";
        $text ~= sprintf("%s is %s\n", $radio-button.label, $status);
    }
    $text-view.text = $text;
}

$radio1-button.toggled.tap: &show-radio-button-status;
$radio2-button.toggled.tap: &show-radio-button-status;
$radio3-button.toggled.tap: &show-radio-button-status;
$radio4-button.toggled.tap: &show-radio-button-status;

show-radio-button-status(Nil);

$app.set-content(
    GTK::Simple::HBox.new(
        GTK::Simple::VBox.new($radio1-button, $radio2-button, $radio3-button, $radio4-button),
        $text-view,
    )
);

$app.border-width = 20;
$app.run;
