package ParallelPi::BsF;

=head
    Computation of the n'th decimal digit of \pi with very little memory.
    Written by Fabrice Bellard on January 8, 1997.
    
    We use a slightly modified version of the method described by Simon
    Plouffe in "On the Computation of the n'th decimal digit of various
    transcendental numbers" (November 1996). We have modified the algorithm
    to get a running time of O(n^2) instead of O(n^3log(n)^3).
    
    This program uses mostly integer arithmetic. It may be slow on some
    hardwares where integer multiplications and divisons must be done
    by software. We have supposed that 'int' has a size of 32 bits. If
    your compiler supports 'long long' integers of 64 bits, you may use
    the integer version of 'mul_mod' (see HAS_LONG_LONG).

    Rewrited in Perlish by Mariano Spadaccini
=cut

use strict;
use warnings;
use POSIX qw/ fmod /;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw( digits );

sub mul_mod {
    my ($a, $b, $m) = @_;
    return ( $a * $b ) % $m;
}

sub inv_mod {
	my ($x, $y) = @_;
	my $u = $x;
	my $v = $y;
	my $c = 1;
	my $a = 0;
    do {
	    my $q = int $v / $u;
	    my $t = $c;
		$c = $a - $q * $c;
		$a = $t;
		$t = $u;
		$u = $v - $q * $u;
		$v = $t;
	} while $u != 0;
	$a %= $y;
	$a += $y
        if $a < 0;
	return $a;
}

sub pow_mod {
    my ($a, $b, $m) = @_;
	my $r = 1;
	my $aa = $a;
	while (1) {
		$r = mul_mod( $r, $aa, $m )
	        if ($b & 1);
	    $b = $b >> 1;
	    last unless $b;
	    $aa = mul_mod( $aa, $aa, $m);
	}
	return $r;
}

sub is_prime {
    my $n = shift;
    return 0
        unless $n % 2;

	my $r = int sqrt( $n );
	for ( my $i = 3; $i <= $r; $i += 2) {
        return 0
            unless $n % $i;
    }
    return 1;
}

sub next_prime {
    my $n = shift;
	do {
	    $n++;
	} while !is_prime( $n );
	return $n;
}

sub digits {
    my $n = shift;

    my $N = int ( ($n + 20) * log(10) / log(2));
    my $sum = 0;
    for ($a = 3; $a <= 2*$N ; $a = next_prime($a) ) {
    	my $vmax = int (log(2 * $N) / log($a));
    	my $av = 1;
    	for (my $i = 0; $i < $vmax; $i++) {
    		$av *= $a;
        }
        my $s = 0;
    	my $num = 1;
    	my $den = 1;
    	my $v = 0;
    	my $kq = 1;
    	my $kq2 = 1;
        my $t;
    
    	for (my $k = 1; $k <= $N; $k++) {
    		$t = $k;
    		if ($kq >= $a) {
    		    do {
    			    $t /= $a;
        			$v--;
    	    	} while ($t % $a) == 0;
    		    $kq = 0;
    		}
    		$kq++;
    		$num = mul_mod( $num, $t, $av );
    
    		$t = (2 * $k - 1);
    		if ($kq2 >= $a) {
        		if ($kq2 == $a) {
    			    do {
    	    		    $t /= $a;
    			        $v++;
    			    } while ($t % $a) == 0;
    		    }
    		    $kq2 -= $a;
    		}
    		$den = mul_mod( $den, $t, $av);
            #printf "den: %i\n",$den;
    
    		$kq2 += 2;
    
    		if ( $v > 0) {
    		    $t = inv_mod( $den, $av );
    		    $t = mul_mod( $t, $num, $av);
    		    $t = mul_mod( $t, $k, $av);
    		    for (my $i = $v; $i < $vmax; $i++) {
    			    $t = mul_mod( $t, $a, $av);
                }
    		    $s += $t;
    			$s -= $av
    		        if $s >= $av ;
    		}
    	}
    
    	$t = pow_mod( 10, $n-1, $av);
    	$s = mul_mod( $s, $t, $av);
    	$sum = fmod( $sum + $s / $av, 1.0);
    }
    #return sprintf "Decimal digits of pi at position %d: %09d", $n,
    return sprintf "%09d", int ($sum * 1e9 );
}

1;
