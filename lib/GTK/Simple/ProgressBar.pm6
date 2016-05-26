
use NativeCall;
use GTK::Simple::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::ProgressBar does GTK::Simple::Widget;

sub gtk_progress_bar_new()
    is native(&gtk-lib)
    returns GtkWidget
    { * }

submethod BUILD() {
    $!gtk_widget = gtk_progress_bar_new();
}

sub gtk_progress_bar_pulse(GtkWidget $widget)
    is native(&gtk-lib)
    { * }

method pulse() {
    gtk_progress_bar_pulse($!gtk_widget);
}

sub gtk_progress_bar_set_fraction(GtkWidget $widget, num64 $fractions)
    is native(&gtk-lib)
    { * }

sub gtk_progress_bar_get_fraction(GtkWidget $widget)
    is native(&gtk-lib)
    returns num64
    { * }


method fraction() 
    returns Rat
    is gtk-property(&gtk_progress_bar_get_fraction, &gtk_progress_bar_set_fraction, -> $, $val { Num($val) })
    { * }
