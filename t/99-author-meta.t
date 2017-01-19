
use v6;

use Test;

plan 1;

if ?%*ENV<AUTHOR_TESTING> {
    require Test::META <&meta-ok>;
    meta-ok;
    done-testing;
} else {
    skip-rest "Skipping author test";
    exit;
}
