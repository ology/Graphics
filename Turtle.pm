package Turtle;

use Moo;
use Readonly;

Readonly my $K => 3.14159265358979323846 / 180;

has height => (
    is => 'ro',
    default => sub { 500 },
);
has width => (
    is => 'ro',
    default => sub { 500 },
);
has x => (
    is => 'rw',
    lazy => 1,
    builder => \&_init_x,
);
has y => (
    is => 'rw',
    lazy => 1,
    builder => \&_init_y,
);
has orient => (
    is => 'rw',
    builder => \&_init_orient,
);
has status => (
    is => 'rw',
    default => sub { 1 }, # Pen down
);
has color => (
    is => 'rw',
    default => sub { 'black' },
);
has line_width => (
    is => 'rw',
    default => sub { 1 },
);

sub _init_x {
    my $self = shift;
    return $self->width / 2;
}

sub _init_y {
    my $self = shift;
    return $self->height / 2;
}

sub _init_orient {
    my $self = shift;
    return -90 % 360;
}

sub home {
    my $self = shift;
    $self->x( $self->_init_x );
    $self->y( $self->_init_y );
    $self->orient( $self->_init_orient );
}

sub raise {
    my $self = shift;          
    $self->status(0);
}

sub lower {
    my $self = shift;          
    $self->status(1);
}

sub turn {
    my $self = shift;
    my $degrees = shift // 0;
    $self->orient( ( $self->orient + $degrees ) % 360 );
}

sub right {
    my $self = shift;
    $self->turn(@_);
}

sub left {
    my $self = shift;
    my $degrees = shift // 0;
    $self->orient( ( $self->orient - $degrees ) % 360 );
}

sub where {
    my $self = shift;
    return $self->x, $self->y;
}

sub get_state {
    my $self = shift;
    return
        $self->x,
        $self->y,
        $self->orient,
        $self->status,
        $self->color,
        $self->line_width;
}

sub set_state {
    my $self = shift;
    my ( $x, $y, $orient, $status, $color, $line_width ) = @_;
    $self->x($x);
    $self->y($y);
    $self->orient($orient);
    $self->status($status);
    $self->color($color);
    $self->line_width($line_width);
}

sub forward {
    my $self = shift;
    my $step = shift // 1;

    my $x = $step * cos( $self->orient * $K );
    my $y = $step * sin( $self->orient * $K );

    my $xo = $self->x;
    my $yo = $self->y;

    $self->x( $x + $xo );
    $self->y( $y + $yo );

    if ( $self->status == 1 ) {
        return
            int($xo), int($yo),
            int($self->x), int($self->y),
            $self->color, $self->line_width;
    }
}

sub backward {
    my $self = shift;
    my $step = shift;
    $self->forward( - $step )
}

sub mirror {
    my $self = shift;
    $self->orient( $self->orient * -1 );
}

1;
__END__
perl -Ilib -MData::Dumper -MTurtle -E'$t=Turtle->new;say Dumper $t->backward(2)'
