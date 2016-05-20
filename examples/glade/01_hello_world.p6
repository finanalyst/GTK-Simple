#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple;

class MyApp is GTK::Simple::GladeApp {
    has $.button;
    has $.second;
};
my $app = MyApp.new;

$app.button.clicked.tap({ .sensitive = False; $app.second.sensitive = True });
$app.second.clicked.tap({ $app.exit; });


$app.run;
