
use GTK::Simple::Raw :calendar, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;

class GTK::Simple::Calendar does GTK::Simple::Widget is export {
    submethod BUILD() {
        $!gtk_widget = gtk_calendar_new();
    }

    method set-date(DateTime $dt) {

    }
}

class GTK::Simple::Calendar::Button is export {

}
