use NativeCall;

my class GtkWidget is repr('CPointer') { }

# gtk_widget_... {{{

sub gtk_widget_show(GtkWidget $widgetw)
    is native('libgtk-3.so.0')
    {*}

sub gtk_widget_destroy(GtkWidget $widget)
    is native('libgtk-3.so.0')
    {*}

sub gtk_widget_set_sensitive(GtkWidget $widget, int $sensitive)
    is native('libgtk-3.so.0')
    {*}

sub gtk_widget_get_sensitive(GtkWidget $widget) returns int
    is native('libgtk-3.so.0')
    {*}

sub gtk_widget_set_size_request(GtkWidget $widget, int $w, int $h)
    is native('libgtk-3.so.0')
    {*}

sub gtk_widget_get_allocated_height(GtkWidget $widget)
    returns int
    is native('libgtk-3.so.0')
    {*}

sub gtk_widget_get_allocated_width(GtkWidget $widget)
    returns int
    is native('libgtk-3.so.0')
    {*}

# gtk_widget_ ... }}}

# gtk_container_... {{{
sub gtk_container_add(GtkWidget $container, GtkWidget $widgen)
    is native('libgtk-3.so.0')
    {*}

sub gtk_container_get_border_width(GtkWidget $container)
    returns int
    is native('libgtk-3.so.0')
    {*}

sub gtk_container_set_border_width(GtkWidget $container, int $border_width)
    is native('libgtk-3.so.0')
    {*}

# gtk_container_... }}}

# g_signal... {{{

sub g_signal_connect_wd(GtkWidget $widget, Str $signal,
    &Handler (GtkWidget $h_widget, OpaquePointer $h_data),
    OpaquePointer $data, int32 $connect_flags)
    returns int
    is native('libgobject-2.0.so')
    is symbol('g_signal_connect_object')
    { * }

# g_signal... }}}

sub g_idle_add(
        &Handler(OpaquePointer $h_data),
        OpaquePointer $data)
    is native('libgtk-3.so.0')
    returns int32
    {*}

