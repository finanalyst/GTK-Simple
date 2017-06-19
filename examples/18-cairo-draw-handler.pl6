#!/usr/bin/env perl6

=comment
   The Cairo module needs to be installed, for this example to work

use v6.c;
use lib 'lib';
use GTK::Simple;
use GTK::Simple::DrawingArea;

my $app = GTK::Simple::App.new(:title<Test>);
my $da = GTK::Simple::DrawingArea.new;
gtk_simple_use_cairo;

$app.set-content( $da );
$app.border-width = 20;
$da.size-request(300,300);

sub rect-do( $d, $ctx ) {
    given $ctx {
	.rgb(0, 0.7, 0.9);
	.rectangle(10, 10, 50, 50);
	.fill :preserve; .rgb(1, 1, 1);
	.stroke
    };
}

my $ctx = $da.add-draw-handler( &rect-do );
$app.run;
