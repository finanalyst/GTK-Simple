
use v6;
use Test;
use GTK::Simple;

plan *;

if %*ENV<DISPLAY> or $*DISTRO.is-win {
    my $g;
    lives-ok {$g = GTK::Simple::App.new}
    lives-ok {GTK::Simple::Scheduler.new.cue: {$g.exit}}
    lives-ok {$g.run}
}

done-testing;
