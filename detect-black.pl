#!/usr/bin/env perl
use strict;
use warnings;

use Imager;
use Statistics::Frequency;

my ($x, $y) = (50, 50);

my $fontfile = '/Library/Fonts/Arial.ttf';
my $font = Imager::Font->new(file => $fontfile)
    or die "Cannot load $fontfile: ", Imager->errstr;

my %letters;

for my $letter ('A' .. 'Z') {
    my $img = Imager->new(xsize => $x, ysize => $y);

    $img->box(xmin => 0, ymin => 0, xmax => $x - 1, ymax => $y - 1, filled => 1, color => 'white');

    $img->string(
        font  => $font,
        text  => $letter,
        x     => 10,
        y     => 42,
        size  => 50,
        color => 'black',
        aa    => 1,
    );

    my $file = $letter . '.png';

    $img->write(file => $file)
        or die "Cannot write $file: ", $img->errstr;

    $img = Imager->new;
    $img->read(file => $file)
        or die $img->errstr;

    for my $i (0 .. $x - 1) {
        for my $j (0 .. $y - 1) {
            my $color = $img->getpixel(x => $i, y => $j);
            my ($red, $green, $blue, $alpha) = $color->rgba;
            $letters{$letter}++ if $red == 0 && $green == 0 && $blue == 0;
        }
    }
}

my $freq = Statistics::Frequency->new;
$freq->add_data(\%letters);
my %prop = $freq->proportional_frequencies;
for my $key (sort { $prop{$a} <=> $prop{$b} } keys %prop) {
    print "$key => $prop{$key}\n";
}
