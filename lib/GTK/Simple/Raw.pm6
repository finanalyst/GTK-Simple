
use v6;

use GTK::Simple::NativeLib;
use NativeCall;

unit module GTK::Simple::Raw;

class GtkWidget is repr('CPointer') is export { }
class GObject   is repr('CPointer') is export { }

enum GtkWindowPosition is export (
    GTK_WIN_POS_NONE               => 0,
    GTK_WIN_POS_CENTER             => 1,
    GTK_WIN_POS_MOUSE              => 2,
    GTK_WIN_POS_CENTER_ALWAYS      => 3,
    GTK_WIN_POS_CENTER_ON_PARENT   => 4,
);

enum GtkFileChooserAction is export(:file-chooser) (
    GTK_FILE_CHOOSER_ACTION_OPEN           => 0,
    GTK_FILE_CHOOSER_ACTION_SAVE           => 1,
    GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER  => 2,
    GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER  => 3,
);

enum GtkPlacesOpenFlags is export(:places-sidebar) (
    GTK_PLACES_OPEN_NORMAL     => 0,
    GTK_PLACES_OPEN_NEW_TAB    => 1,
    GTK_PLACES_OPEN_NEW_WINDOW => 2,
);

enum GtkLevelBarMode is export(:level-bar) (
    GTK_LEVEL_BAR_MODE_CONTINUOUS => 0,
    GTK_LEVEL_BAR_MODE_DISCRETE   => 1,
);

#Determines how the size should be computed to achieve the one of the visibility mode for the scrollbars.
enum GtkPolicyType is export(:scrolled-window) (
    GTK_POLICY_ALWAYS => 0,     #The scrollbar is always visible.
                                #The view size is independent of the content.
    GTK_POLICY_AUTOMATIC => 1,  #The scrollbar will appear and disappear as necessary.
                                #For example, when all of a Gtk::TreeView can not be seen.
    GTK_POLICY_NEVER => 2,      #The scrollbar should never appear.
                                #In this mode the content determines the size.
    GTK_POLICY_EXTERNAL => 3,   #Don't show a scrollbar, but don't force the size to follow the content.
                                #This can be used e.g. to make multiple scrolled windows share a scrollbar.
);

# gtk_widget_... {{{

sub gtk_widget_show(GtkWidget $widgetw)
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_hide(GtkWidget $widgetw)
    is native(&gtk-lib)
    is export    
    { * }

sub gtk_widget_show_all(GtkWidget $widgetw)
    is native(&gtk-lib)
    is export
    { * }

sub gtk_widget_set_no_show_all(GtkWidget $widgetw, int32 $no_show_all)
    is native(&gtk-lib)
    is export
    { * }

sub gtk_widget_get_no_show_all(GtkWidget $widgetw) 
    returns int32
    is native(&gtk-lib)
    is export
    { * }

sub gtk_widget_destroy(GtkWidget $widget)
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_set_sensitive(GtkWidget $widget, int32 $sensitive)
    is native(&gtk-lib)
    is export

    {*}
sub gtk_widget_get_sensitive(GtkWidget $widget)
    returns int32
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_set_size_request(GtkWidget $widget, int32 $w, int32 $h)
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_get_allocated_height(GtkWidget $widget)
    returns int32
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_get_allocated_width(GtkWidget $widget)
    returns int32
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_queue_draw(GtkWidget $widget)
    is native(&gtk-lib)
    is export
    {*}

sub gtk_widget_get_tooltip_text(GtkWidget $widget)
    is native(&gtk-lib)
    is export
    returns Str
    { * }

sub gtk_widget_set_tooltip_text(GtkWidget $widget, Str $text)
    is native(&gtk-lib)
    is export
    { * }

sub gtk_window_new(int32 $window_type)
    is native(&gtk-lib)
    is export
    returns GtkWidget
    {*}

sub gtk_window_set_title(GtkWidget $w, Str $title)
    is native(&gtk-lib)
    is export
    returns GtkWidget
    {*}

sub gtk_window_set_position(GtkWidget $window, int32 $position)
    is native(&gtk-lib)
    is export
    { * }

sub gtk_window_set_default_size(GtkWidget $window, int32 $width, int32 $height)
    is native(&gtk-lib)
    is export
    { * }

# gtk_widget_ ... }}}

# gtk_container_... {{{
sub gtk_container_add(GtkWidget $container, GtkWidget $widgen)
    is native(&gtk-lib)
    is export
    {*}

