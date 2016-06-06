use v6;

use NativeCall;
use GTK::Simple::Raw :places-sidebar;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::PlacesSidebar does GTK::Simple::Widget;

submethod BUILD() {
    $!gtk_widget = gtk_places_sidebar_new();
}
