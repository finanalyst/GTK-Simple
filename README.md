![badge](https://github.com/finanalyst/GTK-Simple/actions/workflows/test.yaml/badge.svg)
## GTK::Simple 

GTK::Simple is a set of simple [GTK 3](http://www.gtk.org/) bindings using
NativeCall. Only some GTK widgets are currently implemented. However, these are
enough to create a reasonable interactive GUI for an idiomatic Raku program.
The GTK Widgets in this distribution include the following:

Widget            | Description
----------------- | -------------------------------------------------------------------
ActionBar         | Group multiple buttons and arrange in 'left', 'middle', and 'right'
Button            | A simple button with a label and a callback
Calendar          | A calendar for selecting a date
CheckButton       | A check button with a label
CheckMenuItem     | A checkable menu item
ComboBoxText      | A simple combo box
DrawingArea       | A drawing area (requires the 'Cairo' module)
Entry             | Allows for text to be provided by the user
FileChooserButton | A button that opens a file chooser dialog
Frame             | A bin with a decorative frame and optional label
Grid              | A table-like container for widgets for window design
Label             | Adds a line of text
LevelBar          | A bar that can used as a level indicator
LinkButton        | Create buttons bound to a URL
ListBox           | A vertical listbox where each row is selectable
MarkUpLabel       | Adds text with GTK mark up (e.g. color and font manipulation)
Menu              | A simple menu with a menu item label
MenuBar           | A simple menu bar that contain one or more menus
MenuItem          | A simple menu item that can have a sub menu
MenuToolButton    | A menu tool button with a label or an icon
PlacesSidebar     | Sidebar that displays frequently-used places in the file system
ProgressBar       | Show progress via a filling bar
Scale             | Allows for a number to be provided by the user
ScrolledWindow    | Container for widgets needing scrolling, eg., multiline texts
RadioButton       | A choice from multiple radio buttons
Spinner           | Showing that something is happening
TextView          | Adds multiple lines of text
ToggleButton      | A toggle-able button
Toolbar           | A tool bar that can contain one or more menu tool buttons
VBox, HBox        | Widget containers which enable window layout design

## Example

```raku
use GTK::Simple;
use GTK::Simple::App;

my $app = GTK::Simple::App.new( title => "Hello GTK!" );

$app.set-content(
    GTK::Simple::VBox.new(
        my $button = GTK::Simple::Button.new(label => "Hello World!"),
        my $second = GTK::Simple::Button.new(label => "Goodbye!")
    )
);

$app.border-width = 20;
$second.sensitive = False;
$button.clicked.tap({ .sensitive = False; $second.sensitive = True });
$second.clicked.tap({ $app.exit; });
$app.run;
```

The first four examples were written as mini tutorials to show how the
system works:
- [Hello world](https://github.com/finanalyst/GTK-Simple/blob/master/examples/01-hello-world.raku)
- [Toggles](https://github.com/finanalyst/GTK-Simple/blob/master/examples/02-toggles.raku)
- [A simple grid](https://github.com/finanalyst/GTK-Simple/blob/master/examples/03-grid.raku)
- [Marked Scales](https://github.com/finanalyst/GTK-Simple/blob/master/examples/04-marked-scale.raku)

For more examples, please see the [`examples/`](https://github.com/finanalyst/GTK-Simple/blob/master/examples) folder.

## Limitations

The full functionality of [GTK 3](http://www.gtk.org/) is not available in
this module.

## Prerequisites

This module requires the GTK3 library to be installed. Please follow the
instructions below based on your platform:

### Debian Linux

```
sudo apt-get install libgtk-3-dev
```

### Mac OS X

```
brew update
brew install gtk+3
```

## Windows

The GTK team describes how to do this for Windows at
[Setting up GTK for Window](https://www.gtk.org/docs/installations/windows/)

## Installation and sanity tests

Use the zef package manager

```
$ zef install GTK::Simple
```

## Author

Jonathan Worthington, jnthn on #raku, https://github.com/jnthn/

## Contributors

The Raku team

## License

The Artistic License 2.0
