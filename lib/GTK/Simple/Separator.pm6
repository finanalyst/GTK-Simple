
use v6;

use NativeCall;
use GTK::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Separator does GTK::Simple::Widget;

sub gtk_separator_new(int32 $orientation)
    is native(&gtk-lib)
    returns GtkWidget
    { * }

submethod BUILD(:$orientation = 'horizontal') {
    my $d = $orientation eq 'vertical' ?? 1 !! 0;
    $!gtk_widget = gtk_separator_new($d);
}
