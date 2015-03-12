my Str $gtklib;
my Str $gobjectlib;
my Str $gliblib;
BEGIN {
    if $*VM.config<dll> ~~ /dll/ {
        $gtklib = 'libgtk-3-0';
        $gobjectlib = 'libgobject-2.0-0';
        $gliblib = 'libglib-2.0-0';
    } else {
        $gtklib = 'libgtk-3';
        $gobjectlib = 'libgobject-2.0';
        $gliblib = 'libglib-2.0';
    }
}
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
    is native($gtklib)
    {*}

sub gtk_widget_destroy(GtkWidget $widget)
    is native($gtklib)
    {*}

sub gtk_widget_set_sensitive(GtkWidget $widget, int $sensitive)
    is native($gtklib)
    {*}

sub gtk_widget_get_sensitive(GtkWidget $widget)
    returns int
    is native($gtklib)
    {*}

sub gtk_widget_set_size_request(GtkWidget $widget, int $w, int $h)
    is native($gtklib)
    {*}

sub gtk_widget_get_allocated_height(GtkWidget $widget)
    returns int
    is native($gtklib)
    {*}

sub gtk_widget_get_allocated_width(GtkWidget $widget)
    returns int
    is native($gtklib)
    {*}

sub gtk_widget_queue_draw(GtkWidget $widget)
    is native($gtklib)
    {*}

# gtk_widget_ ... }}}

# gtk_container_... {{{
sub gtk_container_add(GtkWidget $container, GtkWidget $widgen)
    is native($gtklib)
    {*}

sub gtk_container_get_border_width(GtkWidget $container)
    returns int
    is native($gtklib)
    {*}

sub gtk_container_set_border_width(GtkWidget $container, int $border_width)
    is native($gtklib)
    {*}

# gtk_container_... }}}

# g_signal... {{{

sub g_signal_connect_wd(GtkWidget $widget, Str $signal,
    &Handler (GtkWidget $h_widget, OpaquePointer $h_data),
    OpaquePointer $data, int32 $connect_flags)
    returns int
    is native($gobjectlib)
    is symbol('g_signal_connect_object')
    { * }

sub g_signal_handler_disconnect(GtkWidget $widget, int $handler_id)
    is native($gobjectlib)
    { * }

# g_signal... }}}

sub g_idle_add(
        &Handler (OpaquePointer $h_data),
        OpaquePointer $data)
    is native($gliblib)
    returns int32
    {*}

