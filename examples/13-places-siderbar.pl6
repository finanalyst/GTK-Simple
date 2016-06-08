#!/usr/bin/env perl6

use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::ToggleButton;
use GTK::Simple::HBox;
use GTK::Simple::PlacesSidebar;
use GTK::Simple::VBox;

my $app             = GTK::Simple::App.new(:title("Places Sidebar Demo"));
my $places-sidebar  = GTK::Simple::PlacesSidebar.new;

$places-sidebar.open-location.tap: {
    "open-location event triggered".say;
    #TODO get the location parameter
    # See https://developer.gnome.org/gtk3/stable/GtkPlacesSidebar.html#GtkPlacesSidebar-open-location)
}

my $show-trash-button = GTK::Simple::ToggleButton.new( :label("Show Trash") );
$show-trash-button.toggled.tap: {
    $places-sidebar.show-trash = not $places-sidebar.show-trash;
};

my $show-recent-button = GTK::Simple::ToggleButton.new( :label("Show Recent") );
$show-recent-button.toggled.tap: {
    $places-sidebar.show-recent = not $places-sidebar.show-recent;
};

my $show-desktop-button = GTK::Simple::ToggleButton.new( :label("Show Desktop") );
$show-desktop-button.toggled.tap: {
    $places-sidebar.show-desktop = not $places-sidebar.show-desktop;
};

my $show-connect-to-server-button = GTK::Simple::ToggleButton.new( 
    :label("Show Connect to Server") );
$show-connect-to-server-button.toggled.tap: {
    $places-sidebar.show-connect-to-server = 
        not $places-sidebar.show-connect-to-server;
};

my $show-other-locations-button = GTK::Simple::ToggleButton.new(
    :label("Show Other Locations") );
$show-other-locations-button.toggled.tap: {
    $places-sidebar.show-other-locations = not $places-sidebar.show-other-locations;
};

# Update initial toggle button status
$show-trash-button.status             = $places-sidebar.show-trash;
$show-recent-button.status            = $places-sidebar.show-recent;
$show-desktop-button.status           = $places-sidebar.show-desktop;
$show-connect-to-server-button.status = $places-sidebar.show-connect-to-server;
$show-other-locations-button.status   = $places-sidebar.show-other-locations;

$app.set-content(
    GTK::Simple::HBox.new(
        $places-sidebar,
        GTK::Simple::VBox.new(
            $show-trash-button,
            $show-recent-button,
            $show-desktop-button,
            $show-connect-to-server-button,
            $show-other-locations-button,
        )
    )
);
$app.border-width = 20;

$app.run;
