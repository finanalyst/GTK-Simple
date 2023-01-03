use v6;

use GTK::Simple::Raw :list-box, :list-box-row, :DEFAULT;
use GTK::Simple::Widget;
use GTK::Simple::Container;
use GTK::Simple::Common;
use GTK::Simple::Label;
use NativeCall;

unit class GTK::Simple::ListBox does GTK::Simple::Widget;

class Row does GTK::Simple::Widget does GTK::Simple::Container {
    submethod BUILD() {
        self.WIDGET(gtk_list_box_row_new);
    }

    method activatable()
        returns Bool
        is gtk-property(&gtk_list_box_row_get_activatable, &gtk_list_box_row_set_activatable)
        { * }

    method selectable()
        returns Bool
        is gtk-property(&gtk_list_box_row_get_selectable, &gtk_list_box_row_set_selectable)
        { * }

    method selected() {
        gtk_list_box_row_is_selected(self.WIDGET)
    }

    method changed() {
        gtk_list_box_row_changed(self.WIDGET)
    }
}

submethod BUILD() {
    self.WIDGET(gtk_list_box_new);
}

method single-click()
    returns Bool
    is gtk-property(&gtk_list_box_get_activate_on_single_click, &gtk_list_box_set_activate_on_single_click)
    { * }

method selection-mode()
    returns GtkSelectionMode
    is gtk-property(&gtk_list_box_get_selection_mode, &gtk_list_box_set_selection_mode)
    { * }

method prepend(GTK::Simple::Widget $row) {
    gtk_list_box_prepend(self.WIDGET, $row.WIDGET);
    gtk_widget_show($row.WIDGET);
}

method add-label-row($text, :$selectable = True, :$activatable = True) {
    my $row = Row.new;
    $row.activatable = $activatable;
    $row.selectable = $selectable;
    my $label-widget = GTK::Simple::Label.new(:$text);
    $row.set-content($label-widget);
    self.prepend($row);
}