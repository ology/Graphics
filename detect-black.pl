#!/usr/bin/env perl

# Write-up: http://techn.ology.net/how-much-ink-is-used-for-each-letter/

use strict;
use warnings;

use Imager;
use Statistics::Frequency;

my $file = '/Library/Fonts/Arial.ttf';
my $font = Imager::Font->new(file => $file)
    or die "Cannot load $file: ", Imager->errstr;

my ($x, $y) = (50, 50);

my %letters;

for my $letter ('A' .. 'Z') {
    # Create a new, white canvas
    my $img = Imager->new(xsize => $x, ysize => $y);

    $img->box(
        xmin   => 0,
        ymin   => 0,
        xmax   => $x - 1,
        ymax   => $y - 1,
        filled => 1,
        color  => 'white',
    );

    # Add our letter
    $img->string(
        font  => $font,
        text  => $letter,
        x     => 10,
        y     => 42,
        size  => 50,
        color => 'black',
        aa    => 1,
    );

    # Detect the black pixels
    for my $i (0 .. $x - 1) {
        for my $j (0 .. $y - 1) {
            my $color = $img->getpixel(x => $i, y => $j);
            my ($red, $green, $blue) = $color->rgba;
            $letters{$letter}++
                if $red == 0 && $green == 0 && $blue == 0;
        }
    }
}

my $freq = Statistics::Frequency->new;
$freq->add_data(\%letters);
my %prop = $freq->proportional_frequencies;
for my $key (sort { $prop{$a} <=> $prop{$b} } keys %prop) {
    print "$key, $prop{$key}\n";
}

__END__
$ perl detect-black.pl > /Users/gene/tmp/data.txt
R> data <- read.csv('/Users/gene/tmp/data.txt', header=F)
R> l <- seq(1, 26, 1)
R> plot(data$V2, type='l', main='Ink Used For Each Letter', xlab='Sorted Letters', ylab='Ink Used', xaxt="n")
R> for(i in l) axis(1, at=i, labels=data$V1[i], cex.axis = 1)