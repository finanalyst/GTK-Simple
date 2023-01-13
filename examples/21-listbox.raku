#!/usr/bin/env raku
use v6.d;

use GTK::Simple;
use GTK::Simple::App;
use GTK::Simple::ListBox;   # To access the SelectionMode enum more easily,
                            # otherwise GTK::Simple::ListBox is available via `use GTK::Simple`

my $app = GTK::Simple::App.new(title => 'ListBox');

# Note: There is a bug which prevents single-click mode from working well with SelectionMode::MULTIPLE
#           (see https://gitlab.gnome.org/GNOME/gtk/-/issues/552). For this example we will not use the default
#           single-click mode.

my $list-box = GTK::Simple::ListBox.new(:!single-click, selection-mode => SelectionMode::SINGLE);

my $text = GTK::Simple::TextView.new();
$text.editable = False;
$text.cursor-visible = False;
$text.text = "Select a row...";

# GTK3 only supports `prepend` for the adding listbox rows, so we do it in reverse order
$list-box.add-label-row("Unselectable", :!selectable);
$list-box.add-label-row("Test Row 2");
$list-box.add-label-row("Test Row 1");

$list-box.selection.tap: {
    if my @selected = $list-box.selected-rows {
        if $list-box.selection-mode ~~ SelectionMode::SINGLE {
            $text.text = "Row selected: " ~ @selected.first.child.text;
        } else {
            $text.text = "Rows selected:\n" ~ @selected.map({ .child.text }).join("\n");
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
        $list-box.selection-mode = SelectionMode::MULTIPLE;
    } else {
        $list-box.unselect-all;
        $list-box.selection-mode = SelectionMode::SINGLE;
    }
}

my $hbox = GTK::Simple::HBox.new($new-row-entry, $new-row-button);
my $vbox = GTK::Simple::VBox.new($list-box, $text, $multi-button, $hbox);
$vbox.spacing = 8;

$app.set-content($vbox);

$app.run;