sub gtk_container_get_border_width(GtkWidget $container)
    returns int32
    is native(&gtk-lib)
    is export
    {*}

sub gtk_container_set_border_width(GtkWidget $container, int32 $border_width)
    is native(&gtk-lib)
    is export
    {*}

# gtk_container_... }}}

# g_signal... {{{

sub g_signal_connect_wd(GtkWidget $widget, Str $signal,
    &Handler (GtkWidget $h_widget, OpaquePointer $h_data),
    OpaquePointer $data, int32 $connect_flags)
    returns int32
    is native(&gobject-lib)
    is symbol('g_signal_connect_object')
    is export
    { * }

sub g_signal_handler_disconnect(GtkWidget $widget, int32 $handler_id)
    is native(&gobject-lib)
    is export
    { * }

# g_signal... }}}

sub g_idle_add(
        &Handler (OpaquePointer $h_data),
        OpaquePointer $data)
    is native(&glib-lib)
    is export
    returns int32
    {*}

sub g_timeout_add(int32 $interval, &Handler (OpaquePointer $h_data, --> int32), OpaquePointer $data)
    is native(&gtk-lib)
    is export
    returns int32
    {*}

#
# App
#
sub gtk_init(CArray[int32] $argc, CArray[CArray[Str]] $argv)
    is native(&gtk-lib)
    is export(:app)
    {*}

sub gtk_main()
    is native(&gtk-lib)
    is export(:app)
    {*}

sub gtk_main_quit()
    is native(&gtk-lib)
    is export(:app)
    {*}

#
# Box
#
sub gtk_box_pack_start(GtkWidget, GtkWidget, int32, int32, int32)
    is native(&gtk-lib)
    is export(:box)
    {*}

sub gtk_box_get_spacing(GtkWidget $box)
    returns int32
    is native(&gtk-lib)
    is export(:box)
    {*}

sub gtk_box_set_spacing(GtkWidget $box, int32 $spacing)
    is native(&gtk-lib)
    is export(:box)
    {*}

#
# HBox
#
sub gtk_hbox_new(int32, int32)
    is native(&gtk-lib)
    is export(:hbox)
    returns GtkWidget
    {*}

#
# VBox
#
sub gtk_vbox_new(int32, int32)
    is native(&gtk-lib)
    is export(:vbox)
    returns GtkWidget
    {*}

#
# Button
#
sub gtk_button_new_with_label(Str $label)
    is native(&gtk-lib)
    is export(:button)
    returns GtkWidget
    {*}

sub gtk_button_get_label(GtkWidget $widget)
    is native(&gtk-lib)
    is export(:button)
    returns Str
    { * }

sub gtk_button_set_label(GtkWidget $widget, Str $label)
    is native(&gtk-lib)
    is export(:button)
    { * }

#
# CheckButton
#
sub gtk_check_button_new_with_label(Str $label)
    is native(&gtk-lib)
    is export(:check-button)
    returns GtkWidget
    {*}

#
# ToggleButton
#
sub gtk_toggle_button_new_with_label(Str $label)
    is native(&gtk-lib)
    is export(:toggle-button)
    returns GtkWidget
    {*}

sub gtk_toggle_button_get_active(GtkWidget $w)
    is native(&gtk-lib)
    is export(:toggle-button)
    returns int32
    {*}

sub gtk_toggle_button_set_active(GtkWidget $w, int32 $active)
    is native(&gtk-lib)
    is export(:toggle-button)
    returns int32
    {*}

#
# ComboBoxText
#
sub gtk_combo_box_text_new()
    is native(&gtk-lib)
    is export(:combo-box-text)
    returns GtkWidget
    { * }

sub gtk_combo_box_text_new_with_entry()
    is native(&gtk-lib)
    is export(:combo-box-text)
    returns GtkWidget
    { * }

sub gtk_combo_box_text_prepend_text(GtkWidget $widget, Str $text)
    is native(&gtk-lib)
    is export(:combo-box-text)
    { * }

sub gtk_combo_box_text_append_text(GtkWidget $widget, Str $text)
    is native(&gtk-lib)
    is export(:combo-box-text)
    { * }

sub gtk_combo_box_text_insert_text(GtkWidget $widget, int32 $position, Str $text)
    is native(&gtk-lib)
    is export(:combo-box-text)
    { * }

sub gtk_combo_box_set_active(GtkWidget $widget, int32 $index)
    is native(&gtk-lib)
    is export(:combo-box-text)
    { * }

