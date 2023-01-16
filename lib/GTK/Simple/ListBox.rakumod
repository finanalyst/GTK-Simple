use v6;

use GTK::Simple::Raw :list-box, :list-box-row, :DEFAULT;
use GTK::Simple::Widget;
use GTK::Simple::Container;
use GTK::Simple::Common;
use GTK::Simple::Label;
use NativeCall;

unit class GTK::Simple::ListBox does GTK::Simple::Widget;

has $!selection-supplier;
has @.rows;

enum SelectionMode is export <NONE SINGLE BROWSE MULTIPLE>;

class Row does GTK::Simple::Widget does GTK::Simple::Container {
    has GTK::Simple::Widget $.child;

    submethod BUILD() {
        self.WIDGET(gtk_list_box_row_new);
    }

    method activatable()
            returns Bool
            is gtk-property(&gtk_list_box_row_get_activatable, &gtk_list_box_row_set_activatable)
    {*}

    method selectable()
            returns Bool
            is gtk-property(&gtk_list_box_row_get_selectable, &gtk_list_box_row_set_selectable)
    {*}

    method selected() {
        gtk_list_box_row_is_selected(self.WIDGET)
    }

    method changed() {
        gtk_list_box_row_changed(self.WIDGET)
    }

    method add-child($widget) {
        self.set-content($widget);
        $!child = $widget;
    }
}

submethod BUILD(Bool :$single-click = True, SelectionMode :$selection-mode = SINGLE) {
    self.WIDGET(gtk_list_box_new);
    gtk_list_box_set_activate_on_single_click(self.WIDGET, $single-click);
    gtk_list_box_set_selection_mode(self.WIDGET, $selection-mode);
}

method single-click()
    returns Bool
    is gtk-property(&gtk_list_box_get_activate_on_single_click, &gtk_list_box_set_activate_on_single_click)
    {*}

method selection-mode()
    returns SelectionMode
    is gtk-property(&gtk_list_box_get_selection_mode, &gtk_list_box_set_selection_mode)
    {*}

method prepend-row(GTK::Simple::Widget $row) {
    gtk_list_box_prepend(self.WIDGET, $row.WIDGET);
    gtk_widget_show($row.WIDGET);
    @!rows.push($row);
}

method add-label-row($text, :$selectable = True, :$activatable = True) {
    my $row = Row.new;
    $row.activatable = $activatable;
    $row.selectable = $selectable;
    my $label-widget = GTK::Simple::Label.new(:$text);
    $row.add-child($label-widget);
    self.prepend-row($row);
}

method selected-rows() {
    self.selection-mode == SINGLE
        ?? |@!rows.grep({ $_.selected })
        !! |@!rows.grep({ $_.selected }).reverse # Because we have 'prepend' semantics, the row order is reversed
}

method selection {
    $!selection-supplier //= do self.signal-supply("row-selected");
}

method select-row(Row $row) {
    if ($row.selectable) {
        gtk_list_box_select_row(self.WIDGET, $row.WIDGET);
    }
}

method unselect-row(Row $row) {
    gtk_list_box_unselect_row(self.WIDGET, $row.WIDGET);
}

method unselect-all() {
    gtk_list_box_unselect_all(self.WIDGET);
}