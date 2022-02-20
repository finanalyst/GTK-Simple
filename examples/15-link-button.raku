#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::LinkButton;
use GTK::Simple::TextView;
use GTK::Simple::VBox;

my $app = GTK::Simple::App.new(title => 'Link Button Demo');

my $link1-button = GTK::Simple::LinkButton.new(:label("Perl 6"),
    :uri("http://perl6.org"));
my $link2-button = GTK::Simple::LinkButton.new(:label("Perl 6 Docs"),
    :uri("http://doc.perl6.org"));
my $text-view   = GTK::Simple::TextView.new;

$link1-button.activate-link.tap: {
    $text-view.text ~= sprintf("activate-link %s triggered, visited=%s\n",
        $link1-button.uri, $link1-button.visited);
}

$link2-button.activate-link.tap: {
    $text-view.text ~= sprintf("activate-link %s triggered, visited=%s\n",
        $link2-button.uri, $link2-button.visited);
}

$app.set-content(
    GTK::Simple::VBox.new([
        { :widget($link1-button), :expand(False) },
        { :widget($link2-button), :expand(False) },
        $text-view,
    ])
);

$app.border-width = 20;
$app.run;
