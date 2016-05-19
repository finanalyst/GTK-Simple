#!/usr/bin/env perl6

use GTK::Simple;

my $app = GTK::Simple::App.new(title => "Combo Box");
$app.size-request(300,100);

my $combo = GTK::Simple::ComboBoxText.new;

for <one two three four five six> -> $item {
    $combo.append-text("Entry " ~ $item);

}

my $label = GTK::Simple::Label.new(text => "not selected");

$combo.changed.tap({
    $label.text = $combo.active-text();
});

$app.set-content(GTK::Simple::VBox.new($label, $combo));

$app.run;

