
use v6;

use NativeCall;
use GTK::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::ToggleButton;

unit class GTK::Simple::Switch is GTK::Simple::ToggleButton;

sub gtk_switch_new()
    is native(&gtk-lib)
    returns GtkWidget
    {*}

sub gtk_switch_get_active(GtkWidget $w)
    returns int32
    is native(&gtk-lib)
    {*}

sub gtk_switch_set_active(GtkWidget $w, int32 $a)
    is native(&gtk-lib)
    {*}

method creation-sub {
    sub ($) {
        gtk_switch_new()
    }
}

method status()
    returns Bool
    is gtk-property(&gtk_switch_get_active, &gtk_switch_set_active)
    { * }
