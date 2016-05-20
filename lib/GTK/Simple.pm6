use nqp;
use GTK::NativeLib;
use NativeCall;

use GTK::GDK;

class GtkWidget is repr('CPointer') { }

my Mu $cairo_t;
my Mu $Cairo_Context;

sub gtk_simple_use_cairo() is export {
    try {
        require Cairo;
        $cairo_t := ::('cairo_t');
        $Cairo_Context := ::('Cairo')::('Context');
    }
}

# gtk_widget_... {{{

sub gtk_widget_show(GtkWidget $widgetw)
    is native(&gtk-lib)
    {*}

sub gtk_widget_hide(GtkWidget $widgetw)
    is native(&gtk-lib)
    { * }

sub gtk_widget_show_all(GtkWidget $widgetw)
    is native(&gtk-lib)
    { * }

sub gtk_widget_set_no_show_all(GtkWidget $widgetw, int32 $no_show_all)
    is native(&gtk-lib)
    { * }

sub gtk_widget_get_no_show_all(GtkWidget $widgetw) 
    returns int32
    is native(&gtk-lib)
    { * }

sub gtk_widget_destroy(GtkWidget $widget)
    is native(&gtk-lib)
    {*}

sub gtk_widget_set_sensitive(GtkWidget $widget, int32 $sensitive)
    is native(&gtk-lib)
    {*}

sub gtk_widget_get_sensitive(GtkWidget $widget)
    returns int32
    is native(&gtk-lib)
    {*}

sub gtk_widget_set_size_request(GtkWidget $widget, int32 $w, int32 $h)
    is native(&gtk-lib)
    {*}

sub gtk_widget_get_allocated_height(GtkWidget $widget)
    returns int32
    is native(&gtk-lib)
    {*}

sub gtk_widget_get_allocated_width(GtkWidget $widget)
    returns int32
    is native(&gtk-lib)
    {*}

sub gtk_widget_queue_draw(GtkWidget $widget)
    is native(&gtk-lib)
    {*}

sub gtk_widget_get_tooltip_text(GtkWidget $widget)
    is native(&gtk-lib)
    returns Str
    { * }

sub gtk_widget_set_tooltip_text(GtkWidget $widget, Str $text)
    is native(&gtk-lib)
    { * }

sub gtk_window_new(int32 $window_type)
    is native(&gtk-lib)
    returns GtkWidget
    {*}

sub gtk_window_set_title(GtkWidget $w, Str $title)
    is native(&gtk-lib)
    returns GtkWidget
    {*}

# gtk_widget_ ... }}}

# gtk_container_... {{{
sub gtk_container_add(GtkWidget $container, GtkWidget $widgen)
    is native(&gtk-lib)
    {*}

sub gtk_container_get_border_width(GtkWidget $container)
    returns int32
    is native(&gtk-lib)
    {*}

sub gtk_container_set_border_width(GtkWidget $container, int32 $border_width)
    is native(&gtk-lib)
    {*}

# gtk_container_... }}}

# g_signal... {{{

sub g_signal_connect_wd(GtkWidget $widget, Str $signal,
    &Handler (GtkWidget $h_widget, OpaquePointer $h_data),
    OpaquePointer $data, int32 $connect_flags)
    returns int32
    is native(&gobject-lib)
    is symbol('g_signal_connect_object')
    { * }

sub g_signal_handler_disconnect(GtkWidget $widget, int32 $handler_id)
    is native(&gobject-lib)
    { * }

# g_signal... }}}

sub g_idle_add(
        &Handler (OpaquePointer $h_data),
        OpaquePointer $data)
    is native(&glib-lib)
    returns int32
    {*}

sub g_timeout_add(int32 $interval, &Handler (OpaquePointer $h_data, --> int32), OpaquePointer $data)
    is native(&gtk-lib)
    returns int32
    {*}


