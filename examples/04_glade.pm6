use GTK::Simple;

class MyApp is GTK::Simple::GladeApp {

}

my $app = MyApp.new;

$app.signal-supply.tap(-> ($handler, $signal, $object) {
    say "got $signal for $handler";
});

$app.run;

