#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

my $fn = "data";
$fn = "test" if $ENV{TEST};
my $limit = 1000;
$limit = 10 if $ENV{TEST};

open(my $FH, '<', $fn) or die("Could not open file $fn: " . $!);

chomp(my @lines = <$FH>);
close($FH);

my @points;

foreach my $line (@lines) {
  my @row = split(',', $line);
  push(@points, \@row);
}

my @distances;
for (my $i = 0; $i < @points - 1; $i++) {
  my ($x1, $y1, $z1) = @{$points[$i]};
  for (my $j = $i + 1; $j < @points; $j++) {
    my ($x2, $y2, $z2) = @{$points[$j]};
    my $distance = ($x1 - $x2) ** 2 + ($y1 - $y2) ** 2 + ($z1 - $z2) ** 2;
    my @row = ($distance, $i, $j);
    push(@distances, \@row);
  }
}

my $distances_ref = sortMatrix(\@distances);
@distances = @{$distances_ref};

my $UF;

for (my $i = 0; $i < @points; $i++) {
  $UF->{$i} = $i;
}

my $connections = 0;

for (my $i = 0; $i < @distances; $i++) {
  if ($i == $limit) {
    my $circuits;
    for (my $x = 0; $x < @points; $x++) {
      if (!defined($circuits->{find($x)})) {
        $circuits->{find($x)} = 1;
      }
      else {
        $circuits->{find($x)}++;
      }
    }
    my @keys = sort({ $circuits->{$a} <=> $circuits->{$b} } keys(%{$circuits}));
    my @solution = @{$circuits}{@keys};
    my $pass_a = $solution[-1] * $solution[-2] * $solution[-3];
    print "Part 1 Pass: $pass_a\n";
  }
  my $j = $distances[$i]->[1];
  my $k = $distances[$i]->[2];
  if (find($j) != find($k)) {
    $connections++;
    if ($connections == @points - 1) {
      print "Part 2 Pass: " . $points[$j]->[0] * $points[$k]->[0] . "\n";
    }
    mix($j, $k);
  }
}

sub find {
  my $x = shift;
  if ($x == $UF->{$x}) {
    return $x;
  }
  $UF->{$x} = find($UF->{$x});
  return $UF->{$x};
}

sub mix {
  my $x = shift;
  my $y = shift;
  $UF->{find($x)} = find($y);
}

sub sortMatrix {
    my $matrix = shift;
    my @new_matrix = sort({ $a->[0] <=> $b->[0] } @{$matrix});
    return \@new_matrix;
}
