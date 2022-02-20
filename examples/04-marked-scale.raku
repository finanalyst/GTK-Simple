#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple;
use GTK::Simple::App;

my GTK::Simple::App $app .=new( :title( 'More widgets') );
=comment
    We introduce the MarkUpLabel and Scale widgets

my %texts = <blue red> Z=>
    '<span foreground="blue" size="x-large">Blue text</span> is <i>cool</i>!',
    '<span foreground="red" size="x-large">Red text</span> is <b>hot</b>!'
;
my $mx = 30;
my $mn = 2.5;

$app.set-content(
    GTK::Simple::VBox.new( 
        GTK::Simple::HBox.new(
            my $inner = GTK::Simple::VBox.new( 
                my $normal-label = GTK::Simple::Label.new(:text("Normal label: %texts<blue>" ) ),
=comment
    a vanilla label shows up the mark up text as text

                my $marked-label = GTK::Simple::MarkUpLabel.new(:text("Label with markup: %texts<blue>") ),
=comment
    a MarkUpLabel is almost the same as a vanilla Label, but it renders the Pango markup.
    See https://developer.gnome.org/pango/unstable/PangoMarkupFormat.html for more information

                my $bR = GTK::Simple::CheckButton.new(:label('Make Red')),
                my $bB = GTK::Simple::ToggleButton.new(:label('Make Blue')),
		my $bSyn = GTK::Simple::ToggleButton.new(:label('Synchronise')),
                my $label-for-vertical = GTK::Simple::MarkUpLabel.new(:text('Vertical scale value is:')),
	        my $label-for-horizontal = GTK::Simple::MarkUpLabel.new(:text('Horizontal scale value is:')),
            ),
            my $scale-vertical = GTK::Simple::Scale.new(:orientation<vertical>, :max($mx), :min($mn), :step(0.5), :value(21) ),
=comment
    A scale widget is used to provide a numerical value
    Here is the vertical form. The maximum value is at the top.

        ),
        my $scale-horizontal = GTK::Simple::Scale.new()
=comment
    The default GTK::Simple::Scale behavior is horizontal orientation, with :min(0) :max(1) :step(0.1) :value(0.5)

    )
);

sub make-blue($b) {
    $normal-label.text = "Normal label: %texts<blue>";
    $marked-label.text = "Label with markup: %texts<blue>";
}

sub make-red($b) {
    $normal-label.text = "Normal label: %texts<red>";
    $marked-label.text = "Label with markup: %texts<red>";
}

sub vertical-changes($b) {
    $label-for-vertical.text = 'Number is <span foreground="green" size="large">' ~ $scale-vertical.value ~'</span>';
}

sub horizontal-changes($b) {
    $label-for-horizontal.text = 'Number is <span foreground="green" size="large">' ~ $scale-horizontal.value ~'</span>';
}

sub sync($b) {
    $scale-vertical.adjust: $mn + $scale-horizontal.value * ($mx-$mn)
}

$bB.toggled.tap: &make-blue;
$bR.toggled.tap: &make-red;
$bSyn.toggled.tap: &sync;
$scale-vertical.value-changed.tap: &vertical-changes;
=comment
    Note the call-back name is value-changed, not changed for a text entry

$scale-horizontal.value-changed.tap: &horizontal-changes;

$inner.border-width = 20;
$app.border-width = 20;
$app.run;
