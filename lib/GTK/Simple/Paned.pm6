use v6;

use NativeCall;
use GTK::Simple::Raw :paned;
use GTK::Simple::Common;
use GTK::Simple::Widget;

unit class GTK::Simple::Paned does GTK::Simple::Widget;

submethod BUILD(:$orientation = 0) {
    self.WIDGET( gtk_paned_new( $orientation ) );
}
# submethod BUILD( :$orientation where { $orientation eq one('horizontal', 'vertical') } = 'horizontal') {
#     self.WIDGET( gtk_paned_new( $orientation eq 'horizontal' ?? 0 !! 1 ) );
# }

method add1( GTK::Simple::Widget $child ) {
    gtk_paned_add1(self.WIDGET, $child.WIDGET );
#     gtk_paned_set_position( self.WIDGET );
}

method add2( GTK::Simple::Widget $child ) {
    gtk_paned_add2(self.WIDGET, $child.WIDGET );
#     gtk_paned_set_position( self.WIDGET );
}

method pack1( GTK::Simple::Widget $child, Bool :$resize = True, Bool :$shrink = True ) {
    gtk_paned_pack1(self.WIDGET, $child.WIDGET, $resize, $shrink );
}

method pack2( GTK::Simple::Widget $child, Bool :$resize = True, Bool :$shrink = True ) {
    gtk_paned_pack2(self.WIDGET, $child.WIDGET, $resize, $shrink );
}

method set-contents( 
    GTK::Simple::Widget :$a!, GTK::Simple::Widget :$b!,
    Bool :$shrink-a = True, Bool :$resize-a = True, 
    Bool :$shrink-b = True, Bool :$resize-b = True) {
        gtk_paned_pack1(self.WIDGET, $a.WIDGET, $resize-a, $shrink-a );
	gtk_paned_pack2(self.WIDGET, $b.WIDGET, $resize-b, $shrink-b );
}
method set-position( int $position ) {
    gtk_paned_set_position( self.WIDGET, $position )
}