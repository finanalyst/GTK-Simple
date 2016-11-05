
use v6;

use GTK::Simple::Raw :scrolled-window, :DEFAULT;
use GTK::Simple::Widget;
use GTK::Simple::Container;

use NativeCall;

unit class GTK::Simple::ScrolledWindow
    does GTK::Simple::Widget
    does GTK::Simple::Container;

submethod BUILD(Cool :$title = "Gtk Scrolled Window", 
                GtkPolicyType :$hpolicy = GTK_POLICY_AUTOMATIC,
                GtkPolicyType :$vpolity = GTK_POLICY_AUTOMATIC) {
    $!gtk_widget = gtk_scrolled_window_new(Pointer, Pointer); # the null paramenters are for 'hadjust' structures, not normally needed
    gtk_scrolled_window_set_policy($!gtk_widget, $hpolicy, $vpolity);
}