sub g_timeout_add(int32 $interval, &Handler (OpaquePointer $h_data, --> int), OpaquePointer $data)
    is native($gtklib)
    returns int32
    {*}

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

    method sensitive() {
        Proxy.new:
            FETCH => { gtk_widget_get_sensitive($!gtk_widget) ?? True !! False },
            STORE => -> \c, \value {
                gtk_widget_set_sensitive($!gtk_widget, value.Int)
            }
    }

    method events {
        my $window = self.WINDOW;
        class GdkEventMaskWrapper {
            method set(*@events) {
                my $mask = gdk_window_get_events($window);
                $mask +|= [+|] @events;
                gdk_window_set_events($window, $mask)
            }
            method get {
                my int $mask = gdk_window_get_events($window);
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

    method signal_supply(Str $name) {
        my $s = Supply.new;
        g_signal_connect_wd($!gtk_widget, $name,
            -> $widget, $event {
                $s.emit(($widget, $event));
                CATCH { default { note "in signal supply for $name:"; note $_; } }
            },
            OpaquePointer, 0);
        $s
    }

    method size_request(Cool $width, Cool $height) {
        gtk_widget_set_size_request($!gtk_widget, $width.Int, $height.Int);
    }

    method width() {
        gtk_widget_get_allocated_width($!gtk_widget);
    }
    method height() {
        gtk_widget_get_allocated_height($!gtk_widget);
    }

    method queue_draw() {
        gtk_widget_queue_draw($!gtk_widget);
    }

    method destroy() {
        gtk_widget_destroy($!gtk_widget);
    }
}

role GTK::Simple::Container {
    method set_content($widget) {
        gtk_container_add(self.WIDGET, $widget.WIDGET);
        gtk_widget_show($widget.WIDGET);
    }

    method border_width {
        Proxy.new:
            FETCH => { gtk_container_get_border_width(self.WIDGET) },
            STORE => -> \c, Cool $w { gtk_container_set_border_width(self.WIDGET, $w.Int) }
    }
}

class GTK::Simple::Scheduler does Scheduler {
    my class Queue is repr('ConcBlockingQueue') { }
    my $queue := nqp::create(Queue);

    my &idle_cb = sub ($a) { GTK::Simple::Scheduler.process_queue; return 0 };

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

    method process_queue() {
        my Mu $task := nqp::queuepoll($queue);
        unless nqp::isnull($task) {
            if nqp::islist($task) {
                my Mu $code := nqp::shift($task);
                $code(|nqp::p6parcel($task, Any));
            }
            else {
                $task();
            }
        }
    }

    method loads() { nqp::elems($queue) }
}

class GTK::Simple::Window does GTK::Simple::Widget
                       does GTK::Simple::Container {
    sub gtk_window_new(int32 $window_type)
        is native($gtklib)
        returns GtkWidget
        {*}

    sub gtk_window_set_title(GtkWidget $w, Str $title)
        is native($gtklib)
        returns GtkWidget
        {*}

    submethod BUILD(Cool :$title = "Gtk Window") {
        $!gtk_widget = gtk_window_new(0);
        gtk_window_set_title($!gtk_widget, $title.Str);
    }

    has $!deleted_supply;
    #| Tap this supply to react to the window being closed
    method deleted() {
        $!deleted_supply //= do {
            my $s = Supply.new;
            g_signal_connect_wd($!gtk_widget, "delete-event",
                -> $, $ {
                    $s.emit(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s
        }
    }

    method show() {
        gtk_widget_show($!gtk_widget);
    }
}

class GTK::Simple::App does GTK::Simple::Widget
                       does GTK::Simple::Container {
    sub gtk_init(CArray[int32] $argc, CArray[CArray[Str]] $argv)
        is native($gtklib)
        {*}

    sub gtk_window_new(int32 $window_type)
        is native($gtklib)
        returns GtkWidget
        {*}

    sub gtk_main()
        is native($gtklib)
        {*}

    sub gtk_main_quit()
        is native($gtklib)
        {*}

    submethod BUILD(:$title = 'Application', Bool :$exit_on_close = True) {
        my $arg_arr = CArray[Str].new;
        $arg_arr[0] = $title.Str;
        my $argc = CArray[int32].new;
        $argc[0] = 1;
        my $argv = CArray[CArray[Str]].new;
        $argv[0] = $arg_arr;
        gtk_init($argc, $argv);

        $!gtk_widget = gtk_window_new(0);

        if $exit_on_close {
            g_signal_connect_wd($!gtk_widget, "delete-event",
              -> $, $ {
                  self.exit
              }, OpaquePointer, 0);
        }
    }

    method exit() {
        gtk_main_quit();
    }

    has $!deleted_supply;
    #| Tap this supply to react to the window being closed
    method deleted() {
        $!deleted_supply //= do {
            my $s = Supply.new;
            g_signal_connect_wd($!gtk_widget, "delete-event",
                -> $, $ {
                    $s.emit(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s
        }
    }

    method run() {
        gtk_widget_show($!gtk_widget);
        gtk_main();
    }

    method g_timeout(Cool $usecs) {
        my $s = Supply.new;
        my $starttime = nqp::time_n();
        my $lasttime  = nqp::time_n();
        g_timeout_add($usecs.Int,
            sub (*@) {
                my $dt = nqp::time_n() - $lasttime;
                $lasttime = nqp::time_n();
                $s.emit((nqp::time_n() - $starttime, $dt));

                return 1;
            }, OpaquePointer);
        return $s;
    }
}

role GTK::Simple::Box {
    sub gtk_box_pack_start(GtkWidget, GtkWidget, int32, int32, int32)
        is native($gtklib)
        {*}

    multi method new(*@packees) {
        my $box = self.bless();
        $box.pack_start($_) for @packees;
        $box
    }

    method pack_start($widget) {
        gtk_box_pack_start(self.WIDGET, $widget.WIDGET, 1, 1, 0);
        gtk_widget_show($widget.WIDGET);
    }
}

class GTK::Simple::HBox does GTK::Simple::Widget does GTK::Simple::Box {
    sub gtk_hbox_new(int32, int32)
        is native($gtklib)
        returns GtkWidget
        {*}

    submethod BUILD() {
        $!gtk_widget = gtk_hbox_new(0, 0);
    }
}

class GTK::Simple::VBox does GTK::Simple::Widget does GTK::Simple::Box {
    sub gtk_vbox_new(int32, int32)
        is native($gtklib)
        returns GtkWidget
        {*}

    submethod BUILD() {
        $!gtk_widget = gtk_vbox_new(0, 0);
    }
}

class GTK::Simple::Grid does GTK::Simple::Widget {
    sub gtk_grid_new()
        is native($gtklib)
        returns GtkWidget
        {*}

    sub gtk_grid_attach(GtkWidget $grid, GtkWidget $child, int $x, int $y, int $w, int $h)
        is native($gtklib)
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
        is native($gtklib)
        returns GtkWidget
        {*}

    sub gtk_label_get_text(GtkWidget $label)
        is native($gtklib)
        returns Str
        {*}

    sub gtk_label_set_text(GtkWidget $label, Str $text)
        is native($gtklib)
        {*}

    submethod BUILD(:$text = '') {
        $!gtk_widget = gtk_label_new($text);
    }

    method text() {
        Proxy.new:
            FETCH => { gtk_label_get_text($!gtk_widget) },
            STORE => -> \c, \text {
                gtk_label_set_text($!gtk_widget, text.Str);
            }
    }
}

class GTK::Simple::Entry does GTK::Simple::Widget {
    sub gtk_entry_new()
        is native($gtklib)
        returns GtkWidget
        {*}

    sub gtk_entry_get_text(GtkWidget $entry)
        is native($gtklib)
        returns Str
        {*}

    sub gtk_entry_set_text(GtkWidget $entry, Str $text)
        is native($gtklib)
        {*}

    submethod BUILD() {
        $!gtk_widget = gtk_entry_new();
    }

    method text() {
        Proxy.new:
            FETCH => { gtk_entry_get_text($!gtk_widget) },
            STORE => -> \c, \text {
                gtk_entry_set_text($!gtk_widget, text.Str);
            }
    }

    has $!changed_supply;
    method changed() {
        $!changed_supply //= do {
            my $s = Supply.new;
            g_signal_connect_wd($!gtk_widget, "changed",
                -> $, $ {
                    $s.emit(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s
        }
    }
}

class GTK::Simple::TextView does GTK::Simple::Widget {
    sub gtk_text_view_new()
        is native($gtklib)
        returns GtkWidget
        {*}

    our sub gtk_text_view_get_buffer(GtkWidget $view)
        is native($gtklib)
        returns OpaquePointer
        {*}

    our sub gtk_text_buffer_get_text(OpaquePointer $buffer, CArray[int] $start,
            CArray[int] $end, int32 $show_hidden)
        is native($gtklib)
        returns Str
        {*}

    our sub gtk_text_buffer_get_start_iter(OpaquePointer $buffer, CArray[int] $i)
        is native($gtklib)
        {*}

    our sub gtk_text_buffer_get_end_iter(OpaquePointer $buffer, CArray[int] $i)
        is native($gtklib)
        {*}

    our sub gtk_text_buffer_set_text(OpaquePointer $buffer, Str $text, int32 $len)
        is native($gtklib)
        {*}

    has $!buffer;

    submethod BUILD() {
        $!gtk_widget = gtk_text_view_new();
        $!buffer = gtk_text_view_get_buffer($!gtk_widget);
    }


    method text() {
        Proxy.new:
            FETCH => {
                gtk_text_buffer_get_text($!buffer, self!start_iter(),
                    self!end_iter(), 1)
            },
            STORE => -> \c, \text {
                gtk_text_buffer_set_text($!buffer, text.Str, -1);
            }
    }

    method !start_iter() {
        my $iter_mem = CArray[int].new;
        $iter_mem[31] = 0; # Just need a blob of memory.
        gtk_text_buffer_get_start_iter($!buffer, $iter_mem);
        $iter_mem
    }

    method !end_iter() {
        my $iter_mem = CArray[int].new;
        $iter_mem[16] = 0;
        gtk_text_buffer_get_end_iter($!buffer, $iter_mem);
        $iter_mem
    }

    has $!changed_supply;
    method changed() {
        $!changed_supply //= do {
            my $s = Supply.new;
            g_signal_connect_wd(
                $!buffer, "changed",
                -> $, $ {
                    $s.emit(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s
        }
    }
}

class GTK::Simple::Button does GTK::Simple::Widget {
    sub gtk_button_new_with_label(Str $label)
        is native($gtklib)
        returns GtkWidget
        {*}

    submethod BUILD(:$label!) {
        $!gtk_widget = gtk_button_new_with_label($label);
    }

    has $!clicked_supply;
    method clicked() {
        $!clicked_supply //= do {
            my $s = Supply.new;
            g_signal_connect_wd($!gtk_widget, "clicked",
                -> $, $ {
                    $s.emit(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s
        }
    }
}


class GTK::Simple::ToggleButton does GTK::Simple::Widget {
    sub gtk_toggle_button_new_with_label(Str $label)
        is native($gtklib)
        returns GtkWidget
        {*}

    sub gtk_toggle_button_get_active(GtkWidget $w)
        is native($gtklib)
        returns int
        {*}

    sub gtk_toggle_button_set_active(GtkWidget $w, int $active)
        is native($gtklib)
        returns int
        {*}

    method creation_sub {
        &gtk_toggle_button_new_with_label
    }

    submethod BUILD(:$label!) {
        $!gtk_widget = self.creation_sub.($label);
    }

    has $!toggled_supply;
    method toggled() {
        $!toggled_supply //= do {
            my $s = Supply.new;
            g_signal_connect_wd($!gtk_widget, "toggled",
                -> $, $ {
                    $s.emit(self);
                    CATCH { default { note $_; } }
                }, OpaquePointer, 0);
            $s
        }
    }

    method status() {
        Proxy.new:
            FETCH =>          { gtk_toggle_button_get_active($!gtk_widget) ?? True !! False },
            STORE => -> $, $v { gtk_toggle_button_set_active($!gtk_widget, (so $v).Int) };
    }
}

class GTK::Simple::CheckButton is GTK::Simple::ToggleButton {
    sub gtk_check_button_new_with_label(Str $label)
        is native($gtklib)
        returns GtkWidget
        {*}

    method creation_sub {
        &gtk_check_button_new_with_label
    }
}

class GTK::Simple::Switch is GTK::Simple::ToggleButton {
    sub gtk_switch_new()
        is native($gtklib)
        returns GtkWidget
        {*}

    sub gtk_switch_get_active(GtkWidget $w)
        returns int
        is native($gtklib)
        {*}

    sub gtk_switch_set_active(GtkWidget $w, int $a)
        is native($gtklib)
        {*}

    method creation_sub {
        &gtk_switch_new
    }

    method status() {
        Proxy.new:
            FETCH =>          { gtk_switch_get_active(self.WIDGET) ?? True !! False },
            STORE => -> $, $v { gtk_switch_set_active(self.WIDGET, (so $v).Int) };
    }
}

class GTK::Simple::DrawingArea does GTK::Simple::Widget {
    sub gtk_drawing_area_new()
        is native($gtklib)
        returns GtkWidget
        {*}

    submethod BUILD() {
        $!gtk_widget = gtk_drawing_area_new();
    }

    method add_draw_handler(&handler) {
        my sub handler_wrapper($widget, $cairop) {
            my $cairo  = nqp::box_i($cairop.Int, $cairo_t);
            my $ctx    = $Cairo_Context.new($cairo);
            handler(self, $ctx);
        }
        GTK::Simple::ConnectionHandler.new(
            :instance($!gtk_widget),
            :handler(g_signal_connect_wd($!gtk_widget, "draw", &handler_wrapper, OpaquePointer, 0)));
    }
}

# vi: foldmethod=marker
