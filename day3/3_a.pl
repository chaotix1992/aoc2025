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

  my @vals = split(//, $batteries);

  my $max = 0;

  for (my $i = 0; $i < @vals; $i++) {
    for (my $j = $i + 1; $j < @vals; $j++) {
      $max = $vals[$i] . $vals[$j] if $vals[$i] . $vals[$j] > $max
    }
  }

  print "Found max $max in battery array $batteries\n" if $ENV{DEBUG};

  return $max;
}
