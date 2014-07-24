package ParallelPi;

use strict;
use warnings;

#use Config::Tiny;
#use File::Basename qw(basename);

#use FindBin;
#use lib "$FindBin::Bin/lib";
use ParallelPi::BsF qw( digits );

use Exporter;
our @ISA = qw( Exporter );
our @EXPORT_OK = qw( digit );

#our $Config;
#our $appname = basename($0);

sub digit {
    return substr digits( shift ), 0, 1;
}

1;
