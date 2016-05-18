#!/usr/bin/env perl6

use GTK::Simple;

my GTK::Simple::App $app = GTK::Simple::App.new(title => 'Boxes');


my GTK::Simple::StatusBar $status = GTK::Simple::StatusBar.new;

my $root_ctx = $status.get-context-id("Root");
$status.push-status($root_ctx, "Running");

my $button1 = GTK::Simple::Button.new(label => "button one");
my $button1_ctx = $status.get-context-id("Button One");

my $button2 = GTK::Simple::Button.new(label => "button two");
my $button2_ctx = $status.get-context-id("Button One");

my $progress = GTK::Simple::ProgressBar.new;

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


my $sep1 = GTK::Simple::Separator.new;
my $sep2 = GTK::Simple::Separator.new;
my $vbox = GTK::Simple::VBox.new($hbox,$sep1, $progress, $sep2, $status);


$vbox.spacing = 10;

$app.set_content($vbox);

$app.border_width = 20;

$app.run;
