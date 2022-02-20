
use v6;

use NativeCall;
use GTK::Simple::Raw :link-button, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Button;

unit class GTK::Simple::LinkButton is GTK::Simple::Button;

has $!activate-link-supply;

submethod BUILD(:$label!, :$uri!) {
    self.WIDGET( gtk_link_button_new_with_label($uri, $label) );
}

method uri() 
    returns Str
    is gtk-property(&gtk_link_button_get_uri, &gtk_link_button_set_uri)
    { * }

method visited() 
    returns Str
    is gtk-property(&gtk_link_button_get_visited, &gtk_link_button_set_visited)
    { * }

method activate-link() {
    $!activate-link-supply //= do {
        my $s = Supplier.new;
        g_signal_connect_wd(self.WIDGET, "activate-link",
            -> $, $ {
                $s.emit(self);
                CATCH { default { note $_; } }
            },
            OpaquePointer, 0);
        $s.Supply;
    }
}