role GTK::Simple::Widget {
    has $!gtk_widget;

    method WIDGET() {
        $!gtk_widget
    }

    method sensitive() {
        Proxy.new:
            FETCH => { gtk_widget_get_sensitive($!gtk_widget) ?? True !! False },
            STORE => -> \c, \value {
                gtk_widget_set_sensitive($!gtk_widget, value.Int)
            }
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

    method cue(&code, :$at, :$in, :$every, :$times, :&catch ) {
        die "GTK::Simple::Scheduler does not support at" if $at;
        die "GTK::Simple::Scheduler does not support in" if $in;
        die "GTK::Simple::Scheduler does not support every" if $every;
        die "GTK::Simple::Scheduler does not support times" if $times;
        my &run := &catch
            ?? -> { code(); CATCH { default { catch($_) } } }
            !! &code;
        nqp::push($queue, &run);
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

class GTK::Simple::App does GTK::Simple::Widget
                       does GTK::Simple::Container {
    sub gtk_init(CArray[int32] $argc, CArray[CArray[Str]] $argv)
        is native('libgtk-3.so.0')
        {*}

    sub gtk_window_new(int32 $window_type)
        is native('libgtk-3.so.0')
        returns GtkWidget
        {*}

    sub gtk_main()
        is native('libgtk-3.so.0')
        {*}

    sub gtk_main_quit()
        is native('libgtk-3.so.0')
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
                    $s.more(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s
        }
    }

    method run() {
        gtk_widget_show($!gtk_widget);
        g_idle_add(
            { GTK::Simple::Scheduler.process_queue },
            OpaquePointer);
        gtk_main();
    }
}

role GTK::Simple::Box {
    sub gtk_box_pack_start(GtkWidget, GtkWidget, int32, int32, int32)
        is native('libgtk-3.so.0')
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
        is native('libgtk-3.so.0')
        returns GtkWidget
        {*}

    submethod BUILD() {
        $!gtk_widget = gtk_hbox_new(0, 0);
    }
}

class GTK::Simple::VBox does GTK::Simple::Widget does GTK::Simple::Box {
    sub gtk_vbox_new(int32, int32)
        is native('libgtk-3.so.0')
        returns GtkWidget
        {*}

    submethod BUILD() {
        $!gtk_widget = gtk_vbox_new(0, 0);
    }
}

class GTK::Simple::Grid does GTK::Simple::Widget {
    sub gtk_grid_new()
        is native('libgtk-3.so.0')
        returns GtkWidget
        {*}

    sub gtk_grid_attach(GtkWidget $grid, GtkWidget $child, int $x, int $y, int $w, int $h)
        is native('libgtk-3.so.0')
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
        is native('libgtk-3.so.0')
        returns GtkWidget
        {*}

    sub gtk_label_get_text(GtkWidget $label)
        is native('libgtk-3.so.0')
        returns Str
        {*}

    sub gtk_label_set_text(GtkWidget $label, Str $text)
        is native('libgtk-3.so.0')
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
        is native('libgtk-3.so.0')
        returns GtkWidget
        {*}

    sub gtk_entry_get_text(GtkWidget $entry)
        is native('libgtk-3.so.0')
        returns Str
        {*}

    sub gtk_entry_set_text(GtkWidget $entry, Str $text)
        is native('libgtk-3.so.0')
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
                    $s.more(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s
        }
    }
}

class GTK::Simple::TextView does GTK::Simple::Widget {
    sub gtk_text_view_new()
        is native('libgtk-3.so.0')
        returns GtkWidget
        {*}

    sub gtk_text_view_get_buffer(GtkWidget $view)
        is native('libgtk-3.so.0')
        returns OpaquePointer
        {*}

    sub gtk_text_buffer_get_text(OpaquePointer $buffer, CArray[int] $start,
            CArray[int] $end, int32 $show_hidden)
        is native('libgtk-3.so.0')
        returns Str
        {*}

    sub gtk_text_buffer_get_start_iter(OpaquePointer $buffer, CArray[int] $i)
        is native('libgtk-3.so.0')
        {*}

    sub gtk_text_buffer_get_end_iter(OpaquePointer $buffer, CArray[int] $i)
        is native('libgtk-3.so.0')
        {*}

    sub gtk_text_buffer_set_text(OpaquePointer $buffer, Str $text, int32 $len)
        is native('libgtk-3.so.0')
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
                    $s.more(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s
        }
    }
}

class GTK::Simple::Button does GTK::Simple::Widget {
    sub gtk_button_new_with_label(Str $label)
        is native('libgtk-3.so.0')
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
                    $s.more(self);
                    CATCH { default { note $_; } }
                },
                OpaquePointer, 0);
            $s
        }
    }
}


class GTK::Simple::ToggleButton does GTK::Simple::Widget {
    sub gtk_toggle_button_new_with_label(Str $label)
        is native('libgtk-3.so.0')
        returns GtkWidget
        {*}

    sub gtk_toggle_button_get_active(GtkWidget $w)
        is native('libgtk-3.so.0')
        returns int
        {*}

    sub gtk_toggle_button_set_active(GtkWidget $w, int $active)
        is native('libgtk-3.so.0')
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
                    $s.more(self);
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
        is native('libgtk-3.so.0')
        returns GtkWidget
        {*}

    method creation_sub {
        &gtk_check_button_new_with_label
    }
}

class GTK::Simple::Switch is GTK::Simple::ToggleButton {
    sub gtk_switch_new()
        is native('libgtk-3.so.0')
        returns GtkWidget
        {*}

    sub gtk_switch_get_active(GtkWidget $w)
        returns int
        is native('libgtk-3.so.0')
        {*}

    sub gtk_switch_set_active(GtkWidget $w, int $a)
        is native('libgtk-3.so.0')
        {*}

    method creation_sub {
        &gtk_switch_new
    }

    method status() {
        Proxy.new:
            FETCH =>          { gtk_switch_get_active($!gtk_widget) ?? True !! False },
            STORE => -> $, $v { gtk_switch_set_active($!gtk_widget, (so $v).Int) };
    }
}

# vi: foldmethod=marker
