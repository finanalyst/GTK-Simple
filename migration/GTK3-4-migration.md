# Migrating from GTK 3 to GTK 4
>
----
## Table of Contents
[Remove deprecated widgets](#remove-deprecated-widgets)  

----
The main [migration source](https://developer.gnome.org/gtk4/unstable/gtk-migrating-3-to-4.html) suggests three stages, changing the GTK3 code to make migration easier, then changing, then steps after the migration.

Steps before Migration [_] Verified not to exist in GTK::Simple [X] GTL::Simple ammended [?] GTK::Simple has problems, or not known for certain

*  [X] Do not use deprecated symbols

*  [_] Enable diagnostic warnings

*  [_] Do not use GTK-specific command line arguments

*  [_] Do not use widget style properties

*  [_] Review your window creation flags

*  [?] Stop using direct access to GdkEvent structs

*  [_] Stop using gdk_pointer_warp()

*  [_] Stop using non-RGBA visuals

*  [?] Stop using GtkBox padding, fill and expand child properties

*  [?] Stop using the state argument of GtkStyleContext getters

*  [?] Stop using gdk_pixbuf_get_from_window() and gdk_cairo_set_source_surface()

*  [?] Stop using GtkWidget event signals

*  [?] Set a proper application ID

*  [?] Stop using gtk_main() and related APIs

*  [?] Reduce the use of gtk_widget_destroy()

*  [?] Reduce the use of generic container APIs

*  [?] Review your use of icon resources

## Remove deprecated widgets


*  GtkSymbolicColor | Symbolic colors

	*  GtkGradient | Gradients

	*  Resource Files | Deprecated routines for handling resource files

*  GtkStyle | Deprecated object that holds style information for widgets

*  GtkHScale | A horizontal slider widget for selecting a value from a range

*  GtkVScale | A vertical slider widget for selecting a value from a range

*  GtkTearoffMenuItem | A menu item used to tear off and reattach its menu

*  GtkColorSelection | Deprecated widget used to select a color

*  GtkColorSelectionDialog | Deprecated dialog box for selecting a color

*  GtkHSV | A “color wheel” widget

*  GtkFontSelection | Deprecated widget for selecting fonts

*  GtkFontSelectionDialog | Deprecated dialog box for selecting fonts

*  GtkHBox | A horizontal container box

*  GtkVBox | A vertical container box

*  GtkHButtonBox | A container for arranging buttons horizontally

*  GtkVButtonBox | A container for arranging buttons vertically

*  GtkHPaned | A container with two panes arranged horizontally

*  GtkVPaned | A container with two panes arranged vertically

*  GtkTable | Pack widgets in regular patterns

*  GtkHSeparator | A horizontal separator

*  GtkVSeparator | A vertical separator

*  GtkHScrollbar | A horizontal scrollbar

*  GtkVScrollbar | A vertical scrollbar

*  GtkUIManager | Constructing menus and toolbars from an XML description

*  GtkActionGroup | A group of actions

*  GtkAction | A deprecated action which can be triggered by a menu or toolbar item

*  GtkToggleAction | An action which can be toggled between two states

*  GtkRadioAction | An action of which only one in a group can be active

*  GtkRecentAction | An action of which represents a list of recently used files

*  GtkActivatable | An interface for activatable widgets

*  GtkImageMenuItem | A deprecated widget for a menu item with an icon

*  GtkMisc | Base class for widgets with alignments and padding

*  Stock Items | Prebuilt common menu/toolbar items and corresponding icons

*  Themeable Stock Images | Manipulating stock icons

*  GtkNumerableIcon | A GIcon that allows numbered emblems

*  GtkArrow | Displays an arrow

*  GtkStatusIcon | Display an icon in the system tray

*  GtkThemingEngine | Theming renderers

*  GtkAlignment | A widget which controls the alignment and size of its child






----
Rendered from migration/GTK3-4-migration at 2020-12-26T00:33:45Z