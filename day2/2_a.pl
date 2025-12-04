#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

my $fn = "data";
$fn = "test" if $ENV{TEST};

open(my $FH, '<', $fn) or dia("Could not open file $fn: " . $!);

my @lines = <$FH>;
my $input = $lines[0];

# Tidy up the input
my @ranges = split(',', $input);

my $pass = 0;

# Analyze each range
foreach my $range (@ranges) {
  my @values = ($1 .. $2) if $range =~ /(\d+)\-(\d+)/;
  if ($ENV{DEBUG}) {
    print STDERR "Range of values for the first range: " . Dumper(@values) . "\n";
    last;
  }
  foreach my $number (@values) {
    $pass += analyzeNumber($number);
  }
}

print "Final password: " . $pass . "\n";

sub analyzeNumber {
  my $number = shift;

  if (length($number) % 2 != 0) {
    return 0
  }

  # Split number in the middle, check if first half and second half are equal
  my $mid = length($number) / 2;      # midpoint index

  my $left  = substr($number, 0, $mid);
  my $right = substr($number, $mid);

  if ($left == $right) {
    return $number;
  }
  
  return 0;
}
