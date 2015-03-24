use Panda::Builder;

use Shell::Command;
use LWP::Simple;
use NativeCall;

# test sub for system library
our sub zlibVersion() returns Str is encoded('ascii') is native('zlib1.dll') is export { * }

class Build is Panda::Builder {
    method build($workdir) {
        my $need-copy = False;

        # we only have .dll files bundled. Non-windows is assumed to have openssl already
        if $*DISTRO.is-win {
            #zlibVersion();
            #CATCH {
            #    default {
                    $need-copy = True;
            #    }
            #}
        }

        if $need-copy {
            say 'No system gtk library detected. Installing bundled version.';
            mkdir($workdir ~ '\blib\lib\GTK');
            my @files = ("libatk-1.0-0.dll",
                         "libcairo-2.dll",
                         "libcairo-gobject-2.dll",
                         "libffi-6.dll",
                         "libfontconfig-1.dll",
                         "libfreetype-6.dll",
                         "libgdk-3-0.dll",
                         "libgdk_pixbuf-2.0-0.dll",
                         "libgio-2.0-0.dll",
                         "libglib-2.0-0.dll",
                         "libgmodule-2.0-0.dll",
                         "libgobject-2.0-0.dll",
                         "libgtk-3-0.dll",
                         "libiconv-2.dll",
                         "libintl-8.dll",
                         "liblzma-5.dll",
                         "libpango-1.0-0.dll",
                         "libpangocairo-1.0-0.dll",
                         "libpangoft2-1.0-0.dll",
                         "libpangowin32-1.0-0.dll",
                         "libpixman-1-0.dll",
                         "libpng15-15.dll",
                         "libxml2-2.dll",
                         "zlib1.dll");
            for @files {
                my $blob = LWP::Simple.get('http://url/goes/here/' ~ $_);
                spurt($workdir ~ '\blib\lib\GTK\\' ~ $_, $blob);
            }
        }
        else {
            say 'Found system gtk library.';
        }
    }
}
