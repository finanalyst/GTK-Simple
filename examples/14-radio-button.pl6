#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::RadioButton;
use GTK::Simple::VBox;

my $app = GTK::Simple::App.new(title => 'Radio Button Demo');

my $radio1-button = GTK::Simple::RadioButton.new(:label("Bread"));
my $radio2-button = GTK::Simple::RadioButton.new(:label("Cheese"));
my $radio3-button = GTK::Simple::RadioButton.new(:label("Milk"));
my $radio4-button = GTK::Simple::RadioButton.new(:label("Meat"));

$radio2-button.add($radio1-button);
$radio3-button.add($radio1-button);
$radio4-button.add($radio1-button);

$app.set-content(
    GTK::Simple::VBox.new(
        $radio1-button, $radio2-button, $radio3-button, $radio4-button
    )
);

$app.border-width = 20;
$app.run;
