## GTK::Simple [![Build Status](https://travis-ci.org/perl6/gtk-simple.svg?branch=master)](https://travis-ci.org/perl6/gtk-simple)

GTK::Simple is a set of simple GTK 3 bindings using NativeCall.

Only a few GTK widgets are implemented, but enough to create a reasonable interactive GUI for a perl6 program using perl6 idioms.

Widgets are gradually being added. Basic widgets include:
* Button       [ simple button with a label and a callback ]
* ComboBoxText [ a simple ComboBox. ]
* Entry        [ allows for text to be provided by the user ]
* Grid         [ A table-like container for widgets for window design ]
* Label        [ adds a line of text ]
* MarkUpLabel  [ adds text with GTK mark up, eg. color and font manipulation ]
* Scale        [ allows for a number to be provided by the user ]
* Spinner      [ showing something is happening ]
* TextView     [ adds multiple lines of text ]
* VBox/HBox    [ Containers for widgets, thus enabling design of the window ]

The first three or four examples were written as minitutorials to show how the system works.

The following are some lines from the first example:
```
use v6;
use lib 'lib';
use GTK::Simple;

=comment
    Using C<GTK::Simple> allows you to get a U<single window> for your app
    by creating a B<GTK::Simple::App>.

my GTK::Simple::App $app .= new(title => "Hello GTK!");


=begin comment
    Anything that does the C<GTK::Simple::Container> role, like
    C<GTK::Simple::App> for example, lets you use B<set_content>
    to put widgets into its body.

    In other GTK tutorials, you'll find that you have to C<gtk_widget_show>
    all widgets as well as the window. set_content does all of that for us.
=end comment

$app.set-content(
    GTK::Simple::VBox.new(
        my $button = GTK::Simple::Button.new(label => "Hello World!"),
        my $second = GTK::Simple::Button.new(label => "Goodbye!")
    )
);
```

## Limitations

The full functionality of GTK 3 is not accessed in this module.

## Installation

This modules requires GTK3 library to be installed.

To install it on Debian Linux:
```
sudo apt-get install libgtk-3-dev
```
