use v6;

use NativeCall;
use GTK::Simple::Raw :file-chooser, :DEFAULT;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::FileChooserButton does GTK::Simple::Widget;

has $!file-set-supply;

submethod BUILD(:$title = '', GtkFileChooserAction :$action = GTK_FILE_CHOOSER_ACTION_OPEN) {
    $!gtk_widget = gtk_file_chooser_button_new($title, $action);
}

method title() 
    returns Str
    is gtk-property(
        &gtk_file_chooser_button_get_title,
        &gtk_file_chooser_button_set_title
    )
    { * }

method width-chars() 
    returns Str
    is gtk-property(
        &gtk_file_chooser_button_get_width_chars,
        &gtk_file_chooser_button_set_width_chars
    )
    { * }

#TODO move this to FileChooser parent class
method file-name() 
    returns Str
    is gtk-property(
        &gtk_file_chooser_get_filename,
        &gtk_file_chooser_set_filename
    )
    { * }

method select-multiple()
    returns Bool
    is gtk-property(
        &gtk_file_chooser_get_select_multiple,
        &gtk_file_chooser_set_select_multiple
    )
    { * }

method file-names()
    returns Array
    {
    my Pointer $p = gtk_file_chooser_get_filenames( self.WIDGET );
    my $n = g_slist_length($p);
    my @fns;
    for ^$n {
        @fns.append: g_slist_nth_data( $p, $n );
    }
    g_slist_free( $p );
    @fns
}

method file-set() {
    $!file-set-supply //= do {
        my $s = Supplier.new;
        g_signal_connect_wd($!gtk_widget, "file-set",
            -> $, $ {
                $s.emit(self);
                CATCH { default { note $_; } }
            },
            OpaquePointer, 0);
        $s.Supply;
    }
}
