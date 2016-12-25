#!/usr/bin/env perl6

use v6.c;
use lib 'lib';
use GTK::Simple;

my $app = GTK::Simple::App.new(title=> 'Example 18');

# my $some-text = GTK::Simple::ScrolledWindow.new;
my $t = GTK::Simple::TextView.new;
$t.text ~= [~] gather for ^25 { take '  ' x $_ ~ "the quick brown fox jumps over the lazy dog\n" };
# $some-text.set-content( $t );

# my $more-text = GTK::Simple::ScrolledWindow.new;
my $u = GTK::Simple::TextView.new;
$u.text ~= [~] gather for ^25 { take '  ' x (25 - $_) ~ "Twas brillig and the slithy toothes did gyre and gymbol\n" };
# $more-text.set-content( $u ) ;

# my $exit-b = GTK::Simple::ToggleButton.new(label=>'Exit');
# 
my $h-paned = GTK::Simple::Paned.new(:orientation(1));
# my $v-paned = GTK::Simple::Paned.new(:orientation<vertical>);

=comment
    C<orientation> may only take the values 'horizontal' (default) or 'vertical'
    The standard GTK-3 Pane has two pack functions (pack1 and pack2)
    These are kept, but an additional helper C<set-contents> function combines them
    (Note the extra 's').
    Each of the two panes have two presentation options, called C<shrink> and C<resize>.
    C<shrink> = True (default) allows the pane to go smaller than the minimum widget size
    C<shrink> = False sets a minimum size defined by the contained widget
    C<resize> = True (default) allows the pane to be resized (expanded or contracted)
    C<resize> = False freezes the pane to the initial size request of the contained widget.
    For C<set-contents> these are shrink-a, shrink-b, resize-a, resize-b.
    The widget associated with C<pack1> and C<a> in C<set-contents> is placed in the left pane for horizontal 
	orientation, and the top pane for the vertical orientation. 

# $h-paned.set-contents( :a($some-text), :b($more-text) );
# $v-paned.set-contents( :b($some-text), :a($more-text), :resize-a(False), :shrink-b(False));

=comment
    To do the same as the line above using pack1/2 would require
    
# $h-paned.pack1($some-text); $h-paned.pack2($more-text);
# $v-paned.pack1($some-text,:resize(False)); $v-paned.pack2($more-text,:shrink(False));

$h-paned.add1( $t ); $h-paned.add2( $u );
$h-paned.set-position(-1);

# $v-paned.pack1($t,:resize(False)); $v-paned.pack2($u,:shrink(False));

# my $v  = GTK::Simple::VBox.new( 
#     $h-paned,
# #     $v-paned,
# #     $some-text, $more-text,
#     $exit-b
# );
# 
# $exit-b.toggled.tap(-> $b { $app.exit } );

$app.set-content( $h-paned );
$app.border-width = 20;
$app.run;