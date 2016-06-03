
use v6;

use nqp;
use NativeCall;
use GTK::Simple::Raw :app, :DEFAULT;
use GTK::Simple::Widget;
use GTK::Simple::Container;

unit class GTK::Simple::App
    does GTK::Simple::Widget
    does GTK::Simple::Container;

submethod BUILD(
    Str :$title,
    Bool :$exit-on-close = True,
    Int :$width = 300, Int :$height = 200,
    GtkWindowPosition :$position = GTK_WIN_POS_CENTER
) {
    my $arg_arr = CArray[Str].new;
    $arg_arr[0] = $*PROGRAM.Str;
    my $argc = CArray[int32].new;
    $argc[0] = 1;
    my $argv = CArray[CArray[Str]].new;
    $argv[0] = $arg_arr;
    gtk_init($argc, $argv);

    $!gtk_widget = gtk_window_new(0);
    gtk_window_set_title($!gtk_widget, $title.Str) if defined $title;

    if $exit-on-close {
        g_signal_connect_wd($!gtk_widget, "delete-event",
          -> $, $ {
              self.exit
          }, OpaquePointer, 0);
    }

    # Set window default size and position
    gtk_window_set_default_size($!gtk_widget, $width, $height);
    gtk_window_set_position($!gtk_widget, $position);
}

method exit() {
    gtk_main_quit();
}


method run() {
    self.show();
    gtk_main();
}

method g-timeout(Cool $usecs) {
    my $s = Supplier.new;
    my $starttime = nqp::time_n();
    my $lasttime  = nqp::time_n();
    g_timeout_add($usecs.Int,
        sub (*@) {
            my $dt = nqp::time_n() - $lasttime;
            $lasttime = nqp::time_n();
            $s.emit((nqp::time_n() - $starttime, $dt));

            return 1;
        }, OpaquePointer);
    return $s.Supply;
}

method g_timeout(Cool $usecs) {
    DEPRECATED('g-timeout',Any,'0.3.2');
    self.g-timeout($usecs);
}
