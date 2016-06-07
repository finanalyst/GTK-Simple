
use v6;

use GTK::Simple::Raw :radio-button;
use GTK::Simple::Widget;

unit class GTK::Simple::RadioButton does GTK::Simple::Widget;

submethod BUILD(:$label = '') {
    $!gtk_widget = &gtk_radio_button_new_with_label(Nil, $label);
}
