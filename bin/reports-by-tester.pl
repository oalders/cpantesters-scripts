use strict;
use warnings;

use Cpanel::JSON::XS qw( decode_json );
use Data::Printer;    # exports p()
use WWW::Mechanize::Cached ();

my $ua = WWW::Mechanize::Cached->new;

$ua->get('http://api.cpantesters.org/v3/summary/lazy/0.000006');

my $reports = decode_json( $ua->content );

my %agg;

for my $r ( @{$reports} ) {
    push @{ $agg{ $r->{reporter} }->{ $r->{grade} } },
        $r->{guid};
}

p(%agg);
