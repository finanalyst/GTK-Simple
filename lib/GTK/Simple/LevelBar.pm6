use v6;

use NativeCall;
use GTK::Simple::Raw :level-bar, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::LevelBar is GTK::Simple::Widget;

has $!offset-changed-supply;

submethod BUILD {
    self.WIDGET( gtk_level_bar_new );
}

method inverted()
    returns Bool
    is gtk-property(&gtk_level_bar_get_inverted, &gtk_level_bar_set_inverted)
    { * }

method max-value()
    returns Rat
    is gtk-property(&gtk_level_bar_get_max_value, &gtk_level_bar_set_max_value)
    { * }

method min-value()
    returns Rat
    is gtk-property(&gtk_level_bar_get_min_value, &gtk_level_bar_set_min_value)
    { * }

method mode() 
    returns GtkLevelBarMode
    is gtk-property(&gtk_level_bar_get_mode, &gtk_level_bar_set_mode)
    { * }

method value()
    returns Num
    is gtk-property(&gtk_level_bar_get_value, &gtk_level_bar_set_value)
    { * }

method offset-changed() {
    $!offset-changed-supply //= do {
        my $s = Supplier.new;
        g_signal_connect_wd(self.WIDGET, "offset-changed",
            -> $, $ {
                $s.emit(self);
                CATCH { default { note $_; } }
            },
            OpaquePointer, 0);
        $s.Supply;
    }
}
