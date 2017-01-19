## GTK::Simple [![Build Status](https://travis-ci.org/perl6/gtk-simple.svg?branch=master)](https://travis-ci.org/perl6/gtk-simple) [![Build status](https://ci.appveyor.com/api/projects/status/github/azawawi/gtk-simple?svg=true)](https://ci.appveyor.com/project/azawawi/gtk-simple/branch/master)

GTK::Simple is a set of simple [GTK 3](http://www.gtk.org/) bindings using
NativeCall. Only a few GTK widgets are currently implemented. However, these are
enough to create a reasonable interactive GUI for an idiomatic Perl 6 program.
Widgets are gradually being added. These include the following:

Widget            | Description
----------------- | ---------------------------------------------------------------
Button            | A simple button with a label and a callback
ComboBoxText      | A simple combo box
Entry             | Allows for text to be provided by the user
FileChooserButton | A button that opens a file chooser dialog
Frame             | A bin with a decorative frame and optional label
Grid              | A table-like container for widgets for window design
Label             | Adds a line of text
LevelBar          | A bar that can used as a level indicator
LinkButton        | Create buttons bound to a URL
MarkUpLabel       | Adds text with GTK mark up (e.g. color and font manipulation)
Menu              | A simple menu with a menu item label
MenuBar           | A simple menu bar that contain one or more menus
MenuItem          | A simple menu item that can have a sub menu
MenuToolButton    | A menu tool button with a label or an icon
PlacesSidebar     | Sidebar that displays frequently-used places in the file system
Scale             | Allows for a number to be provided by the user
ScrolledWindow    | Container for widgets needing scrolling, eg., multiline texts
RadioButton       | A choice from multiple check buttons
Spinner           | Showing that something is happening
TextView          | Adds multiple lines of text
Toolbar           | A tool bar that can contain one or more menu tool buttons
VBox, HBox        | Widget containers which enable window layout design

## Example

```perl6
use v6.c;
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

The first three or four examples were written as mini tutorials to show how the
system works. For more examples, please see the [examples](examples) folder.

## Limitations

The full functionality of [GTK 3](http://www.gtk.org/) is not accessed in
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

Precompiled GTK3 DLLs are installed automatically with module installation.

## Installation

To install it using [zef](https://github.com/ugexe/zef) (a module management
tool bundled with Rakudo Star):

```
$ zef install GTK::Simple
```

## Testing

- To run tests:
```
$ prove -e "perl6 -Ilib"
```

- To run all tests including author tests (Please make sure
[Test::Meta](https://github.com/jonathanstowe/Test-META) is installed):
```
$ zef install Test::META
$ AUTHOR_TESTING=1 prove -e "perl6 -Ilib"
```

## Author

Jonathan Worthington, jnthn on #perl6, https://github.com/jnthn/

## Contributors

The Perl 6 team

## License

The Artistic License 2.0
