
use v6;

# This is almost a copy of that in AccessorFacade, adjusted to operate
# on Widget objects.
unit role GTK::Simple::PropertyFacade[&get, &set, &before?, &after?];

method CALL-ME(*@args) is rw {
    my $self = @args[0];
    Proxy.new(
        FETCH   => sub ($) {
            my $val =  &get($self.WIDGET);
            my $ret-type = self.signature.returns;
            if not $ret-type =:= Mu {
                if $val !~~ $ret-type {
                    try {
                        $val = $ret-type($val);
                    }
                }
            }
            $val;
       },
       STORE   =>  sub ($, $val is copy ) {
            my $store-val;
            if &before.defined {
                $store-val = &before($self, $val);
            }
            else {
                $store-val = $val.value;
                CATCH {
                    default {
                        $store-val = $val;
                    }
                }
            }
            my $rc = &set($self.WIDGET, $store-val);
            if &after.defined {
                &after($self, $rc);
            }
        }
    );
}
