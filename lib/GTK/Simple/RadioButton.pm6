
use v6;
use GTK::Simple::Raw :radio-button;
use GTK::Simple::CheckButton;

unit class GTK::Simple::RadioButton is GTK::Simple::CheckButton;

submethod BUILD(:$label = '') {
    $!gtk_widget = gtk_radio_button_new_with_label(
        Nil, $label);
}

method add(GTK::Simple::RadioButton :$radio-button) {
    gtk_radio_button_join_group($!gtk_widget, $radio-button.WIDGET)
}
