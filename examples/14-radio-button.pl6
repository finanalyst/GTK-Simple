#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::RadioButton;
use GTK::Simple::VBox;

my $app = GTK::Simple::App.new(title => 'Radio Button Demo');

$app.set-content(
    GTK::Simple::VBox.new(
        my $radio3-button = GTK::Simple::RadioButton.new(:label("Bread")),
        my $radio2-button = GTK::Simple::RadioButton.new(:label("Cheese")),
        my $radio1-button = GTK::Simple::RadioButton.new(:label("Milk")),
        my $radio4-button = GTK::Simple::RadioButton.new(:label("Meat")),
    )
);

$app.border-width = 20;
$app.run;
