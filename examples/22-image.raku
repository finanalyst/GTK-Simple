use v6.e.PREVIEW;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::Image;
use GTK::Simple::VBox;
use GTK::Simple::Distro::Resources;

my $app = GTK::Simple::App.new(:title("Image Demo"), :1024width, :768height);

my $logo-path = $*TMPDIR.add("camelia-logo.png");
$logo-path.spurt: gtk-simple-resources<camelia-logo.png>.slurp(:bin, :close);

$app.set-content:
        GTK::Simple::Image.new: :path($logo-path.absolute);

$app.run;