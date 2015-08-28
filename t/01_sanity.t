use Test;
use GTK::Simple;
plan 3;

my $g;
lives-ok {$g = GTK::Simple::App.new}
lives-ok {GTK::Simple::Scheduler.new.cue: {$g.exit}}
lives-ok {$g.run}
