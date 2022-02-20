#!/usr/bin/env perl6

use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::FileChooserButton;
use GTK::Simple::TextView;
use GTK::Simple::VBox;

my $app                  = GTK::Simple::App.new(:title("File Chooser Demo"));
my $text-view            = GTK::Simple::TextView.new;
my $file-chooser-button  = GTK::Simple::FileChooserButton.new(
    :title("Please Select a File")
);

$file-chooser-button.file-set.tap: {
    $text-view.text ~= $file-chooser-button.file-name ~ "\n";
}

$app.set-content(
    GTK::Simple::VBox.new([
        { :widget($file-chooser-button), :expand(False) },
        $text-view,
    ])
);

$app.show;
$app.run;
