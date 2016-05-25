use Test;
use GTK::Simple;
plan *;
my $g;
if %*ENV<DISPLAY> {
    lives-ok {$g = GTK::Simple::App.new}
    lives-ok {GTK::Simple::Scheduler.new.cue: {$g.exit}}
    lives-ok {$g.run}
}

done-testing;
