
use v6;

use NativeCall;
use GTK::Simple::Raw :scale, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Scale does GTK::Simple::Widget;

has $!orientation;
has $!max;
has $!min;
has $!step;
has $!changed_supply;

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
