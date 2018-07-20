use strict;
use warnings;

use Cpanel::JSON::XS qw( decode_json );
use Data::Printer;    # exports p()
use WWW::Mechanize::Cached ();

my $ua = WWW::Mechanize::Cached->new;

$ua->get('http://api.cpantesters.org/v3/summary/lazy/0.000006');

my $reports = decode_json( $ua->content );

my %agg;
my %agg_reports;

for my $r ( @{$reports} ) {
    push @{ $agg{ $r->{reporter} }->{ $r->{grade} } },
        $r->{guid};
    push @{ $agg_reports{ $r->{reporter} }->{ $r->{grade} } },
        $r;
}

p(%agg);

my %sigs;

sigs('pass');
sigs('fail');

for my $type ( 'pass', 'fail' ) {
    sigs($type);
    $sigs{$type} = [ sort @{ $sigs{$type} } ];
}

p %sigs;

sub sigs {
    my $type = shift;
    for my $r (
        @{
            $agg_reports{'"Chris Williams (BINGOS)" <chris@bingosnet.co.uk>'}
                ->{$type}
        }
    ) {
        my $sig = join "\t", $r->{osname}, $r->{osvers}, $r->{perl},
            $r->{platform};
        push @{ $sigs{$type} }, $sig;
    }
}