sub gtk_combo_box_get_active(GtkWidget $widget)
    is native(&gtk-lib)
    is export(:combo-box-text)
    returns int32
    { * }

sub gtk_combo_box_text_get_active_text(GtkWidget $widget)
    is native(&gtk-lib)
    is export(:combo-box-text)
    returns Str
    { * }

sub gtk_combo_box_text_remove(GtkWidget $widget, int32 $position)
    is native(&gtk-lib)
    is export(:combo-box-text)
    { * }

sub gtk_combo_box_text_remove_all(GtkWidget $widget)
    is native(&gtk-lib)
    is export(:combo-box-text)
    { * }

#
# Grid
#
sub gtk_grid_new()
    is native(&gtk-lib)
    is export(:grid)
    returns GtkWidget
    {*}

sub gtk_grid_attach(GtkWidget $grid, GtkWidget $child, int32 $x, int32 $y, int32 $w, int32 $h)
    is native(&gtk-lib)
    is export(:grid)
    {*}

#
# Scale
#
sub gtk_scale_new_with_range( int32 $orientation, num64 $min, num64 $max, num64 $step )
    is native(&gtk-lib)
    is export(:scale)
    returns GtkWidget
    {*}

# orientation:
# horizontal = 0
# vertical = 1 , inverts so that big numbers at top.
sub gtk_scale_set_digits( GtkWidget $scale, int32 $digits )
    is native( &gtk-lib)
    is export(:scale)    
    {*}
    
sub gtk_range_get_value( GtkWidget $scale )
    is native(&gtk-lib)
    is export(:scale)    
    returns num64
    {*}
    
sub gtk_range_set_value( GtkWidget $scale, num64 $value )
    is native(&gtk-lib)
    is export(:scale)    
    {*}

sub gtk_range_set_inverted( GtkWidget $scale, Bool $invertOK )
    is native(&gtk-lib)
    is export(:scale)    
    {*}

#
# Separator
#
sub gtk_separator_new(int32 $orientation)
    is native(&gtk-lib)
    is export(:separator)
    returns GtkWidget
    { * }

#
# ActionBar
#
sub gtk_action_bar_new()
    is native(&gtk-lib)
    is export(:action-bar)
    returns GtkWidget
    { * }

sub gtk_action_bar_pack_start(GtkWidget $widget, GtkWidget $child)
    is native(&gtk-lib)
    is export(:action-bar)
    { * }

sub gtk_action_bar_pack_end(GtkWidget $widget, GtkWidget $child)
    is native(&gtk-lib)
    is export(:action-bar)
    { * }

sub gtk_action_bar_get_center_widget(GtkWidget $widget)
    is native(&gtk-lib)
    is export(:action-bar)
    returns GtkWidget
    { * }

sub gtk_action_bar_set_center_widget(GtkWidget $widget, GtkWidget $centre-widget)
    is native(&gtk-lib)
    is export(:action-bar)
    { * }

#
# Entry
#
sub gtk_entry_new()
    is native(&gtk-lib)
    is export(:entry)
    returns GtkWidget
    {*}

sub gtk_entry_get_text(GtkWidget $entry)
    is native(&gtk-lib)
    is export(:entry)
    returns Str
    {*}

sub gtk_entry_set_text(GtkWidget $entry, Str $text)
    is native(&gtk-lib)
    is export(:entry)
    {*}

#
# Frame
#
sub gtk_frame_new(Str $label)
    is native(&gtk-lib)
    is export(:frame)
    returns GtkWidget
    { * }

sub gtk_frame_get_label(GtkWidget $widget)
    is native(&gtk-lib)
    is export(:frame)
    returns Str
    { * }

sub gtk_frame_set_label(GtkWidget $widget, Str $label)
    is native(&gtk-lib)
    is export(:frame)
    { * }

#
# Label
#
sub gtk_label_new(Str $text)
    is native(&gtk-lib)
    is export(:label)
    returns GtkWidget
    {*}

sub gtk_label_get_text(GtkWidget $label)
    is native(&gtk-lib)
    is export(:label)
    returns Str
    {*}

sub gtk_label_set_text(GtkWidget $label, Str $text)
    is native(&gtk-lib)
    is export(:label)
    {*}

sub gtk_label_set_markup(GtkWidget $label, Str $text)
    is native(&gtk-lib)
    is export(:label)
    {*}

