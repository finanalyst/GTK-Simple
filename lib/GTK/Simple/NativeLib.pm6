
use v6;

unit module GTK::Simple::NativeLib;

use NativeCall;

# On any non-windows machine, this just returns the library name
# for the native calls.
#
# However, on a windows machine, we search @*INC to see if our bundled
# copy of the GTK .dll files are installed. Since they will then no longer
# be in the system $PATH, we need to load each .dll file individually, in
# dependency order. Thus explaining all the 'try load-*' calls below.
#
# Each load-* function just attempts to call a non-existing symbol in the
# .dll we are trying to load. This call will fail, but it has the side effect
# of loading the .dll file, which is all we need.

sub gtk-lib is export {
    state $lib;
    unless $lib {
        if $*VM.config<dll> ~~ /dll/ {
            try load-gdk-lib;
            try load-atk-lib;
            try load-cairo-gobject-lib;
            try load-cairo-lib;
            try load-gdk-pixbuf-lib;
            try load-gio-lib;
            try load-glib-lib;
            try load-gmodule-lib;
            try load-gobject-lib;
            try load-intl-lib;
            try load-pango-lib;
            try load-pangocairo-lib;
            try load-pangowin32-lib;
            $lib = find-bundled('libgtk-3-0.dll');
        } else {
            $lib = $*VM.platform-library-name('gtk-3'.IO).Str;
        }
    }
    $lib
}

sub gdk-lib is export {
    state $lib;
    unless $lib {
        if $*VM.config<dll> ~~ /dll/ {
            try load-cairo-gobject-lib;
            try load-cairo-lib;
            try load-gdk-pixbuf-lib;
            try load-gio-lib;
            try load-glib-lib;
            try load-gobject-lib;
            try load-intl-lib;
            try load-pango-lib;
            try load-pangocairo-lib;
            $lib = find-bundled('libgdk-3-0.dll');
        } else {
            $lib = $*VM.platform-library-name('gdk-3'.IO).Str;
        }
    }
    $lib
}

sub glib-lib is export {
    state $lib;
    unless $lib {
        if $*VM.config<dll> ~~ /dll/ {
            try load-intl-lib;
            $lib = find-bundled('libglib-2.0-0.dll');
        } else {
            $lib = $*VM.platform-library-name('glib-2.0'.IO).Str;
        }
    }
    $lib
}

sub gobject-lib is export {
    state $lib;
    unless $lib {
        if $*VM.config<dll> ~~ /dll/ {
            try load-glib-lib;
            try load-ffi-lib;
            $lib = find-bundled('libgobject-2.0-0.dll');
        } else {
            $lib = $*VM.platform-library-name('gobject-2.0'.IO).Str;
        }
    }
    $lib
}

sub find-bundled($lib is copy) {
    # if we can't find one, assume there's a system install
    my $base = "blib/lib/GTK/$lib";

    if my $file = %?RESOURCES{$base} {
            $file.IO.copy($*SPEC.tmpdir ~ '\\' ~ $lib);
            $lib = $*SPEC.tmpdir ~ '\\' ~ $lib;
    }

    $lib;
}

# windows DLL dependency stuff ...

