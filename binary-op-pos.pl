#!/usr/bin/env perl

# If you take the x, y position on the screen, color (x #XOR y) % 3 == 0 red and everything else blue you get ...
# https://fosstodon.org/@BigEatie/109672649890405481

use strict;
use warnings;

use Imager ();
use Math::Fibonacci qw(isfibonacci);
use Math::Prime::Util qw(is_prime);
use OEIS qw(oeis);

my $oeis = shift || 10; # https://en.wikipedia.org/wiki/List_of_integer_sequences
my @oeis = oeis($oeis);

my $modulo = @oeis; # for OEIS processing
#my $modulo = 3;     # 3, 5, etc for simple modulo

my ($x, $y) = (1000, 1000);

my $img = Imager->new(xsize => $x, ysize => $y);

# make a white background
$img->box(
    xmin   => 0,
    ymin   => 0,
    xmax   => $x - 1,
    ymax   => $y - 1,
    filled => 1,
    color  => 'white',
);

# inspect each image position
for my $i (0 .. $x - 1) {
    for my $j (0 .. $y - 1) {
        my $x = ($i ^ $j) % $modulo;
        if (grep { $_ == $x } @oeis) {   # for OEIS processing
#        if (is_prime($i ^ $j)) {         # for prime processing
#        if (isfibonacci($i ^ $j)) {      # for fibonacci processing
#        if ($x == 0) {  # for simple modulo
            $img->setpixel(x => $i, y => $j, color => 'black');
        }
    }
}

$img->write(type => 'png', file => "$0.png")
    or die("Can't save $0.png: ", $img->errstr);
