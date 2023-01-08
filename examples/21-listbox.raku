#!/usr/bin/env raku
use v6.d;

use GTK::Simple;
use GTK::Simple::App;

my $app = GTK::Simple::App.new(title => 'ListBox');

# Note: There is a bug which prevents single-click mode from working well with SelectionMode::MULTIPLE
#           (see https://gitlab.gnome.org/GNOME/gtk/-/issues/552). So for this example we will not use single-click mode.

my $list-box = GTK::Simple::ListBox.new(:!single-click, selection-mode => GTK::Simple::ListBox::SelectionMode::SINGLE);

my $text = GTK::Simple::TextView.new();
$text.editable = False;
$text.cursor-visible = False;
$text.text = "Select a row...";

# GTK3 only supports `prepend` for the adding listbox rows, so we do it in reverse order
$list-box.add-label-row("Unselectable", :!selectable);
$list-box.add-label-row("Test Row 2");
$list-box.add-label-row("Test Row 1");

$list-box.row-selected.tap: {
    if $list-box.selected {
        if $list-box.selection-mode ~~ GTK::Simple::ListBox::SelectionMode::SINGLE {
            $text.text = "Row selected: " ~ $list-box.selected.children.first.text;
        } else {
            $text.text = "Rows selected:\n" ~ $list-box.selected.map({ .children.first.text }).join("\n");
        }
    } else {
        $text.text = "Select a row...";
    }
}

my $new-row-entry = GTK::Simple::Entry.new;
my $new-row-button = GTK::Simple::Button.new(label => 'Add row');

$new-row-button.clicked.tap: {
    if my $row-text = $new-row-entry.text {
        $list-box.add-label-row($row-text);
    }
}

my $multi-button = GTK::Simple::CheckButton.new(label => 'Multi selection?');
$multi-button.toggled.tap: {
    if $multi-button.status {
        $list-box.selection-mode = GTK::Simple::ListBox::SelectionMode::MULTIPLE;
    } else {
        $list-box.unselect-all;
        $list-box.selection-mode = GTK::Simple::ListBox::SelectionMode::SINGLE;
    }
}

my $hbox = GTK::Simple::HBox.new($new-row-entry, $new-row-button);
my $vbox = GTK::Simple::VBox.new($list-box, $text, $multi-button, $hbox);
$vbox.spacing = 8;

$app.set-content($vbox);

$app.run;
