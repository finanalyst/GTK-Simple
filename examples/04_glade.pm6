use GTK::Simple;

class MyApp is GTK::Simple::GladeApp {
    has Supply $.button-one-signal is gtk-signal-handler('onButton1Pressed');
}

my $app = MyApp.new;

$app.button-one-signal.tap(-> ( $handler, $signal, $object) {
    say "got button1 signal $signal";
});

$app.signal-supply.tap(-> ($handler, $signal, $object) {
    say "got otherwise unhandled $signal for $handler";
});

$app.run;

