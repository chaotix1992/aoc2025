#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use List::Util qw(sum);
use Memoize;

my $fn = "data";
$fn = "test" if $ENV{TEST};

open(my $FH, '<', $fn) or die("Could not open file $fn: " . $!);

chomp(my @lines = <$FH>);
close($FH);

my $data;

foreach my $line (@lines) {
  if ($line =~ /^(.*):\s(.*)$/) {
    my $key = $1;
    my @values = split(/ /, $2);
    $data->{$key} = \@values;
  }
}

memoize('process');
my $pass = process('you');
print "Final pass: $pass\n";

sub process {
  my $in = shift;
  
  return 1 if $in eq 'out';
  return sum(map { process($_) } @{$data->{$in}}); 
}
