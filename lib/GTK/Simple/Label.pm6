
use v6;

use NativeCall;
use GTK::NativeLib;
use GTK::GDK;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Label does GTK::Simple::Widget;

sub gtk_label_new(Str $text)
    is native(&gtk-lib)
    returns GtkWidget
    {*}

sub gtk_label_get_text(GtkWidget $label)
    is native(&gtk-lib)
    returns Str
    {*}

sub gtk_label_set_text(GtkWidget $label, Str $text)
    is native(&gtk-lib)
    {*}

submethod BUILD(:$text = '') {
    $!gtk_widget = gtk_label_new($text);
}

method text() 
    returns Str
    is gtk-property(&gtk_label_get_text, &gtk_label_set_text)
    { * }
