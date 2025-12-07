#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

my $fn = "data";
$fn = "test" if $ENV{TEST};

open(my $FH, '<', $fn) or die("Could not open file $fn: " . $!);

my @lines = <$FH>;
close($FH);

# Split into matrix
my @matrix;
foreach my $line (@lines) {
  chomp($line);
  my @row = split(//, $line);
  push(@matrix, \@row);
}

# Iterate through matrix
# if previous line had | in that position and the current symbol is ^; split
# if the current symbol is a .; replace
my $pass = 0;

for (my $i = 1; $i < @matrix; $i++) {
  for (my $j = 0; $j < @{$matrix[$i]}; $j++) {
    next if ($matrix[$i]->[$j] eq '|');
    # Split logic
    if ($matrix[$i]->[$j] eq '^' && $matrix[$i-1]->[$j] eq '|') {
      $matrix[$i]->[$j-1] = "|";
      $matrix[$i]->[$j+1] = "|";
      $pass++;
      next;
    }
    elsif ($matrix[$i]->[$j] eq '.' && ($matrix[$i-1]->[$j] eq 'S' || $matrix[$i-1]->[$j] eq '|')) {
      $matrix[$i]->[$j] = "|";
    }
  }
}

print "Final pass: $pass\n";
