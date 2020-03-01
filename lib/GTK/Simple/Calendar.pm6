
use GTK::Simple::Raw :calendar, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;
use NativeCall;

unit class GTK::Simple::Calendar does GTK::Simple::Widget is export;

has int32 $.year;
has int32 $.month;
has int32 $.day;

has Supply $!selection-supply;

submethod BUILD() {
    $!gtk_widget = gtk_calendar_new();
}

method day-selected() {
    $!selection-supply //= do {
        my $s = Supplier.new();
        g_signal_connect_wd(self.WIDGET, "day-selected",
                -> $, $ {
                    self!refresh-date;
                    $s.emit(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
        $s.Supply;
    }
}

method DateTime() {
    self!refresh-date;
    DateTime.new:
            :$!year,
            :$!month,
            :$!day;
}

method !refresh-date() {
    gtk_calendar_get_date(self.WIDGET, $!year, $!month, $!day);
    $!month++;  # Returned as zero indexed
}
