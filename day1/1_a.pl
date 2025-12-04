#!/usr/bin/env perl

use strict;
use warnings;

my $fn = 'data';
$fn = 'test' if $ENV{TEST};

open(my $FH, '<', $fn);
my @lines = <$FH>;
close($FH);

my $pos = 50;
my $pass = 0;

foreach my $line (@lines) {
  chomp($line);
  if ($line =~ /^(R|L)(\d+)$/i) {
    my $rot = uc($1);
    my $count = $2;

    if ($rot eq 'R') {
      $pos += $count;
    }
    if ($rot eq 'L') {
      $pos -= $count;
    }
    $pos = $pos % 100;
    $pos += 100  
      if $pos < 0;
    $pass++
      if $pos == 0;
  }
}

print $pass . "\n";
