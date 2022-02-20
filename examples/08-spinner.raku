#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple;
use GTK::Simple::App;

my GTK::Simple::App $app = GTK::Simple::App.new(title => 'Spinner');


my GTK::Simple::Spinner $spinner = GTK::Simple::Spinner.new;

my $start-button = GTK::Simple::Button.new(label => "Start Spinning");
my $stop-button  = GTK::Simple::Button.new(label => "Stop Spinning");

my $hbox = GTK::Simple::HBox.new($start-button, $stop-button);

$start-button.clicked.tap({ $spinner.start });
$stop-button.clicked.tap({ $spinner.stop });

my $vbox = GTK::Simple::VBox.new($spinner, $hbox);


$vbox.spacing = 10;

$app.set-content($vbox);

$app.border-width = 20;

$app.run;
