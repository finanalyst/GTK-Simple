## GTK::Simple [![Build Status](https://travis-ci.org/perl6/gtk-simple.svg?branch=master)](https://travis-ci.org/perl6/gtk-simple) [![Build status](https://ci.appveyor.com/api/projects/status/github/perl6/gtk-simple?svg=true)](https://ci.appveyor.com/project/perl6/gtk-simple/branch/master)

GTK::Simple is a set of simple [GTK 3](http://www.gtk.org/) bindings using
NativeCall.

Only a few GTK widgets are implemented, but enough to create a reasonable interactive GUI for a perl6 program using perl6 idioms.

Widgets are gradually being added. Basic widgets include:

Widget       | Description
------------ | ---------------------------------------------------------------
Button       | a simple button with a label and a callback
ComboBoxText | a simple combo box
Entry        | allows for text to be provided by the user
Grid         | a table-like container for widgets for window design
Label        | adds a line of text
MarkUpLabel  | adds text with GTK mark up (e.g. color and font manipulation)
Scale        | allows for a number to be provided by the user
Spinner      | showing something is happening
TextView     | adds multiple lines of text
VBox, HBox   | widget containers which enable window layout design

## Example

```Perl6
use v6;
use GTK::Simple;

my $app = GTK::Simple::App.new(title => "Hello GTK!");

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

To install it using Panda (a module management tool bundled with Rakudo Star):

```
$ panda update
$ panda install GTK::Simple
```

## Testing

To run tests:

```
$ prove -e "perl6 -Ilib"
```

## Author

Jonathan Worthington, jnthn on #perl6, https://github.com/jnthn/

## Contributors

The Perl 6 team

## License

The Artistic License 2.0