#
# DrawingArea
#
sub gtk_drawing_area_new()
    is native(&gtk-lib)
    is export(:drawing-area)
    returns GtkWidget
    {*}

#
# ProgressBar
#
sub gtk_progress_bar_new()
    is native(&gtk-lib)
    is export(:progress-bar)
    returns GtkWidget
    { * }

sub gtk_progress_bar_pulse(GtkWidget $widget)
    is native(&gtk-lib)
    is export(:progress-bar)
    { * }

sub gtk_progress_bar_set_fraction(GtkWidget $widget, num64 $fractions)
    is native(&gtk-lib)
    is export(:progress-bar)
    { * }

sub gtk_progress_bar_get_fraction(GtkWidget $widget)
    is native(&gtk-lib)
    is export(:progress-bar)
    returns num64
    { * }

#
# Spinner
#
sub gtk_spinner_new()
    is native(&gtk-lib)
    is export(:spinner)
    returns GtkWidget
    { * }

sub gtk_spinner_start(GtkWidget $widget)
    is native(&gtk-lib)
    is export(:spinner)
    { * }

sub gtk_spinner_stop(GtkWidget $widget)
    is native(&gtk-lib)
    is export(:spinner)
    { * }

#
# StatusBar
#
sub gtk_statusbar_new()
    is native(&gtk-lib)
    is export(:status-bar)
    returns GtkWidget
    { * }

sub gtk_statusbar_get_context_id(GtkWidget $widget, Str $description)
    is native(&gtk-lib)
    is export(:status-bar)
    returns uint32
    { * }

sub gtk_statusbar_push(GtkWidget $widget, uint32 $context_id, Str $text)
    is native(&gtk-lib)
    is export(:status-bar)
    returns uint32
    { * }

sub gtk_statusbar_pop(GtkWidget $widget, uint32 $context-id)
    is native(&gtk-lib)
    is export(:status-bar)
    { * }

sub gtk_statusbar_remove(GtkWidget $widget, uint32 $context-id, uint32 $message-id)
    is native(&gtk-lib)
    is export(:status-bar)
    { * }

sub gtk_statusbar_remove_all(GtkWidget $widget, uint32 $context-id)
    is native(&gtk-lib)
    is export(:status-bar)
    { * }

#
# Switch
#
sub gtk_switch_new()
    is native(&gtk-lib)
    is export(:switch)
    returns GtkWidget
    {*}

sub gtk_switch_get_active(GtkWidget $w)
    is export(:switch)
    is native(&gtk-lib)
    returns int32
    {*}

sub gtk_switch_set_active(GtkWidget $w, int32 $a)
    is native(&gtk-lib)
    is export(:switch)
    {*}

#
# TextView
#
sub gtk_text_view_new()
    is native(&gtk-lib)
    is export(:text-view)
    returns GtkWidget
    {*}

sub gtk_text_view_get_buffer(GtkWidget $view)
    is native(&gtk-lib)
    is export(:text-view)
    returns OpaquePointer
    {*}

sub gtk_text_buffer_get_text(OpaquePointer $buffer, CArray[int32] $start,
        CArray[int32] $end, int32 $show_hidden)
    is native(&gtk-lib)
    is export(:text-view)
    returns Str
    {*}

sub gtk_text_buffer_get_start_iter(OpaquePointer $buffer, CArray[int32] $i)
    is native(&gtk-lib)
    is export(:text-view)
    {*}

sub gtk_text_buffer_get_end_iter(OpaquePointer $buffer, CArray[int32] $i)
    is native(&gtk-lib)
    is export(:text-view)
    {*}

sub gtk_text_buffer_set_text(OpaquePointer $buffer, Str $text, int32 $len)
    is native(&gtk-lib)
    is export(:text-view)
    {*}

sub gtk_text_view_set_editable(GtkWidget $widget, int32 $setting) 
    is native(&gtk-lib)
    is export(:text-view)
    { * }

sub gtk_text_view_get_editable(GtkWidget $widget) 
    is native(&gtk-lib)
    is export(:text-view)
    returns int32
    { * }

sub gtk_text_view_set_cursor_visible(GtkWidget $widget, int32 $setting) 
    is native(&gtk-lib)
    is export(:text-view)
    { * }

sub gtk_text_view_get_cursor_visible(GtkWidget $widget) 
    is native(&gtk-lib)
    is export(:text-view)
    returns int32
    { * }

sub gtk_text_view_get_monospace(GtkWidget $widget)
    is native(&gtk-lib)
    is export(:text-view)
    returns int32
    { * }

