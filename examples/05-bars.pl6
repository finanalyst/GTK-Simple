#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple;
use GTK::Simple::App;

my GTK::Simple::App $app = GTK::Simple::App.new(title => 'Boxes');


my GTK::Simple::StatusBar $status = GTK::Simple::StatusBar.new;

$status.tooltip-text = "I am a status bar";

my $root_ctx = $status.get-context-id("Root");
$status.push-status($root_ctx, "Running");

my $button1 = GTK::Simple::Button.new(label => "button one");
my $button1_ctx = $status.get-context-id("Button One");
$button1.tooltip-text = "I'm a button";

my $button2 = GTK::Simple::Button.new(label => "button two");
my $button2_ctx = $status.get-context-id("Button One");
$button2.tooltip-text = "I'm another button";

my $progress = GTK::Simple::ProgressBar.new;
$progress.tooltip-text = "And this is a progress bar";

$button1.clicked.tap({
    if $progress.fraction < 1.0 {
        $progress.fraction += 0.2;
        $status.push-status($button1_ctx, "Button One Clicked - { $progress.fraction * 100 }%");
        if $progress.fraction == 1.0 {
            $button1.label = "Done";
            $button2.label = "Done";
        }
    }
    else {
        $app.exit;
    }
});

$button2.clicked.tap({
    if $progress.fraction < 1.0 {
        $progress.fraction += 0.2;
        $status.push-status($button2_ctx, "Button Two Clicked - { $progress.fraction * 100 }%");
        if $progress.fraction == 1.0 {
            $button1.label = "Done";
            $button2.label = "Done";
        }
    }
    else {
        $app.exit;
    }
});

my $hbox = GTK::Simple::HBox.new($button1, $button2);

my $frame = GTK::Simple::Frame.new(label => "Status");
$frame.set-content($status);

my $action = GTK::Simple::ActionBar.new;
$action.tooltip-text = "this is an action bar";

$action.pack-start(GTK::Simple::Button.new(label => 'Action Bar Left'));
$action.pack-end(GTK::Simple::Button.new(label => 'Action Bar Right'));

my $sep1 = GTK::Simple::Separator.new;
my $sep2 = GTK::Simple::Separator.new;
my $sep3 = GTK::Simple::Separator.new;
my $vbox = GTK::Simple::VBox.new($hbox,$sep1, $progress, $sep2, $action, $sep3, $frame);


$vbox.spacing = 10;

$app.set-content($vbox);

$app.border-width = 20;

$app.run;
