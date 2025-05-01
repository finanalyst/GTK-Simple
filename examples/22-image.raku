
use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::Image;
use GTK::Simple::VBox;

my $app = GTK::Simple::App.new(:title("Image Demo"), :1024width, :768height);

my $image = GTK::Simple::Image.new(:path(~$*PROGRAM.parent.add("resources/camelia-logo.png")));
$app.set-content($image);

$app.run;