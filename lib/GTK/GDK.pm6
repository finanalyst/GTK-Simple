my Str $gtklib;
my Str $gdklib;
BEGIN {
    if $*VM.config<dll> ~~ /dll/ {
        $gtklib = 'libgtk-3-0';
        $gdklib = 'libgdk-3-0';
    } else {
        $gtklib = 'libgtk-3';
        $gdklib = 'libgdk-3';
    }
}
use NativeCall;

class GdkWindow is repr('CPointer') { }

enum EVENT_MASK (
  EXPOSURE_MASK => 2,
  POINTER_MOTION_MASK => 4,
  POINTER_MOTION_HINT_MASK => 8,
  BUTTON_MOTION_MASK => 16,
  BUTTON1_MOTION_MASK => 32,
  BUTTON2_MOTION_MASK => 64,
  BUTTON3_MOTION_MASK => 128,
  BUTTON_PRESS_MASK => 256,
  BUTTON_RELEASE_MASK => 512,
  KEY_PRESS_MASK => 1024,
  KEY_RELEASE_MASK => 2048,
  ENTER_NOTIFY_MASK => 4096,
  LEAVE_NOTIFY_MASK => 8192,
  FOCUS_CHANGE_MASK => 16384,
  STRUCTURE_MASK => 32768,
  PROPERTY_CHANGE_MASK => 65536,
  VISIBILITY_NOTIFY_MASK => 131072,
  PROXIMITY_IN_MASK => 262144,
  PROXIMITY_OUT_MASK => 524288,
  SUBSTRUCTURE_MASK => 1048576,
  SCROLL_MASK => 2097152,
  ALL_EVENTS_MASK => 4194302,
);

constant carrayuint16 := CArray[uint16];

sub gtk_widget_get_window(OpaquePointer $window)
    returns GdkWindow
    is native($gtklib)
    is export
    {*}

sub gdk_window_get_events(GdkWindow $window)
    returns int
    is native($gdklib)
    is export
    {*}

sub gdk_window_set_events(GdkWindow $window, int $eventmask)
    is native($gdklib)
    is export
    {*}

# GdkEvent datastructure access {{{

class GdkEvent is repr('CPointer') { ... }

sub gdk_event_get_keycode(GdkEvent $event, carrayuint16 $keycode)
    is native($gdklib)
    {*}

sub gdk_event_get_keyval(GdkEvent $event, carrayuint16 $keycode)
    is native($gdklib)
    {*}

class GdkEvent is repr('CPointer') {
    method keycode {
        my carrayuint16 $tgt .= new;
        $tgt[0] = 0;
        gdk_event_get_keycode(self, $tgt);
        $tgt[0]
    }

    method keyval {
        my carrayuint16 $tgt .= new;
        $tgt[0] = 0;
        gdk_event_get_keyval(self, $tgt);
        $tgt[0]
    }
}

# GdkEvent datastructure access }}}

# vi: foldmethod=marker
