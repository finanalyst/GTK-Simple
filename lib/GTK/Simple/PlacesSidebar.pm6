use v6;

use NativeCall;
use GTK::Simple::Raw :places-sidebar, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::PlacesSidebar does GTK::Simple::Widget;

has $!open-location-supply;

submethod BUILD() {
    $!gtk_widget = gtk_places_sidebar_new();
}

method local-only() 
    returns Bool
    is gtk-property(&gtk_places_sidebar_get_local_only, &gtk_places_sidebar_set_local_only)
    { * }

method open-flags() 
    returns GtkPlacesOpenFlags
    is gtk-property(&gtk_places_sidebar_get_open_flags, &gtk_places_sidebar_set_open_flags)
    { * }

#TODO populate-all
#method populate-all() 
#    returns Bool
#    is gtk-property(&gtk_places_sidebar_get_text, &gtk_places_sidebar_set_text)
#    { * }

method show-connect-to-server() 
    returns Bool
    is gtk-property(&gtk_places_sidebar_get_show_connect_to_server, &gtk_places_sidebar_set_show_connect_to_server)
    { * }

method show-desktop() 
    returns Bool
    is gtk-property(&gtk_places_sidebar_get_show_desktop, &gtk_places_sidebar_set_show_desktop)
    { * }

#TODO show-enter-location
#method show-enter-location()
#    returns GFile
#    is gtk-property(&gtk_places_sidebar_get_enter_location, &gtk_places_sidebar_set_enter_location)
#    { * }

method show-other-locations()
    returns Bool
    is gtk-property(&gtk_places_sidebar_get_show_other_locations, &gtk_places_sidebar_set_show_other_locations)
    { * }

method show-recent()
    returns Bool
    is gtk-property(&gtk_places_sidebar_get_show_recent, &gtk_places_sidebar_set_show_recent)
    { * }

method show-trash()
    returns Bool
    is gtk-property(&gtk_places_sidebar_get_show_trash, &gtk_places_sidebar_set_show_trash)
    { * }

method open-location() {
    $!open-location-supply //= do {
        my $s = Supplier.new;
        g_signal_connect_wd($!gtk_widget, "open-location",
            -> $, $ {
                $s.emit(self);
                CATCH { default { note $_; } }
            },
            OpaquePointer, 0);
        $s.Supply;
    }
}