sub gtk_text_view_set_monospace(GtkWidget $widget, int32 $setting)
    is native(&gtk-lib)
    is export(:text-view)
    { * }

#
# Toolbar
#
sub gtk_toolbar_new()
    returns GtkWidget
    is native(&gtk-lib)
    is export(:toolbar)
    { * }

sub gtk_tool_button_new_from_stock(Str)
    returns GtkWidget
    is native(&gtk-lib)
    is export(:toolbar)
    { * }

sub gtk_separator_tool_item_new()
    returns GtkWidget
    is native(&gtk-lib)
    is export(:toolbar)
    { * }

sub gtk_toolbar_set_style(Pointer $toolbar, int32 $style)
    is native(&gtk-lib)
    is export(:toolbar)
    { * }

sub gtk_toolbar_insert(Pointer $toolbar, Pointer $button, int32)
    is native(&gtk-lib)
    is export(:toolbar)
    { * }

#
# MenuBar
#
sub gtk_menu_bar_new()
    returns GtkWidget
    is native(&gtk-lib)
    is export(:menu-bar)
    { * }

#
# Menu
#
sub gtk_menu_new()
    returns GtkWidget
    is native(&gtk-lib)
    is export(:menu)
    { * }

sub gtk_menu_shell_append(Pointer $menu, Pointer $menu-item)
    is native(&gtk-lib)
    is export(:menu)
    { * }

#
# MenuItem
#
sub gtk_menu_item_new_with_label(Str $label)
    returns GtkWidget
    is native(&gtk-lib)
    is export(:menu-item)
    { * }

sub gtk_menu_item_set_submenu(Pointer $menu-item, Pointer $sub-menu)
    is native(&gtk-lib)
    is export(:menu-item)
    { * }

#
# FileChooserButton
#
sub gtk_file_chooser_button_new(Str $title, int32 $action)
    returns GtkWidget
    is native(&gtk-lib)
    is export(:file-chooser)
    { * }

sub gtk_file_chooser_button_get_title(GtkWidget $button)
    returns Str
    is native(&gtk-lib)
    is export(:file-chooser)
    { * }

sub gtk_file_chooser_button_set_title(GtkWidget $button, Str $title)
    is native(&gtk-lib)
    is export(:file-chooser)
    { * }

sub gtk_file_chooser_button_get_width_chars(GtkWidget $button)
    returns int32
    is native(&gtk-lib)
    is export(:file-chooser)
    { * }

sub gtk_file_chooser_button_set_width_chars(GtkWidget $button, int32 $n-chars)
    is native(&gtk-lib)
    is export(:file-chooser)
    { * }

sub gtk_file_chooser_get_filename(GtkWidget $file-chooser)
    returns Str
    is native(&gtk-lib)
    is export(:file-chooser)
    { * }

sub gtk_file_chooser_set_filename(GtkWidget $file-chooser, Str $file-name)
    is native(&gtk-lib)
    is export(:file-chooser)
    { * }

#
# PlacesSidebar
#
sub gtk_places_sidebar_new()
    returns GtkWidget
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_get_open_flags(GtkWidget $sidebar) 
    returns int32
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_get_local_only(GtkWidget $sidebar)
    returns Bool
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }
    
sub gtk_places_sidebar_set_local_only(GtkWidget $sidebar, Bool $local-only)
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_set_open_flags(GtkWidget $sidebar, int32 $flags) 
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_get_show_connect_to_server(GtkWidget $siderbar)
    returns int32
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_set_show_connect_to_server(
    GtkWidget $sidebar, 
    Bool $show-connect-to-server)
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_get_show_desktop(GtkWidget $sidebar) 
    returns Bool
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_set_show_desktop(GtkWidget $sidebar, Bool $show-desktop)
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_get_show_other_locations(GtkWidget $sidebar)
    returns Bool
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_set_show_other_locations(
    GtkWidget $sidebar, Bool $show-other-locations
)   is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_get_show_recent(GtkWidget $sidebar)
    returns Bool
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_set_show_recent(GtkWidget $sidebar, Bool $show-recent)
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_get_show_trash(GtkWidget $sidebar)
    returns Bool
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

sub gtk_places_sidebar_set_show_trash(GtkWidget $sidebar, Bool $show-trash)
    is native(&gtk-lib)
    is export(:places-sidebar)
    { * }

