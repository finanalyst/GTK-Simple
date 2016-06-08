
use v6;
use NativeCall;
use GTK::Simple::Raw :radio-button, :toggle-button, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::CheckButton;

unit class GTK::Simple::RadioButton is GTK::Simple::CheckButton;

submethod BUILD(:$label = '') {
    self.WIDGET( gtk_radio_button_new_with_label(Nil, $label) );
}

method add(GTK::Simple::RadioButton $radio-button) {
    gtk_radio_button_join_group( self.WIDGET, $radio-button.WIDGET )
}
