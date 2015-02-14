#!/usr/bin/env perl
use strict;
use warnings;

use DBI;
use Graph::Easy;
use File::Temp qw( tempfile );

my $dsn  = 'dbi:mysql:database=connections;host=localhost;port=3306';
my $user = 'root',
my $pass = 'abc123';
my $dbh  = DBI->connect( $dsn, $user, $pass, { RaiseError => 1, AutoCommit => 0 } );

my $sql = 'SELECT * FROM machine m';
my $sth = $dbh->prepare($sql);
my $rv  = $sth->execute();
my $rs  = $sth->fetchall_hashref('id');
$sth->finish;
#use Data::Dumper::Concise;print Dumper($rs);

my $machine;
$machine->{$_} = $rs->{$_}{name} for keys %$rs;
#use Data::Dumper::Concise;warn Dumper$machine;

$sql = 'SELECT * FROM master_slave ms';
$sth = $dbh->prepare($sql);
$rv  = $sth->execute();
$rs = $sth->fetchall_hashref('id');
$sth->finish;
#use Data::Dumper::Concise;print Dumper($rs);

$dbh->disconnect;

my $g = Graph::Easy->new( { debug => 0, undirected => 1 } );

for my $r ( keys %$rs )
{
#    print $machine->{ $rs->{$r}{master} } . ' <-> ' . $machine->{ $rs->{$r}{slave} }, "\n";
    $g->add_edge( $machine->{ $rs->{$r}{master} }, $machine->{ $rs->{$r}{slave} } );
}

#print $g->as_ascii;
#print $g->as_graphml;
#print $g->as_svg;

my ( $fh, $filename ) = tempfile();
print $fh $g->as_graphviz;
my @cmd = ( '/usr/local/bin/twopi', '-Tsvg', $filename );
warn "CMD: @cmd\n";
system @cmd;

