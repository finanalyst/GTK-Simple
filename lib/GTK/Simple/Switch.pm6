
use v6;

use GTK::Simple::Raw :switch;
use GTK::Simple::Common;
use GTK::Simple::ToggleButton;

unit class GTK::Simple::Switch is GTK::Simple::ToggleButton;


submethod BUILD() {
    self.WIDGET( gtk_switch_new() );
}

method status()
    returns Bool
    is gtk-property(&gtk_switch_get_active, &gtk_switch_set_active)
    { * }
