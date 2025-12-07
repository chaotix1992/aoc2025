#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

$Data::Dumper::Indent = 0;

my $fn = "data";
$fn = "test" if $ENV{TEST} && $ENV{TEST} == 1;
$fn = "test" . $ENV{TEST} if $ENV{TEST} && $ENV{TEST} != 1;

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
my $pass = 0;

# Way this works: First, forward all values in one iteration from the previous row
# Next, iterate over the same row again and merge values together
# Example:
# ....S....
# ....1....
# ...1^1...
# ...1.1...
# ..1^2^1..
# ..1.2.1..
# .1^121^1.
# .1.121.1.
# 1^2^4^2^1
# 1.2.4.2.1

for (my $i = 1; $i < @matrix; $i++) {
  for (my $j = 0; $j < @{$matrix[$i]}; $j++) {
    if ($matrix[$i]->[$j] eq '.' && ($matrix[$i-1]->[$j] =~ /(S)/ || $matrix[$i-1]->[$j] =~ /(\d+)/)) {
      if ($1 eq 'S') {
        $matrix[$i]->[$j] = 1;
      }
      else {
        $matrix[$i]->[$j] = $1 + 0;
      }
    }
  }
  for (my $j = 0; $j < @{$matrix[$i]}; $j++) {
    # Split logic
    if ($matrix[$i]->[$j] eq '^' && $matrix[$i-1]->[$j] =~ /(\d+)/) {
      my $current_val = $1;
      if ($matrix[$i]->[$j-1] =~ /\d+/) {
        $matrix[$i]->[$j-1] += $current_val;
      }
      elsif ($matrix[$i]->[$j-1] eq '.') {
        $matrix[$i]->[$j-1] = $current_val;
      }
      if ($matrix[$i]->[$j+1] =~ /\d+/) {
        $matrix[$i]->[$j+1] += $current_val;
      }
      elsif ($matrix[$i]->[$j+1] eq '.') {
        $matrix[$i]->[$j+1] = $current_val;
      }
    }
  }
}

if ($ENV{DEBUG}) {
  my $dump = sprintf(Dumper(@matrix));
  $dump =~ s/\;/\n/g;
  $dump =~ s/'//g;
  $dump =~ s/\$VAR\d+ =//g;
  print "Final matrix:\n" . $dump . "\n";
}

foreach my $value (@{$matrix[@matrix - 1]}) {
  if ($value =~ /\d+/) {
    $pass += $value;
  }
}

print "Final pass: $pass\n";
