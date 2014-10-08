use Test;
use GTK::Simple;
plan 3;

my $g;
lives_ok {$g = GTK::Simple::App.new}
lives_ok {GTK::Simple::Scheduler.new.cue: {$g.exit}}
lives_ok {$g.run}
