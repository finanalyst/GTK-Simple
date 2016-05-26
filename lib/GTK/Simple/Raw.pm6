
use v6;

use GTK::NativeLib;
use NativeCall;

unit module GTK::Simple::Raw;

class GtkWidget is repr('CPointer') is export { }

# gtk_widget_... {{{

sub gtk_widget_show(GtkWidget $widgetw)
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_hide(GtkWidget $widgetw)
    is native(&gtk-lib)
    is export    
    { * }

sub gtk_widget_show_all(GtkWidget $widgetw)
    is native(&gtk-lib)
    is export
    { * }

sub gtk_widget_set_no_show_all(GtkWidget $widgetw, int32 $no_show_all)
    is native(&gtk-lib)
    is export
    { * }

sub gtk_widget_get_no_show_all(GtkWidget $widgetw) 
    returns int32
    is native(&gtk-lib)
    is export
    { * }

sub gtk_widget_destroy(GtkWidget $widget)
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_set_sensitive(GtkWidget $widget, int32 $sensitive)
    is native(&gtk-lib)
    is export

    {*}
sub gtk_widget_get_sensitive(GtkWidget $widget)
    returns int32
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_set_size_request(GtkWidget $widget, int32 $w, int32 $h)
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_get_allocated_height(GtkWidget $widget)
    returns int32
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_get_allocated_width(GtkWidget $widget)
    returns int32
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_queue_draw(GtkWidget $widget)
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_get_tooltip_text(GtkWidget $widget)
    is native(&gtk-lib)
    is export
    returns Str
    { * }

sub gtk_widget_set_tooltip_text(GtkWidget $widget, Str $text)
    is native(&gtk-lib)
    is export
    { * }

sub gtk_window_new(int32 $window_type)
    is native(&gtk-lib)
    is export
    returns GtkWidget
    {*}

sub gtk_window_set_title(GtkWidget $w, Str $title)
    is native(&gtk-lib)
    is export
    returns GtkWidget
    {*}

# gtk_widget_ ... }}}

# gtk_container_... {{{
sub gtk_container_add(GtkWidget $container, GtkWidget $widgen)
    is native(&gtk-lib)
    is export
    {*}

sub gtk_container_get_border_width(GtkWidget $container)
    returns int32
    is native(&gtk-lib)
    is export
    {*}

sub gtk_container_set_border_width(GtkWidget $container, int32 $border_width)
    is native(&gtk-lib)
    is export
    {*}

# gtk_container_... }}}

# g_signal... {{{

sub g_signal_connect_wd(GtkWidget $widget, Str $signal,
    &Handler (GtkWidget $h_widget, OpaquePointer $h_data),
    OpaquePointer $data, int32 $connect_flags)
    returns int32
    is native(&gobject-lib)
    is symbol('g_signal_connect_object')
    is export
    { * }

sub g_signal_handler_disconnect(GtkWidget $widget, int32 $handler_id)
    is native(&gobject-lib)
    is export
    { * }

# g_signal... }}}

sub g_idle_add(
        &Handler (OpaquePointer $h_data),
        OpaquePointer $data)
    is native(&glib-lib)
    is export
    returns int32
    {*}

sub g_timeout_add(int32 $interval, &Handler (OpaquePointer $h_data, --> int32), OpaquePointer $data)
    is native(&gtk-lib)
    is export
    returns int32
    {*}
