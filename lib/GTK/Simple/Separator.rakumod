
use v6;

use GTK::Simple::Raw :separator;
use GTK::Simple::Widget;

unit class GTK::Simple::Separator does GTK::Simple::Widget;

submethod BUILD(:$orientation = 'horizontal') {
    my $d = $orientation eq 'vertical' ?? 1 !! 0;
    $!gtk_widget = gtk_separator_new($d);
}
