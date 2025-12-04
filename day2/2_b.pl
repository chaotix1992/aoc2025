#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use List::Util qw(uniq);

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

  my $running_sum = 0;
  for (my $i = 1; $i < length($number); $i++) {
    next if length($number) % $i != 0;
    my @chunks;
    for (my $pos = 0; $pos < length($number); $pos += $i) {
      push(@chunks, substr($number, $pos, $i));
    }
    if (uniq(@chunks) == 1) {
      $running_sum += $number;
      print "Found number that fulfills conditions: $number\n"
        if $ENV{DEBUG};
      last;
    }
  }

  return $running_sum;
}
