#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

my $fn = "data";
$fn = "test" if $ENV{TEST};

open(my $FH, '<', $fn) or die("Could not open file $fn: " . $!);

my @lines = <$FH>;
close($FH);

my $pass = 0;

foreach my $line (@lines) {
  $pass += getMaxJoltage($line);
}

print "Final pass: $pass\n";

sub getMaxJoltage {
  my $batteries = shift;
  chomp($batteries);

  # Take the last twelve digits
  # Then move the first of the last twelve digits and take a step to the left
  # If bigger or equal, that's the next number to jump to
  my $max;
  my $digit;
  my $rest = $batteries;
  for (my $i = 12; $i > 0; $i--) {
    ($digit, $rest) = findBiggest($rest, $i);
    $max .= $digit;
  }

  print "Found max value: $max\n" if $ENV{DEBUG};
  return $max;
}

sub findBiggest {
  my $rest = shift;
  my $len = shift;

  my @vals = split(//, $rest);

  if ($len > @vals) {
    return ($vals[0], @vals[1..@vals]);
  }

  my $digit = 0;
  my $max_index = @vals - $len;

  if ($ENV{DEBUG}) {
    print "Current rest: $rest\nCurrent len: $len\nCurrent vals: " . Dumper(@vals) . "\n";
    print "Starting index: " . scalar(@vals) - $len . "\n";
  }

  for (my $i = scalar(@vals) - $len; $i >= 0; $i--) {
    print "Current index that is checked: $i\n" if $ENV{DEBUG};
    if ($vals[$i] >= $digit) {
      print "Found new max value $vals[$i] at index $i\n" if $ENV{DEBUG};
      $digit = $vals[$i];
      $max_index = $i;
    }
  }

  $rest = join('', @vals[$max_index+1..@vals]);
  return ($digit, $rest);
}
