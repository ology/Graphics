package Turtle;

use Moo;

use constant K => 3.14159265358979323846 / 180;

=head1 NAME

Turtle - Basic Turtle Movement and State Operations

=head1 SYNOPSIS

  use Turtle;
  my $turtle = Turtle->new;
  $turtle->pen_up;
  $turtle->turn(45);
  $turtle->forward(10);
  $turtle->pen_down;
  for my $i ( 1 .. 4 ) {
      $turtle->forward(50);
      $turtle->right(90);
  }
  $turtle->pen_up;
  $turtle->goto( 10, 10 );
  $turtle->mirror;
  $turtle->backward(10);
  my @state = $turtle->get_state;
  $turtle->set_state( $x, $y, $heading, $status, $pen_color, $pen_size );

=head1 DESCRIPTION

This module enables basic turtle movement and state operations without requiring
any particular graphics package.

The methods don't draw anything per se.  They output coordinates and values for
line drawing by your favorite graphics package.

=head1 ATTRIBUTES

=head2 x, y, heading

Coordinate parameters.

=cut

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
has heading => (
    is => 'rw',
    builder => \&_init_heading,
);

=head2 status

Is the pen is up or down?

=cut

has status => (
    is => 'rw',
    default => sub { 1 }, # Pen down
);

=head2 pen_color, pen_size

Pen properties.

=cut

has pen_color => (
    is => 'rw',
    default => sub { 'black' },
);
has pen_size => (
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

sub _init_heading {
    my $self = shift;
    return -90 % 360;
}

=head1 METHODS

=head2 home()

  $turtle->home;

Move the turtle cursor to the starting x,y position and heading.

=cut

sub home {
    my $self = shift;
    $self->x( $self->_init_x );
    $self->y( $self->_init_y );
    $self->heading( $self->_init_heading );
}

=head2 pen_up()

  $turtle->pen_up;

Raise the pen head to stop drawing.

=cut

sub pen_up {
    my $self = shift;          
    $self->status(0);
}

=head2 pen_down()

  $turtle->pen_down;

Lower the pen head to begin drawing.

=cut

sub pen_down {
    my $self = shift;          
    $self->status(1);
}

=head2 turn()

  $turtle->right($degrees);

Set the heading to the given degrees.

=cut

sub turn {
    my $self = shift;
    my $degrees = shift // 0;
    $self->heading( ( $self->heading + $degrees ) % 360 );
}

=head2 right()

  $turtle->right($degrees);

Turn to the right.

=cut

sub right {
    my $self = shift;
    $self->turn(@_);
}

=head2 left()

  $turtle->left($degrees);

Turn to the left.

=cut

sub left {
    my $self = shift;
    my $degrees = shift // 0;
    $self->heading( ( $self->heading - $degrees ) % 360 );
}

=head2 position()

  @pos = $turtle->position;

Return the current pen position as a list of the x and y values.

=cut

sub position {
    my $self = shift;
    return $self->x, $self->y;
}

=head2 get_state()

  @state = $turtle->get_state;

Return the following settings as a list:

 x, y, heading, status, pen_color, pen_size

=cut

sub get_state {
    my $self = shift;
    return
        $self->x,
        $self->y,
        $self->heading,
        $self->status,
        $self->pen_color,
        $self->pen_size;
}

=head2 set_state()

  $turtle->set_state( $x, $y, $heading, $status, $pen_color, $pen_size );

Set the turtle state with the given parameters.

=cut

sub set_state {
    my $self = shift;
    my ( $x, $y, $heading, $status, $pen_color, $pen_size ) = @_;
    $self->x($x);
    $self->y($y);
    $self->heading($heading);
    $self->status($status);
    $self->pen_color($pen_color);
    $self->pen_size($pen_size);
}

=head2 forward()

  @line = $turtle->forward($steps);

Move forward the given number of steps.

=cut

sub forward {
    my $self = shift;
    my $step = shift // 1;

    my $x = $step * cos( $self->heading * K );
    my $y = $step * sin( $self->heading * K );

    my $xo = $self->x;
    my $yo = $self->y;

    $self->x( $x + $xo );
    $self->y( $y + $yo );

    if ( $self->status == 1 ) {
        return
            int($xo), int($yo),
            int($self->x), int($self->y),
            $self->pen_color, $self->pen_size;
    }
}

=head2 backward()

  @line = $turtle->backward($steps);

Move backward the given number of steps.

=cut

sub backward {
    my $self = shift;
    my $step = shift;
    $self->forward( - $step )
}

=head2 mirror()

  $turtle->mirror;

Reflect the heading by multiplying by -1.

=cut

sub mirror {
    my $self = shift;
    $self->heading( $self->heading * -1 );
}

=head2 goto()

  @line = $turtle->goto( $x, $y );

Move the pen to the given coordinate.

=cut

sub goto {
    my $self = shift;
    my ( $x, $y ) = @_;

    my $xo = $self->x;
    my $yo = $self->y;

    $self->x($x);
    $self->y($y);

    if ( $self->status == 1 ) {
        return
            $xo, $yo,
            $self->x, $self->y,
            $self->pen_color, $self->pen_size;
    }
}

1;
__END__

=head1 SEE ALSO

L<https://metacpan.org/source/YVESP/llg-1.07/Turtle.pm>

=cut
