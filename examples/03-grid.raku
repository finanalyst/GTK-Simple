#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple;
use GTK::Simple::App;

my GTK::Simple::App $app .= new(title => "Grid layouts!");

=comment
    The interesting bit of this example is the grid constructor.

$app.set-content(
    my $grid = GTK::Simple::Grid.new(
=comment
        As you can see, you pass pairs with a coordinate and size on the left
        and the widget on the right. Once again we're free to directly define
        and assign a variable to hold the widget for later on.

=comment
        The parameters are x, y, w and h specifying which cell in the grid
        will hold the top left corner of the widget and how many cells
        in the horizontal and vertical direction the widget will occupy.

        [0, 0, 1, 1] => my $tlb = GTK::Simple::Button.new(label => "up left"),
        [1, 0, 1, 1] => my $trb = GTK::Simple::Button.new(label => "up right"),


=comment
        Here we have a label that's as wide as the two buttons above.

        [0, 1, 2, 1] => my $mid = GTK::Simple::Label.new(text => "hey there!"),


=comment
        Just some more buttons on the bottom just like at the top

        [0, 2, 1, 1] => my $blb = GTK::Simple::ToggleButton.new(label => "bottom left"),
        [1, 2, 1, 1] => my $brb = GTK::Simple::ToggleButton.new(label => "bottom right"),

=comment
        And for no good reason we put a label (Lx10) to the right that spans the
        whole height of our grid.

        [2, 0, 1, 3] => my $sdl = GTK::Simple::Label.new(text => "L\n" x 10),
    )
);

=comment
    You can also put grids inside HBox or VBox containers and vice versa.
    This allows for some pretty complex layouts to be created.

$app.border-width = 20;

=comment
    Perhaps later, say in response to an action by another widget, you want to add to the grid.
    Use the attach method and provide a list of pairs exactly as for C<new>

$grid.attach( [3, 0, 1, 1] => GTK::Simple::Label.new(text => "I got added later"), );

=comment
   Then we put another Label into the grid, but we want the text in that text
   to be length for that column

$grid.attach( [1, 3, 1, 1] => GTK::Simple::Entry.new(text => "try expanding"), );
$grid.baseline-row: 4;

$app.run;
