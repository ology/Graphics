#!/usr/bin/env perl
use strict;
use warnings;

use Imager;
use Statistics::Frequency;

my ($x, $y) = (50, 50);

my $fontfile = '/opt/X11/share/fonts/TTF/VeraMono.ttf';
my $font = Imager::Font->new(file => $fontfile)
    or die "Cannot load $fontfile: ", Imager->errstr;

my %letters;

for my $letter ('A' .. 'Z') {
    my $img = Imager->new(xsize => $x, ysize => $y);

    $img->box(xmin => 0, ymin => 0, xmax => $x - 1, ymax => $y - 1, filled => 1, color => 'white');

    $font->align(
        string => $letter,
        size   => 50,
        color  => 'black',
        x      => $img->getwidth / 2,
        y      => $img->getheight / 2,
        halign => 'center',
        valign => 'center',
        image  => $img,
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
