
use v6;

use NativeCall;
use GTK::Simple::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Scale does GTK::Simple::Widget;

has $!orientation;
has $!max;
has $!min;
has $!step;

sub gtk_scale_new_with_range( int32 $orientation, num64 $min, num64 $max, num64 $step )
    is native(&gtk-lib)
    returns GtkWidget
    {*}
# orientation:
# horizontal = 0
# vertical = 1 , inverts so that big numbers at top.
sub gtk_scale_set_digits( GtkWidget $scale, int32 $digits )
    is native( &gtk-lib)
    {*}
    
sub gtk_range_get_value( GtkWidget $scale )
    is native(&gtk-lib)
    returns num64
    {*}
    
sub gtk_range_set_value( GtkWidget $scale, num64 $value )
    is native(&gtk-lib)
    {*}

sub gtk_range_set_inverted( GtkWidget $scale, Bool $invertOK )
    is native(&gtk-lib)
    {*}
    
submethod BUILD(:$orientation = 'horizontal', :$value = 0.5, :$max = 1, :$min = 0, :$step = 0.01, Int :$digits = 2) {
    my $d = $orientation eq 'vertical' ?? 1 !! 0;
    $!gtk_widget = gtk_scale_new_with_range(
        $d.Int, $min.Num, $max.Num, $step.Num
    );
    gtk_range_set_inverted(self.WIDGET , True ) if $d == 1;
    gtk_scale_set_digits( self.WIDGET, $digits );
    gtk_range_set_value(self.WIDGET, $value.Num);
}

method value() 
    returns Num 
    is gtk-property(&gtk_range_get_value, &gtk_range_set_value) 
    { * }

has $!changed_supply;
method value-changed() {
    $!changed_supply //= do {
        my $s = Supplier.new;
        g_signal_connect_wd($!gtk_widget, "value-changed",
            -> $, $ {
                $s.emit(self);
                CATCH { default { note $_; } }
            },
            OpaquePointer, 0);
        $s.Supply;
    }
}
