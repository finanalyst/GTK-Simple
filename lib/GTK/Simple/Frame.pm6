
use v6;

use NativeCall;
use GTK::Simple::Raw :frame;
use GTK::Simple::Common;
use GTK::Simple::Widget;
use GTK::Simple::Container;

unit class GTK::Simple::Frame does GTK::Simple::Widget does GTK::Simple::Container;

submethod BUILD(Str :$label) {
    $!gtk_widget = gtk_frame_new($label);
}

method label() 
    returns Str 
    is gtk-property(&gtk_frame_get_label, &gtk_frame_set_label)
    { * }