# This is almost a copy of that in AccessorFacade, adjusted to operate
# on Widget objects.
my role GTK::Simple::PropertyFacade[&get, &set, &before?, &after?] {
    method CALL-ME(*@args) is rw {
        my $self = @args[0];
        Proxy.new(
            FETCH   => sub ($) {
                my $val =  &get($self.WIDGET);
                my $ret-type = self.signature.returns;
                if not $ret-type =:= Mu {
                    if $val !~~ $ret-type {
                        try {
                            $val = $ret-type($val);
                        }
                    }
                }
                $val;
           },
           STORE   =>  sub ($, $val is copy ) {
                my $store-val;
                if &before.defined {
                    $store-val = &before($self, $val);
                }
                else {
                    $store-val = $val.value;
                    CATCH {
                        default {
                            $store-val = $val;
                        }
                    }
                }
                my $rc = &set($self.WIDGET, $store-val);
                if &after.defined {
                    &after($self, $rc);
                }
            }
        );
    }
}

# the actual trait, not exported as it is of marginal use outside
multi sub trait_mod:<is> (Method $m, :@gtk-property! (&getter, &setter, &before?, &after?) ) {
    $m does GTK::Simple::PropertyFacade[&getter, &setter, &before, &after];
}

class GTK::Simple::ConnectionHandler {
    has $.instance;
    has $.handler;
    has $.connected = True;

    method disconnect {
        if $.connected {
            g_signal_handler_disconnect($.instance, $.handler);
            $!connected = False;
        }
    }
}

