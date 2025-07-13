use v6.d;

use GTK::Simple::Raw :image;
use GTK::Simple::GDK;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Image does GTK::Simple::Widget;

submethod BUILD(Str :$path, Int :$width = 800, Int :$height = 600) {
#    die "Image file '$path' does not exist or could not be accessed" unless $path.IO.e;
#    note "Attempting to load image file {$path.IO.absolute} (exists? {$path.IO.e}";
    my $pixbuf = gdk_pixbuf_new_from_file_at_size($path.IO.absolute, $width, $height, my GError $err);
    $!gtk_widget = gtk_image_new_from_pixbuf($pixbuf);
}