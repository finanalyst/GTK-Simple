
use v6;

use GTK::Simple::Raw;

unit class GTK::Simple::ConnectionHandler;

has $.instance;
has $.handler;
has $.connected = True;

method disconnect {
    if $.connected {
        g_signal_handler_disconnect($.instance, $.handler);
        $!connected = False;
    }
}