sub atk-lib {
    state $lib;
    unless $lib {
        $lib = find-bundled('libatk-1.0-0.dll');
    }
    $lib
}
sub cairo-gobject-lib {
    state $lib;
    unless $lib {
        try load-cairo-lib;
        try load-glib-lib;
        try load-gobject-lib;
        $lib = find-bundled('libcairo-gobject-2.dll');
    }
    $lib
}
sub cairo-lib {
    state $lib;
    unless $lib {
        try load-fontconfig-lib;
        try load-freetype-lib;
        try load-pixman-lib;
        try load-png-lib;
        try load-zlib-lib;
        $lib = find-bundled('libcairo-2.dll');
    }
    $lib
}
sub gdk-pixbuf-lib {
    state $lib;
    unless $lib {
        try load-gio-lib;
        try load-glib-lib;
        try load-gmodule-lib;
        try load-gobject-lib;
        try load-intl-lib;
        try load-png-lib;
        $lib = find-bundled('libgdk_pixbuf-2.0-0.dll');
    }
    $lib
}
sub gio-lib {
    state $lib;
    unless $lib {
        try load-glib-lib;
        try load-gmodule-lib;
        try load-gobject-lib;
        try load-intl-lib;
        try load-zlib-lib;
        $lib = find-bundled('libgio-2.0-0.dll');
    }
    $lib
}
sub gmodule-lib {
    state $lib;
    unless $lib {
        $lib = find-bundled('libgmodule-2.0-0.dll');
    }
    $lib
}
sub intl-lib {
    state $lib;
    unless $lib {
        $lib = find-bundled('libintl-8.dll');
    }
    $lib
}
sub pango-lib {
    state $lib;
    unless $lib {
        $lib = find-bundled('libpango-1.0-0.dll');
    }
    $lib
}
sub pangocairo-lib {
    state $lib;
    unless $lib {
        try load-pango-lib;
        try load-pangoft2-lib;
        try load-pangowin32-lib;
        try load-cairo-lib;
        try load-fontconfig-lib;
        try load-freetype-lib;
        try load-glib-lib;
        try load-gobject-lib;
        $lib = find-bundled('libpangocairo-1.0-0.dll');
    }
    $lib
}
sub pangowin32-lib {
    state $lib;
    unless $lib {
        $lib = find-bundled('libpangowin32-1.0-0.dll');
    }
    $lib
}
sub fontconfig-lib {
    state $lib;
    unless $lib {
        try load-freetype-lib;
        try load-xml-lib;
        $lib = find-bundled('libfontconfig-1.dll');
    }
    $lib
}
sub freetype-lib {
    state $lib;
    unless $lib {
        try load-zlib-lib;
        $lib = find-bundled('libfreetype-6.dll');
    }
    $lib
}
sub pixman-lib {
    state $lib;
    unless $lib {
        $lib = find-bundled('libpixman-1-0.dll');
    }
    $lib
}
sub png-lib {
    state $lib;
    unless $lib {
        $lib = find-bundled('libpng15-15.dll');
    }
    $lib
}
sub zlib-lib {
    state $lib;
    unless $lib {
        $lib = find-bundled('zlib1.dll');
    }
    $lib
}
sub xml-lib {
    state $lib;
    unless $lib {
        try load-iconv-lib;
        try load-lzma-lib;
        $lib = find-bundled('libxml2-2.dll');
    }
    $lib
}
sub iconv-lib {
    state $lib;
    unless $lib {
        $lib = find-bundled('libiconv-2.dll');
    }
    $lib
}
sub lzma-lib {
    state $lib;
    unless $lib {
        $lib = find-bundled('liblzma-5.dll');
    }
    $lib
}
sub ffi-lib {
    state $lib;
    unless $lib {
        $lib = find-bundled('libffi-6.dll');
    }
    $lib
}
sub pangoft2-lib {
    state $lib;
    unless $lib {
        $lib = find-bundled('libpangoft2-1.0-0.dll');
    }
    $lib
}

sub load-gdk-lib is native(&gdk-lib) { ... }
sub load-atk-lib is native(&atk-lib) { ... }
sub load-cairo-gobject-lib is native(&cairo-gobject-lib) { ... }
sub load-cairo-lib is native(&cairo-lib) { ... }
sub load-gdk-pixbuf-lib is native(&gdk-pixbuf-lib) { ... }
sub load-gio-lib is native(&gio-lib) { ... }
sub load-glib-lib is native(&glib-lib) { ... }
sub load-gmodule-lib is native(&gmodule-lib) { ... }
sub load-gobject-lib is native(&gobject-lib) { ... }
sub load-intl-lib is native(&intl-lib) { ... }
sub load-pango-lib is native(&pango-lib) { ... }
sub load-pangocairo-lib is native(&pangocairo-lib) { ... }
sub load-pangowin32-lib is native(&pangowin32-lib) { ... }
sub load-fontconfig-lib is native(&fontconfig-lib) { ... }
sub load-freetype-lib is native(&freetype-lib) { ... }
sub load-pixman-lib is native(&pixman-lib) { ... }
sub load-png-lib is native(&png-lib) { ... }
sub load-zlib-lib is native(&zlib-lib) { ... }
sub load-xml-lib is native(&xml-lib) { ... }
sub load-iconv-lib is native(&iconv-lib) { ... }
sub load-lzma-lib is native(&lzma-lib) { ... }
sub load-ffi-lib is native(&ffi-lib) { ... }
sub load-pangoft2-lib is native(&pangoft2-lib) { ... }
