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

for (my $i = 0; $i < @lines - 1; $i++) {
  my $ax = 0;
  my $ay = 0;
  if ($lines[$i] =~ /(\d+),(\d+)/) {
    $ax = $1;
    $ay = $2;
  }
  for (my $j = $i + 1; $j < @lines; $j++) {
    my $bx = 0;
    my $by = 0;
    if ($lines[$j] =~ /(\d+),(\d+)/) {
      $bx = $1;
      $by = $2;
      my $dx = $bx - $ax;
      $dx *= -1 if $dx < 0;
      my $dy = $by - $ay;
      $dy *= -1 if $dy < 0;
      $pass = ($dx + 1) * ($dy + 1)
        if ($dx + 1) * ($dy + 1) > $pass;
    }
  }
}

print "Final pass: $pass\n";
