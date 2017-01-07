#!/usr/bin/env perl6

use v6;
use lib 'lib';
use GTK::Simple;
use GTK::Simple::App;

=comment
    Using C<GTK::Simple> allows you to get a U<single window> for your app
    by creating a B<GTK::Simple::App>.

my GTK::Simple::App $app .= new(title => "Hello GTK!");


=begin comment
    Anything that does the C<GTK::Simple::Container> role, like
    C<GTK::Simple::App> for example, lets you use B<set_content>
    to put widgets into its body.

    In other GTK tutorials, you'll find that you have to C<gtk_widget_show>
    all widgets as well as the window. set-content does all of that for us.
=end comment

$app.set-content(
    GTK::Simple::VBox.new(
        my $button = GTK::Simple::Button.new(label => "Hello World!"),
        my $second = GTK::Simple::Button.new(label => "Goodbye!")
    )
);

=comment
    Note the use of U<in-line declarations> of local variables for the Buttons.
    This lets us refer to the buttons again later on, but not have to refer to
    them twice in a row.


=comment
    Setting the C<border-width> of any C<GTK::Simple::Container> adds
    a B<border around the container>.
    C<border-width> on a window, however, is special-cased to put
    a border U<inside> the window instead.

$app.border-width = 20;


=comment
    Using the sensitive property we can make a button unclickable.

$second.sensitive = False;


=begin comment
    The B<clicked> member exposes activation events as a C<Supply> that we
    can tap. That C<Supply> will C<more> the Button object every time the
    button is activated.

    Therefore we can set the button that was just clicked inactive with
    just C<.sensitive = 0>. The C<$second> button can then be activated.
=end comment

$button.clicked.tap({ .sensitive = False; $second.sensitive = True });


=comment
    Clicking the second button shall C<exit> the application's main loop.

$second.clicked.tap({ $app.exit; });


=comment
    Finally, we enter the main loop of the application.

$app.run;
