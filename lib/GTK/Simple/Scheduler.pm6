
use v6;

use nqp;
use NativeCall;
use GTK::Simple::Raw;

unit class GTK::Simple::Scheduler does Scheduler;

my class Queue is repr('ConcBlockingQueue') { }
my $queue := nqp::create(Queue);

my &idle_cb = sub ($a) { GTK::Simple::Scheduler.process-queue; return 0 };

method cue(&code, :$at, :$in, :$every, :$times, :&catch ) {
    die "GTK::Simple::Scheduler does not support at" if $at;
    die "GTK::Simple::Scheduler does not support in" if $in;
    die "GTK::Simple::Scheduler does not support every" if $every;
    die "GTK::Simple::Scheduler does not support times" if $times;
    my &run := &catch
        ?? -> { code(); CATCH { default { catch($_) } } }
        !! &code;
    nqp::push($queue, &run);
    g_idle_add(&idle_cb, OpaquePointer);
    return Nil;
}

method process-queue() {
    my Mu $task := nqp::queuepoll($queue);
    unless nqp::isnull($task) {
        if nqp::islist($task) {
            my Mu $code := nqp::shift($task);
            $code(|nqp::hllize($task, Any));
        }
        else {
            $task();
        }
    }
}

method process_queue() {
    DEPRECATED('process-queue',Any,'0.3.2');
    self.process-queue();
}

method loads() { nqp::elems($queue) }
