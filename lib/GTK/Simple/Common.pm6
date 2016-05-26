
use v6;

unit module GTK::Simple::Common;

use GTK::Simple::PropertyFacade;

# the actual trait, not exported as it is of marginal use outside
multi sub trait_mod:<is> (Method $m, :@gtk-property! (&getter, &setter, &before?, &after?) ) is export {
    $m does GTK::Simple::PropertyFacade[&getter, &setter, &before, &after];
}
