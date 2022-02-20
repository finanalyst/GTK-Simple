
use v6;

use GTK::Simple::Raw :check-button;
use GTK::Simple::Common;
use GTK::Simple::ToggleButton;

unit class GTK::Simple::CheckButton is GTK::Simple::ToggleButton;

submethod BUILD(:$label!) {
    self.WIDGET( gtk_check_button_new_with_label($label) );
}
