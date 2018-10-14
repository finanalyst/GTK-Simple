
use v6;

use nqp;
use NativeCall;
use GTK::Simple::Raw :drawing-area, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;
need GTK::Simple::ConnectionHandler;

my Mu $cairo_t;
my Mu $Cairo_Context;
my Bool $cairo-loaded = False;

sub gtk_simple_use_cairo( --> Bool ) is export {
    try require ::('Cairo');
    if ::('Cairo') ~~ Failure {
        $cairo-loaded = False;
    }
    else {
        $cairo_t := ::('Cairo')::('cairo_t');
        $Cairo_Context := ::('Cairo')::('Context');
        $cairo-loaded = True;
    }
    $cairo-loaded;
}

unit class GTK::Simple::DrawingArea does GTK::Simple::Widget;

submethod BUILD() {
    $!gtk_widget = gtk_drawing_area_new();
}

method add-draw-handler(&handler) {
    die "'Cairo' module is not loaded, check it is installed and that you called 'gtk_simple_use_cairo'" unless $cairo-loaded;
    my sub handler_wrapper($widget, $cairop) {
        my $cairo  = nqp::box_i($cairop.Int, $cairo_t);
        my $ctx    = $Cairo_Context.new($cairo);
        handler(self, $ctx);
    }
    GTK::Simple::ConnectionHandler.new(
        :instance($!gtk_widget),
        :handler(g_signal_connect_wd($!gtk_widget, "draw", &handler_wrapper, OpaquePointer, 0)));
}

method add_draw_handler(&handler) {
    DEPRECATED('add-draw-handler',Any,'0.3.2');
    self.add-draw-handler(&handler);
}
