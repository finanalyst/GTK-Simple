
use v6;

use GTK::Simple::Raw :label;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Label does GTK::Simple::Widget;

submethod BUILD(:$text = '') {
    $!gtk_widget = gtk_label_new($text);
}

method text() 
    returns Str
    is gtk-property(&gtk_label_get_text, &gtk_label_set_text)
    { * }