#
# RadioButton
#
sub gtk_radio_button_new_with_label(GtkWidget $group, Str $label)
    returns GtkWidget
    is native(&gtk-lib)
    is export(:radio-button)
    { * }

sub gtk_radio_button_join_group(GtkWidget $radio-button, GtkWidget $group-source)
    is native(&gtk-lib)
    is export(:radio-button)
    { * }


#
# LinkButton
#
sub gtk_link_button_new_with_label( Str $uri, Str $label )
    returns GtkWidget
    is native(&gtk-lib)
    is export(:link-button)
    { * }

sub gtk_link_button_get_uri(GtkWidget $link-button)
    returns Str
    is native(&gtk-lib)
    is export(:link-button)
    { * }

sub gtk_link_button_set_uri(GtkWidget $link-button, Str $uri)
    is native(&gtk-lib)
    is export(:link-button)
    { * }

sub gtk_link_button_get_visited(GtkWidget $link-button)
    returns Bool
    is native(&gtk-lib)
    is export(:link-button)
    { * }

sub gtk_link_button_set_visited(GtkWidget $link-button, Bool $visited)
    is native(&gtk-lib)
    is export(:link-button)
    { * }

#
# LevelBar
#
sub gtk_level_bar_new()
    is native(&gtk-lib)
    is export(:level-bar)
    returns GtkWidget
    { * }

sub gtk_level_bar_get_inverted(GtkWidget $level-bar)
    returns Bool
    is native(&gtk-lib)
    is export(:level-bar)
    { * }

sub gtk_level_bar_set_inverted(GtkWidget $level-bar, Bool $inverted)
    is native(&gtk-lib)
    is export(:level-bar)
    { * }

sub gtk_level_bar_get_max_value(GtkWidget $level-bar)
    returns num64
    is native(&gtk-lib)
    is export(:level-bar)
    { * }

sub gtk_level_bar_set_max_value(GtkWidget $level-bar, num64 $max-value)
    is native(&gtk-lib)
    is export(:level-bar)
    { * }

sub gtk_level_bar_get_min_value(GtkWidget $GTK_POLICY_AUTOMATIClevel-bar)
    returns num64
    is native(&gtk-lib)
    is export(:level-bar)
    { * }

sub gtk_level_bar_set_min_value(GtkWidget $level-bar, num64 $min-value)
    is native(&gtk-lib)
    is export(:level-bar)
    { * }

sub gtk_level_bar_get_mode(GtkWidget $level-bar)
    returns int32
    is native(&gtk-lib)
    is export(:level-bar)
    { * }

sub gtk_level_bar_set_mode(GtkWidget $level-bar, int32 $mode)
    is native(&gtk-lib)
    is export(:level-bar)
    { * }

sub gtk_level_bar_get_value(GtkWidget $level-bar)
    returns num64
    is native(&gtk-lib)
    is export(:level-bar)
    { * }

sub gtk_level_bar_set_value(GtkWidget $level-bar, num64 $value)
    is native(&gtk-lib)
    is export(:level-bar)
    { * }
#
# Scrolled Window
#
sub gtk_scrolled_window_new()
    returns GtkWidget
    is native(&gtk-lib)
    is export(:scrolled-window)
    { * }
    
sub gtk_scrolled_window_set_policy(GtkWidget $scrolled_window, 
                                  int32 $h-bar-policy, 
                                  int32 $v-bar-policy)
    is native(&gtk-lib)
    is export(:scrolled-window)
    { * }
    
#
# GTK Builder (Glade)
#
class GtkBuilder is repr('CPointer') is export(:builder) { }

# sub gtk_builder_new_from_string(Str $string, int $length) is native(&gtk-lib) returns GtkBuilder { ... }
sub gtk_builder_new_from_file(Str $string)
    returns GtkBuilder
    is native(&gtk-lib)
    is export(:builder)
    { * }

sub gtk_builder_get_object(GtkBuilder $builder, Str $name)
    returns GObject
    is native(&gtk-lib)
    is export(:builder)
    { * }

sub gtk_builder_connect_signals_full( GtkBuilder, &GtkBuilderConnectFunc (
                                                                            GtkBuilder $builder,
                                                                            GObject $object,
                                                                            Str $signal-name,
                                                                            Str $handler-name,
                                                                            GObject $connect-object,
                                                                            int32 $connect-flags,
                                                                            OpaquePointer $user-data
                                                                          ) )
    is native(&gtk-lib)
    is export(:builder)
    { * }
