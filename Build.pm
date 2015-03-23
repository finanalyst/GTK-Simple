use Panda::Builder;

use Shell::Command;
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
            for dir($workdir ~ '\native-lib\\') {
                cp($_, $workdir ~ '\blib\lib\GTK\\'~$_.basename);
            }
        }
        else {
            say 'Found system gtk library.';
        }
    }
}
