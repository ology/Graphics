#!/usr/bin/env perl
use strict;
use warnings;

use DBI;
use Graph::Easy;
use File::Temp qw( tempfile );

# Connect to the database
my $dsn  = 'dbi:mysql:database=connections;host=localhost;port=3306';
my $user = 'root',
my $pass = 'abc123';
my $dbh  = DBI->connect( $dsn, $user, $pass, { RaiseError => 1, AutoCommit => 0 } );

# Gather the machines by id
my $sql = 'SELECT * FROM machine m';
my $sth = $dbh->prepare($sql);
my $rv  = $sth->execute();
my $rs  = $sth->fetchall_hashref('id');
$sth->finish;

# Make an id => name reference
my $machine;
$machine->{$_} = $rs->{$_}{name} for keys %$rs;

# Gather the connected machines by id
$sql = 'SELECT * FROM master_slave ms';
$sth = $dbh->prepare($sql);
$rv  = $sth->execute();
$rs = $sth->fetchall_hashref('id');
$sth->finish;

# Disconnect from the database
$dbh->disconnect;

# Create a new graph object
my $g = Graph::Easy->new( { debug => 0, undirected => 1 } );

# Assign edges to the graph by machine name
for my $r ( keys %$rs )
{
#    print $machine->{ $rs->{$r}{master} } . ' <-> ' . $machine->{ $rs->{$r}{slave} }, "\n";
    $g->add_edge( $machine->{ $rs->{$r}{master} }, $machine->{ $rs->{$r}{slave} } );
}

# Output the graph in various formats
#print $g->as_ascii;
#print $g->as_graphml;
#print $g->as_svg;

# Use Graphviz to display the graph
my ( $fh, $filename ) = tempfile();
print $fh $g->as_graphviz;
my @cmd = ( '/usr/local/bin/twopi', '-Tsvg', $filename );
warn "CMD: @cmd\n";
system @cmd;

