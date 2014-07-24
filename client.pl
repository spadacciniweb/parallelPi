use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use ParallelPi qw ( digit );

my $version = 0.1;

$| = 1;
my $until = 100;
my $step = 5;

my $i = 0;
my $pi = '3.';

do {
    $i++;
    my $risp = digit( $i );
    $pi .= $1
        if $risp =~ /^(\d)$/;
    printf "\r $i/$until %3.1f%%", $i/$until*100
        unless $until % $step;
} while $i < $until;
print "\n";

#open FH, '>pi.txt' or die ("Errore nell'apertura file: $!");
#print FH $pi;
#close FH;
print $pi;

exit 0;
