use GTK::Simple;

class MyApp is GTK::Simple::GladeApp {

  multi method handle-signal('onButton1Pressed') {
    say "You sure can push my buttons";
  }

  multi method handle-signal($signal-name) {
   note "Unhandled Signal: $signal-name"; 
  }
}

MyApp.new.run;

