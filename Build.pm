
use v6;
use NativeCall;
use LWP::Simple;
use Shell::Command;

# test sub for system library
sub test() is native('libgtk-3-0.dll') { * }

unit class Build;
method build($workdir) {
    my $need-copy = False;

    # we only have .dll files bundled. Non-windows is assumed to have gtk already
    if $*DISTRO.is-win {
        test();
        CATCH {
            default {
                $need-copy = True if $_.payload ~~ m:s/Cannot locate/;
            }
        }
    }

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

    if $need-copy {
        # to avoid a dependency (and because Digest::SHA is too slow), we do a hacked up powershell hash
        # this should work all the way back to powershell v1
        my &ps-hash = -> $path {
            my $fn = 'function get-sha256 { param($file);[system.bitconverter]::tostring([System.Security.Cryptography.sha256]::create().computehash([system.io.file]::openread((resolve-path $file)))) -replace \"-\",\"\" } ';
            my $out = qqx/powershell -noprofile -Command "$fn get-sha256 $path"/;
            $out.lines.grep({$_.chars})[*-1];
        }
        say 'No system gtk library detected. Installing bundled version.';
        my $basedir = $workdir ~ '\resources\blib\lib\GTK';
        mkdir($basedir);
        my @hashes = ("1FF7464EDA0C7EC9B87D23A075F7486C13D74C02A3B5D83A267AD091424185D9",
                      "E127BF5D01CD9B2F82501E4AD8F867CE9310CE16A33CB71D5ED3F5AB906FD318",
                      "E963528E4B33A56DE4B6DB491394E56301E5BFA72E592FD39274143FB45DBD80",
                      "357A298222CE4C3540B4E99AD2547B634360808206E5E06214C7DD3135BE6CA8",
                      "1AC7BC02502D1D798662B3621B43637F33B07424C89E2E808945BD7133694EFA",
                      "7C54CB33D0247E3BB65974CAD1B7205590DF0E99460CF197E37B4CABDE265935",
                      "EE41FB133188717057126AF3021DDCEE3D23D8E262E9BF95F7E4DBD2BAC64E20",
                      "EECA1E63D7F692F147648BB7D738507B4EAAC31C1DD35E7B5E819EFEA3A7AB75",
                      "7DDD4AD2FA2979D612951F165FAD78D79944254AA254D5E366F3AE8B0EFF3B7E",
                      "BC4E7544BD384BB5F87E0C1B6640273922EF0BEE69CE9066C9F808230D80B4D2",
                      "D6BA07F2B392200350417F5B5750526A5F0477833BF2484D9A5AAEACA3777777",
                      "BF1CBC203938684EC93300CFB98F174B03B5165C9B7D8F8D6356CDAC2D2303A7",
                      "20C58683280EF1EE19BE641FF3399426A280923068F8237F9E285191C4AAF755",
                      "954B8740A7CBE3728B136D4F36229C599D1F51534137B16E48E3D7FF9C468FDC",
                      "9D37C194C49F3104F6326226744111886A9BFE7D18D5742C36C66F7418B62824",
                      "CE34910B43D5E4285AECDA0E4F64A1BA06C5D53E484F0B68D219C8D8473332AB",
                      "D24E2037215D5F439DC3180643BC2AF1F16FD03ED7C20B1DE6B5455DE8DD7DF3",
                      "E2B142B4219CF6DE7AECC1AA796B50D541E01BC20AB15330E7BA540FD03D3512",
                      "295FEE9BEF2D8255564B4FEDDE4A56FE993D9921DB7E76105A2913C0CD562A1C",
                      "D348A428FCA283CA30A1CFEE5BA4BD21B460F198DD23B0E26DFB0E06D9A350D8",
                      "A97EBE54ED31ED7D8A8317D831878CE82F3B94FE1E5A7466B78D0F0C90863302",
                      "40F6EDE85DB0A1E2F4BA67693B7DC8B74AFFBFAB3B92B99F6B2CEFACBBF7FF6D",
                      "4F1032F0D7F6F0C2046A96884FD48EC0F7C0A1E22C85E9076057756C4C48E0CB",
                      "5A697F89758B407EE85BAD35376546A80520E1F3092D07F1BC366A490443FAB5");
        for flat @files Z @hashes -> $f, $h {
            say "Fetching  $f";
            my $blob = LWP::Simple.get("http://gtk-dlls.p6c.org/$f");
            say "Writing   $f";
            spurt("$basedir\\$f", $blob);

            say "Verifying $f";
            my $hash = ps-hash("$basedir\\$f");
            if ($hash ne $h) {
                die "Bad download of $f (got: $hash; expected: $h)";
            }
            say "";
        }
    }
    else {
        say 'Found system gtk library.';

        # Workaround: Write empty DLL files on non-windows platforms to stop
        # panda from throwing meta6 not-found errors
        my $basedir = $workdir ~ '/resources/blib/lib/GTK';
        mkdir($basedir);
        for @files -> $f {
            # write empty files for now
            spurt("$basedir/$f", "");
        }
    }
}

# only needed for older versions of panda
method isa($what) {
    return True if $what.^name eq 'Panda::Builder';
    callsame;
}
