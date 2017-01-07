#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple;
use GTK::Simple::App;

=comment
    Like every GTK::Simple application, we begin by
    creating a new C<GTK::Simple::App>.

my GTK::Simple::App $app .= new(title => "Toggle buttons");


=comment
    This time, we create a C<GTK::Simple::Label> to display a bit of
    info to the user and above and below that we create one
    C<GTK::Simple::CheckButton> and a C<GTK::Simple::ToggleButton>.

$app.set-content(
    GTK::Simple::VBox.new(
        my $check_button  = GTK::Simple::CheckButton.new(label => "check me out!"),
        my $status_label  = GTK::Simple::Label.new(text => "the toggles are off and off"),
        my $toggle_button = GTK::Simple::ToggleButton.new(label=> "time to toggle!"),
    )
);


=comment
    Since the window would end up terribly tiny otherwise, we set a
    quite generous inner border for the window

$app.border-width = 50;

=comment
    This sub will be called whenever we toggle either of the two Buttons.

sub update_label($b) {
    $status_label.text = "the toggles are " ~
        ($check_button, $toggle_button)>>.status.map({ <off on>[$_] }).join(" and ");
}


=comment
    Now all we need to do is to connect the C<update_label> sub to the
    C<toggled> supply of the buttons.

$check_button\.toggled.tap: &update_label;
$toggle_button.toggled.tap: &update_label;


=comment
    Finally, we let the event loop run.

$app.run;
