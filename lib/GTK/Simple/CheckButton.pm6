
use v6;

use NativeCall;
use GTK::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::ToggleButton;

unit class GTK::Simple::CheckButton is GTK::Simple::ToggleButton;

sub gtk_check_button_new_with_label(Str $label)
    is native(&gtk-lib)
    returns GtkWidget
    {*}

method creation-sub {
    &gtk_check_button_new_with_label
}