role GTK::Simple::Widget {
    has $!gtk_widget;

    method WIDGET() {
        $!gtk_widget
    }

    method WINDOW() {
        my $result = gtk_widget_get_window($!gtk_widget);
        $result;
    }

    method sensitive() 
        returns Bool 
        is gtk-property(&gtk_widget_get_sensitive, &gtk_widget_set_sensitive) 
        { * }

    method tooltip-text() 
        returns Str 
        is gtk-property(&gtk_widget_get_tooltip_text, &gtk_widget_set_tooltip_text)
        { * }

    method no-show-all() 
        returns Bool
        is gtk-property(&gtk_widget_get_no_show_all, &gtk_widget_set_no_show_all)
        { * }

    method events {
        my $window = self.WINDOW;
        my class GdkEventMaskWrapper {
            method set(*@events) {
                my $mask = gdk_window_get_events($window);
                $mask +|= [+|] @events;
                gdk_window_set_events($window, $mask)
            }
            method get {
                my int32 $mask = gdk_window_get_events($window);
                return do for EVENT_MASK::.values {
                    if $mask +& +$_ {
                        $_
                    }
                }
            }
            method clear {
                gdk_window_set_events($window, 0);
            }
        }
        GdkEventMaskWrapper.new
    }

    method signal-supply(Str $name) {
        my $s = Supplier.new;
        g_signal_connect_wd($!gtk_widget, $name,
            -> $widget, $event {
                $s.emit(($widget, $event));
                CATCH { default { note "in signal supply for $name:"; note $_; } }
            },
            OpaquePointer, 0);
        $s.Supply;
    }

    method signal_supply(Str $name) {
        DEPRECATED('signal-supply');
        self.signal-supply($name);
    }

    method size-request(Cool $width, Cool $height) {
        gtk_widget_set_size_request($!gtk_widget, $width.Int, $height.Int);
    }

    method size_request(Cool $width, Cool $height) {
        DEPRECATED('size-request');
        self.size-request($width, $height);
    }

    method width() {
        gtk_widget_get_allocated_width($!gtk_widget);
    }
    method height() {
        gtk_widget_get_allocated_height($!gtk_widget);
    }

    method queue-draw() {
        gtk_widget_queue_draw($!gtk_widget);
    }

    method queue_draw() { 
        DEPRECATED('queue-draw');
        self.queue-draw();
    }

    method destroy() {
        gtk_widget_destroy($!gtk_widget);
    }

    method show() {
        gtk_widget_show($!gtk_widget);
    }

    method hide() {
        gtk_widget_show($!gtk_widget);
    }

    # All widgets get the 'delete-event'
    has $!deleted_supply;
    #| Tap this supply to react to the window being closed
    method deleted() {
        $!deleted_supply //= do {
            my $s = Supplier.new;
            g_signal_connect_wd($!gtk_widget, "delete-event",
                -> $, $ {
                    $s.emit(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s.Supply;
        }
    }
}

role GTK::Simple::Container {

    method set-content($widget) {
        gtk_container_add(self.WIDGET, $widget.WIDGET);
        gtk_widget_show($widget.WIDGET);
    }

    method set_content($widget) {
        DEPRECATED('set-content');
        self.set-content($widget);
    }

    method border-width 
        returns Int
        is gtk-property(&gtk_container_get_border_width, &gtk_container_set_border_width)
        { * }

    method border_width() { 
        DEPRECATED('border-width');
        self.border-width
    }
}

class GTK::Simple::Scheduler does Scheduler {
    my class Queue is repr('ConcBlockingQueue') { }
    my $queue := nqp::create(Queue);

    my &idle_cb = sub ($a) { GTK::Simple::Scheduler.process-queue; return 0 };

    method cue(&code, :$at, :$in, :$every, :$times, :&catch ) {
        die "GTK::Simple::Scheduler does not support at" if $at;
        die "GTK::Simple::Scheduler does not support in" if $in;
        die "GTK::Simple::Scheduler does not support every" if $every;
        die "GTK::Simple::Scheduler does not support times" if $times;
        my &run := &catch
            ?? -> { code(); CATCH { default { catch($_) } } }
            !! &code;
        nqp::push($queue, &run);
        g_idle_add(&idle_cb, OpaquePointer);
        return Nil;
    }

    method process-queue() {
        my Mu $task := nqp::queuepoll($queue);
        unless nqp::isnull($task) {
            if nqp::islist($task) {
                my Mu $code := nqp::shift($task);
                $code(|nqp::hllize($task, Any));
            }
            else {
                $task();
            }
        }
    }

    method process_queue() {
        DEPRECATED('process-queue');
        self.process-queue();
    }

    method loads() { nqp::elems($queue) }
}

class GTK::Simple::Window does GTK::Simple::Widget
                       does GTK::Simple::Container {
    submethod BUILD(Cool :$title = "Gtk Window") {
        $!gtk_widget = gtk_window_new(0);
        gtk_window_set_title($!gtk_widget, $title.Str);
    }
}

class GTK::Simple::App does GTK::Simple::Widget
                       does GTK::Simple::Container {
    sub gtk_init(CArray[int32] $argc, CArray[CArray[Str]] $argv)
        is native(&gtk-lib)
        {*}

    sub gtk_main()
        is native(&gtk-lib)
        {*}

    sub gtk_main_quit()
        is native(&gtk-lib)
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
        DEPRECATED('g-timeout');
        self.g-timeout($usecs);
    }


}

role GTK::Simple::Box does GTK::Simple::Container {
    sub gtk_box_pack_start(GtkWidget, GtkWidget, int32, int32, int32)
        is native(&gtk-lib)
        {*}

    sub gtk_box_get_spacing(GtkWidget $box)
        returns int32
        is native(&gtk-lib)
        {*}

    sub gtk_box_set_spacing(GtkWidget $box, int32 $spacing)
        is native(&gtk-lib)
        {*}

    multi method new(*@packees) {
        my $box = self.bless();
        $box.pack-start($_) for @packees;
        $box
    }

    method pack-start($widget) {
        gtk_box_pack_start(self.WIDGET, $widget.WIDGET, 1, 1, 0);
        gtk_widget_show($widget.WIDGET);
    }

    method pack_start($widget) {
        DEPRECATED('pack-start');
        self.pack-start($widget);
    }

    method spacing 
        returns Int
        is gtk-property(&gtk_box_get_spacing, &gtk_box_set_spacing)
        { * }
}

class GTK::Simple::HBox does GTK::Simple::Widget does GTK::Simple::Box {
    sub gtk_hbox_new(int32, int32)
        is native(&gtk-lib)
        returns GtkWidget
        {*}

    submethod BUILD() {
        $!gtk_widget = gtk_hbox_new(0, 0);
    }
}

class GTK::Simple::VBox does GTK::Simple::Widget does GTK::Simple::Box {
    sub gtk_vbox_new(int32, int32)
        is native(&gtk-lib)
        returns GtkWidget
        {*}

    submethod BUILD() {
        $!gtk_widget = gtk_vbox_new(0, 0);
    }
}

class GTK::Simple::Grid does GTK::Simple::Widget {
    sub gtk_grid_new()
        is native(&gtk-lib)
        returns GtkWidget
        {*}

    sub gtk_grid_attach(GtkWidget $grid, GtkWidget $child, int32 $x, int32 $y, int32 $w, int32 $h)
        is native(&gtk-lib)
        {*}

    method new(*@pieces) {
        my $grid = self.bless();
        for @pieces -> $pair {
            die "please provide pairs with a 4-tuple of coordinates => the widget" unless +@($pair.key) == 4;
            gtk_grid_attach($grid.WIDGET, $pair.value.WIDGET, |@($pair.key));
            gtk_widget_show($pair.value.WIDGET);
        }
        $grid;
    }

    submethod BUILD() {
        $!gtk_widget = gtk_grid_new();
    }
}

class GTK::Simple::Label does GTK::Simple::Widget {
    sub gtk_label_new(Str $text)
        is native(&gtk-lib)
        returns GtkWidget
        {*}

    sub gtk_label_get_text(GtkWidget $label)
        is native(&gtk-lib)
        returns Str
        {*}

    sub gtk_label_set_text(GtkWidget $label, Str $text)
        is native(&gtk-lib)
        {*}

    submethod BUILD(:$text = '') {
        $!gtk_widget = gtk_label_new($text);
    }

    method text() 
        returns Str
        is gtk-property(&gtk_label_get_text, &gtk_label_set_text)
        { * }
}

# RNH additions 
class GTK::Simple::MarkUpLabel does GTK::Simple::Widget {
    sub gtk_label_new(Str $text)
        is native(&gtk-lib)
        returns GtkWidget
        {*}

    sub gtk_label_get_text(GtkWidget $label)
        is native(&gtk-lib)
        returns Str
        {*}

    sub gtk_label_set_text(GtkWidget $label, Str $text)
        is native(&gtk-lib)
        {*}

    sub gtk_label_set_markup(GtkWidget $label, Str $text)
        is native(&gtk-lib)
        {*}

    submethod BUILD(:$text = '') {
        $!gtk_widget = gtk_label_new(''.Str);
        gtk_label_set_markup($!gtk_widget,$text.Str);
    }

    method text() 
        returns Str 
        is gtk-property(&gtk_label_get_text, &gtk_label_set_markup)
        { * }
}

class GTK::Simple::Scale does GTK::Simple::Widget {
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
}
# RNH end

class GTK::Simple::Entry does GTK::Simple::Widget {
    sub gtk_entry_new()
        is native(&gtk-lib)
        returns GtkWidget
        {*}

    sub gtk_entry_get_text(GtkWidget $entry)
        is native(&gtk-lib)
        returns Str
        {*}

    sub gtk_entry_set_text(GtkWidget $entry, Str $text)
        is native(&gtk-lib)
        {*}

    submethod BUILD(:$text) {
        $!gtk_widget = gtk_entry_new();
        gtk_entry_set_text(self.WIDGET, $text.Str) if defined $text;
    }

    method text()
        returns Str 
        is gtk-property(&gtk_entry_get_text, &gtk_entry_set_text)
        { * }

    has $!changed_supply;
    method changed() {
        $!changed_supply //= do {
            my $s = Supplier.new;
            g_signal_connect_wd($!gtk_widget, "changed",
                -> $, $ {
                    $s.emit(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s.Supply;
        }
    }
}

class GTK::Simple::TextView does GTK::Simple::Widget {
    sub gtk_text_view_new()
        is native(&gtk-lib)
        returns GtkWidget
        {*}

    our sub gtk_text_view_get_buffer(GtkWidget $view)
        is native(&gtk-lib)
        returns OpaquePointer
        {*}

    our sub gtk_text_buffer_get_text(OpaquePointer $buffer, CArray[int32] $start,
            CArray[int32] $end, int32 $show_hidden)
        is native(&gtk-lib)
        returns Str
        {*}

    our sub gtk_text_buffer_get_start_iter(OpaquePointer $buffer, CArray[int32] $i)
        is native(&gtk-lib)
        {*}

    our sub gtk_text_buffer_get_end_iter(OpaquePointer $buffer, CArray[int32] $i)
        is native(&gtk-lib)
        {*}

    our sub gtk_text_buffer_set_text(OpaquePointer $buffer, Str $text, int32 $len)
        is native(&gtk-lib)
        {*}

    has $!buffer;

    submethod BUILD() {
        $!gtk_widget = gtk_text_view_new();
        $!buffer = gtk_text_view_get_buffer($!gtk_widget);
    }

    # this one can't use the trait for the time being as
    # the functions need an additional argument.
    method text() {
        Proxy.new:
            FETCH => {
                gtk_text_buffer_get_text($!buffer, self!start-iter(),
                    self!end-iter(), 1)
            },
            STORE => -> \c, \text {
                gtk_text_buffer_set_text($!buffer, text.Str, -1);
            }
    }

    method !start-iter() {
        my $iter_mem = CArray[int32].new;
        $iter_mem[31] = 0; # Just need a blob of memory.
        gtk_text_buffer_get_start_iter($!buffer, $iter_mem);
        $iter_mem
    }

    method !end-iter() {
        my $iter_mem = CArray[int32].new;
        $iter_mem[16] = 0;
        gtk_text_buffer_get_end_iter($!buffer, $iter_mem);
        $iter_mem
    }

    has $!changed_supply;
    method changed() {
        $!changed_supply //= do {
            my $s = Supplier.new;
            g_signal_connect_wd(
                $!buffer, "changed",
                -> $, $ {
                    $s.emit(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s.Supply;
        }
    }

    sub gtk_text_view_set_editable(GtkWidget $widget, int32 $setting) 
        is native(&gtk-lib)
        { * }

    sub gtk_text_view_get_editable(GtkWidget $widget) 
        is native(&gtk-lib)
        returns int32
        { * }

    method editable() 
        returns Bool
        is gtk-property(&gtk_text_view_get_editable, &gtk_text_view_set_editable)
        { * }

    sub gtk_text_view_set_cursor_visible(GtkWidget $widget, int32 $setting) 
        is native(&gtk-lib)
        { * }

    sub gtk_text_view_get_cursor_visible(GtkWidget $widget) 
        is native(&gtk-lib)
        returns int32
        { * }

    method cursor-visible() 
        returns Bool
        is gtk-property(&gtk_text_view_get_cursor_visible, &gtk_text_view_set_cursor_visible)
        { * }

    
    sub gtk_text_view_get_monospace(GtkWidget $widget)
        is native(&gtk-lib)
        returns int32
        { * }

    sub gtk_text_view_set_monospace(GtkWidget $widget, int32 $setting)
        is native(&gtk-lib)
        { * }

    method monospace()
        returns Bool
        is gtk-property(&gtk_text_view_get_monospace, &gtk_text_view_set_monospace)
        { * }

}

class GTK::Simple::Button does GTK::Simple::Widget {
    sub gtk_button_new_with_label(Str $label)
        is native(&gtk-lib)
        returns GtkWidget
        {*}

    multi submethod BUILD(:$!gtk_widget){}

    multi submethod BUILD(:$label!) {
        $!gtk_widget = gtk_button_new_with_label($label);
    }

    sub gtk_button_get_label(GtkWidget $widget)
        is native(&gtk-lib)
        returns Str
        { * }

    sub gtk_button_set_label(GtkWidget $widget, Str $label)
        is native(&gtk-lib)
        { * }

    method label() 
        returns Str
        is gtk-property(&gtk_button_get_label, &gtk_button_set_label)
        { * }

    has $!clicked_supply;
    method clicked() {
        $!clicked_supply //= do {
            my $s = Supplier.new;
            g_signal_connect_wd($!gtk_widget, "clicked",
                -> $, $ {
                    $s.emit(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s.Supply;
        }
    }
}


class GTK::Simple::ToggleButton does GTK::Simple::Widget {
    sub gtk_toggle_button_new_with_label(Str $label)
        is native(&gtk-lib)
        returns GtkWidget
        {*}

    sub gtk_toggle_button_get_active(GtkWidget $w)
        is native(&gtk-lib)
        returns int32
        {*}

    sub gtk_toggle_button_set_active(GtkWidget $w, int32 $active)
        is native(&gtk-lib)
        returns int32
        {*}

    method creation-sub {
        &gtk_toggle_button_new_with_label
    }

    submethod BUILD(:$label!) {
        $!gtk_widget = self.creation-sub.($label);
    }

    has $!toggled_supply;
    method toggled() {
        $!toggled_supply //= do {
            my $s = Supplier.new;
            g_signal_connect_wd($!gtk_widget, "toggled",
                -> $, $ {
                    $s.emit(self);
                    CATCH { default { note $_; } }
                }, OpaquePointer, 0);
            $s.Supply;
        }
    }

    method status()
        returns Bool 
        is gtk-property(&gtk_toggle_button_get_active, &gtk_toggle_button_set_active) 
        { * }
}

class GTK::Simple::CheckButton is GTK::Simple::ToggleButton {
    sub gtk_check_button_new_with_label(Str $label)
        is native(&gtk-lib)
        returns GtkWidget
        {*}

    method creation-sub {
        &gtk_check_button_new_with_label
    }
}

class GTK::Simple::Switch is GTK::Simple::ToggleButton {
    sub gtk_switch_new()
        is native(&gtk-lib)
        returns GtkWidget
        {*}

    sub gtk_switch_get_active(GtkWidget $w)
        returns int32
        is native(&gtk-lib)
        {*}

    sub gtk_switch_set_active(GtkWidget $w, int32 $a)
        is native(&gtk-lib)
        {*}

    method creation-sub {
        sub ($) {
            gtk_switch_new()
        }
    }

    method status()
        returns Bool
        is gtk-property(&gtk_switch_get_active, &gtk_switch_set_active)
        { * }
}

class GTK::Simple::DrawingArea does GTK::Simple::Widget {
    sub gtk_drawing_area_new()
        is native(&gtk-lib)
        returns GtkWidget
        {*}

    submethod BUILD() {
        $!gtk_widget = gtk_drawing_area_new();
    }

    method add-draw-handler(&handler) {
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
        DEPRECATED('add-draw-handler');
        self.add-draw-handler(&handler);
    }
}

class GTK::Simple::StatusBar does GTK::Simple::Widget does GTK::Simple::Box {
    sub gtk_statusbar_new()
        is native(&gtk-lib)
        returns GtkWidget
        { * }


    submethod BUILD() {
        $!gtk_widget = gtk_statusbar_new();
    }

    sub gtk_statusbar_get_context_id(GtkWidget $widget, Str $description)
        is native(&gtk-lib)
        returns uint32
        { * }

    method get-context-id(Str $description) returns Int {
        gtk_statusbar_get_context_id($!gtk_widget, $description);
    }

    sub gtk_statusbar_push(GtkWidget $widget, uint32 $context_id, Str $text)
        is native(&gtk-lib)
        returns uint32
        { * }

    method push-status(Int $context-id, Str $text) returns Int {
        gtk_statusbar_push($!gtk_widget, $context-id, $text);
    }

    sub gtk_statusbar_pop(GtkWidget $widget, uint32 $context-id)
        is native(&gtk-lib)
        { * }

    method pop-status(Int $context-id) {
        gtk_statusbar_pop($!gtk_widget, $context-id);
    }

    sub gtk_statusbar_remove(GtkWidget $widget, uint32 $context-id, uint32 $message-id)
        is native(&gtk-lib)
        { * }

    method remove-status(Int $context-id, Int $message-id) {
        gtk_statusbar_remove($!gtk_widget, $context-id, $message-id);
    }

    sub gtk_statusbar_remove_all(GtkWidget $widget, uint32 $context-id)
        is native(&gtk-lib)
        { * }

    method remove-status-all(Int $context-id) {
        gtk_statusbar_remove_all($!gtk_widget, $context-id);
    }
}

class GTK::Simple::Separator does GTK::Simple::Widget {

    sub gtk_separator_new(int32 $orientation)
        is native(&gtk-lib)
        returns GtkWidget
        { * }

    submethod BUILD(:$orientation = 'horizontal') {
        my $d = $orientation eq 'vertical' ?? 1 !! 0;
        $!gtk_widget = gtk_separator_new($d);
    }
}

class GTK::Simple::ProgressBar does GTK::Simple::Widget {

    sub gtk_progress_bar_new()
        is native(&gtk-lib)
        returns GtkWidget
        { * }

    submethod BUILD() {
        $!gtk_widget = gtk_progress_bar_new();
    }

    sub gtk_progress_bar_pulse(GtkWidget $widget)
        is native(&gtk-lib)
        { * }

    method pulse() {
        gtk_progress_bar_pulse($!gtk_widget);
    }

    sub gtk_progress_bar_set_fraction(GtkWidget $widget, num64 $fractions)
        is native(&gtk-lib)
        { * }

    sub gtk_progress_bar_get_fraction(GtkWidget $widget)
        is native(&gtk-lib)
        returns num64
        { * }


    method fraction() 
        returns Rat
        is gtk-property(&gtk_progress_bar_get_fraction, &gtk_progress_bar_set_fraction, -> $, $val { Num($val) })
        { * }
}

class GTK::Simple::Frame does GTK::Simple::Widget does GTK::Simple::Container {
    sub gtk_frame_new(Str $label)
        is native(&gtk-lib)
        returns GtkWidget
        { * }

    submethod BUILD(Str :$label) {
        $!gtk_widget = gtk_frame_new($label);
    }

    sub gtk_frame_get_label(GtkWidget $widget)
        is native(&gtk-lib)
        returns Str
        { * }

    sub gtk_frame_set_label(GtkWidget $widget, Str $label)
        is native(&gtk-lib)
        { * }

    method label() 
        returns Str 
        is gtk-property(&gtk_frame_get_label, &gtk_frame_set_label)
        { * }
}

# This is actually a container but most of the interface
# isn't necessary
class GTK::Simple::ComboBoxText does GTK::Simple::Widget {
    sub gtk_combo_box_text_new()
        is native(&gtk-lib)
        returns GtkWidget
        { * }

    sub gtk_combo_box_text_new_with_entry()
        is native(&gtk-lib)
        returns GtkWidget
        { * }

    submethod BUILD(Bool :$entry = False) {
        $!gtk_widget = do {
            if $entry {
                gtk_combo_box_text_new_with_entry()
            }
            else {
                gtk_combo_box_text_new()
            }
        }
    }

    sub gtk_combo_box_text_append_text(GtkWidget $widget, Str $text)
        is native(&gtk-lib)
        { * }

    method append-text(Str $text) {
        gtk_combo_box_text_append_text($!gtk_widget, $text);
    }

    sub gtk_combo_box_text_prepend_text(GtkWidget $widget, Str $text)
        is native(&gtk-lib)
        { * }

    method prepend-text(Str $text) {
        gtk_combo_box_text_prepend_text($!gtk_widget, $text);
    }

    sub gtk_combo_box_text_insert_text(GtkWidget $widget, int32 $position, Str $text)
        is native(&gtk-lib)
        { * }

    method insert-text(Int $position, Str $text) {
        gtk_combo_box_text_insert_text($!gtk_widget, $position, $text);
    }

    sub gtk_combo_box_text_remove(GtkWidget $widget, int32 $position)
        is native(&gtk-lib)
        { * }

    method remove(Int $position) {
        gtk_combo_box_text_remove($!gtk_widget, $position);
    }

    sub gtk_combo_box_text_remove_all(GtkWidget $widget)
        is native(&gtk-lib)
        { * }

    method remove-all() {
        gtk_combo_box_text_remove_all($!gtk_widget)
    }

    sub gtk_combo_box_text_get_active_text(GtkWidget $widget)
        is native(&gtk-lib)
        returns Str
        { * }

    method active-text() returns Str {
        gtk_combo_box_text_get_active_text($!gtk_widget);
    }

    has $!changed_supply;
    method changed() {
        $!changed_supply //= do {
            my $s = Supplier.new;
            g_signal_connect_wd($!gtk_widget, "changed",
                -> $, $ {
                    $s.emit(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s.Supply;
        }
    }
}

class GtkBuilder is repr('CPointer') { }
class GObject is repr('CPointer') { }

class GTK::Simple::GladeApp {

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
        g_signal_connect_wd($!main-window, "delete-event", -> $, $ { gtk_main_quit(); }, OpaquePointer, 0);
    }

    method run() {
        gtk_widget_show($!main-window);
        gtk_main();
    }
}

# vi: foldmethod=marker
