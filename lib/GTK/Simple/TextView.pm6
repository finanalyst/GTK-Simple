
use NativeCall;
use GTK::Simple::Raw :text-view, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::TextView does GTK::Simple::Widget;

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

method editable() 
    returns Bool
    is gtk-property(&gtk_text_view_get_editable, &gtk_text_view_set_editable)
    { * }

method cursor-visible() 
    returns Bool
    is gtk-property(&gtk_text_view_get_cursor_visible, &gtk_text_view_set_cursor_visible)
    { * }

method monospace()
    returns Bool
    is gtk-property(&gtk_text_view_get_monospace, &gtk_text_view_set_monospace)
    { * }
