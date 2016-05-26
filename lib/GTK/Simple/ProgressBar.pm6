
use NativeCall;
use GTK::Simple::Raw :progress-bar;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::ProgressBar does GTK::Simple::Widget;

submethod BUILD() {
    $!gtk_widget = gtk_progress_bar_new();
}

method pulse() {
    gtk_progress_bar_pulse($!gtk_widget);
}

method fraction() 
    returns Rat
    is gtk-property(&gtk_progress_bar_get_fraction, &gtk_progress_bar_set_fraction, -> $, $val { Num($val) })
    { * }
