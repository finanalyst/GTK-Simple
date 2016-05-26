
use v6;

use NativeCall;
use GTK::NativeLib;
use GTK::Simple::Raw;
use GTK::Simple::Button;

unit class GTK::Simple::GladeApp;

class GtkBuilder is repr('CPointer') { }
class GObject is repr('CPointer') { }


my role SignalSupply[Str $handler] {
    my Str $.handler-name = $handler;
}

multi sub trait_mod:<is> (Attribute $a, Str :$gtk-signal-handler) is export {
    $a does SignalSupply[$gtk-signal-handler];
}

sub gtk_init(CArray[int32] $argc, CArray[CArray[Str]] $argv)
    is native(&gtk-lib)
    {*}

sub gtk_main()
    is native(&gtk-lib)
    {*}

sub gtk_main_quit()
    is native(&gtk-lib)
    {*}



# sub gtk_builder_new_from_string(Str $string, int $length) is native(&gtk-lib) returns GtkBuilder { ... }
sub gtk_builder_new_from_file(Str $string) is native(&gtk-lib) returns GtkBuilder { ... }
sub gtk_builder_get_object(GtkBuilder $builder, Str $name) is native(&gtk-lib) returns GObject { ... }
sub gtk_widget_show_all(GtkWidget $widget) is native(&gtk-lib) { ... }

sub gtk_builder_connect_signals_full( GtkBuilder, &GtkBuilderConnectFunc (
                                                                            GtkBuilder $builder,
                                                                            GObject $object,
                                                                            Str $signal-name,
                                                                            Str $handler-name,
                                                                            GObject $connect-object,
                                                                            int32 $connect-flags,
                                                                            OpaquePointer $user-data
                                                                          ) )
    is native(&gtk-lib)
    { * }

has $!builder;
has $!main-window;

has Supply $.signal-supply;

submethod BUILD() {
    _gtk_init();
    self._load;
}

sub _gtk_init() {
    my $arg_arr = CArray[Str].new;
    $arg_arr[0] = $*PROGRAM.Str;
    my $argc = CArray[int32].new;
    $argc[0] = 1;
    my $argv = CArray[CArray[Str]].new;
    $argv[0] = $arg_arr;
    gtk_init($argc, $argv);
}

method _load {
    $!builder = gtk_builder_new_from_file($*PROGRAM.IO.absolute ~ '.glade');
    $!main-window = gtk_builder_get_object($!builder, "mainWindow");
    die "Unable to find mainWindow in .glade file" unless $!main-window;

    my $signal-supplier = Supplier.new;
    $!signal-supply = $signal-supplier.Supply;

    my %handler-suppliers;

    for self.^attributes.grep(SignalSupply) -> $sig-attr {
        note "got attribute { $sig-attr.name }";
        my $supplier = Supplier.new;
        $sig-attr.set_value(self,$supplier.Supply);
        %handler-suppliers{$sig-attr.handler-name} = $supplier;
    }

    for self.^attributes -> $sig-attr {
      my GObject $gobject = gtk_builder_get_object($!builder, $sig-attr.name.subst(/^\$(\.|\!)/,''));
      if ($gobject) {
        note ">> found GObject for { $sig-attr.name } attribute, wrapping in GTK::Simple::Button";
        $sig-attr.set_value(self, GTK::Simple::Button.new(gtk_widget => $gobject ));
      }
    }

    sub conn(GtkBuilder $builder, GObject $object, Str $signal-name, Str $handler-name, GObject $connect-object, int32 $connect-flags, OpaquePointer $user-data) {
        note "Connecting Signals: $builder: $object $signal-name for $handler-name"; # <$connect-object> [$connect-flags] $user-data";
        my $connect-supplier = %handler-suppliers{$handler-name} // $signal-supplier;
        g_signal_connect_wd($object, $signal-name, -> $, $ {
           $connect-supplier.emit([$handler-name, $signal-name, $object]);
           CATCH { default { note "in signal supply for $handler-name:"; note $_; } }
        }, OpaquePointer, 0);
    }

    gtk_builder_connect_signals_full($!builder, &conn);
    g_signal_connect_wd($!main-window, "delete-event", -> $, $ {
      note 'Quitting on main-window delete-event';
      self.exit;
    }, OpaquePointer, 0);
}

method run() {
    gtk_widget_show($!main-window);
    gtk_main();
}

method exit() {
  gtk_main_quit();
}
