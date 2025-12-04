#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

my $fn = "data";
$fn = "test" if $ENV{TEST};

open(my $FH, '<', $fn) or die("Could not open file $fn: " . $!);

my @lines = <$FH>;
close($FH);


# Build array of arrays
my $matrix;
foreach my $line (@lines) {
  chomp($line);
  my @arr = split(//, $line);
  push(@{$matrix}, \@arr);
}

my $len = @{$matrix};
my $width = @{$matrix->[0]};

my $pass = 0;

for (my $y = 0; $y < $len; $y++) {
  for (my $x = 0; $x < $width; $x++) {
    $pass += isValid($x, $y);
  }
}

print "Final password: $pass\n";

sub isValid {
  my ($x, $y) = @_;
  my $rolls = 0;

  return 0 if $matrix->[$y][$x] ne '@';
  # Look around
  # Look left
  if ($x > 0) {
    $rolls++ if $matrix->[$y][$x-1] eq '@';
  }
  # Look right
  if ($x < $width - 1) {
    $rolls++ if $matrix->[$y][$x+1] eq '@';
  }
  # Look up
  if ($y > 0) {
    $rolls++ if $matrix->[$y-1][$x] eq '@';
  }
  # Look down
  if ($y < $len - 1) {
    $rolls++ if $matrix->[$y+1][$x] eq '@';
  }
  # Look up left
  if ($x > 0 && $y > 0) {
    $rolls++ if $matrix->[$y-1][$x-1] eq '@';
  }
  # Look up right
  if ($x < $width - 1 && $y > 0) {
    $rolls++ if $matrix->[$y-1][$x+1] eq '@';
  }
  # Look down left
  if ($x > 0 && $y < $len - 1) {
    $rolls++ if $matrix->[$y+1][$x-1] eq '@';
  }
  # Look down right
  if ($x < $width - 1 && $y < $len - 1) {
    $rolls++ if $matrix->[$y+1][$x+1] eq '@';
  }
  
  if ($rolls < 4) {
    print "Found valid roll at position $x $y\n" if $ENV{DEBUG};
    return 1 if $rolls < 4;
  }
  return 0;
}
