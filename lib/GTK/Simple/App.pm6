
use v6;

use nqp;
use NativeCall;
use GTK::Simple::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Widget;
use GTK::Simple::Container;

unit class GTK::Simple::App
    does GTK::Simple::Widget
    does GTK::Simple::Container;

sub gtk_init(CArray[int32] $argc, CArray[CArray[Str]] $argv)
    is native(&gtk-lib)
    is export
    {*}

sub gtk_main()
    is native(&gtk-lib)
    is export
    {*}

sub gtk_main_quit()
    is native(&gtk-lib)
    is export
    {*}

submethod BUILD(:$title, Bool :$exit-on-close = True) {
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
