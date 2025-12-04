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
  
  if ($line =~ /^(R|L)(\d+)$/) {
    my $rot = $1;
    my $amount = $2;
    
    if ($rot eq 'R') {
      for (my $i = 0; $i < $amount; $i++) {
        $pos++;
        $pos -= 100 if $pos == 100;
        $pass++ if $pos == 0;
      }
    }
    if ($rot eq 'L') {
      for (my $i = 0; $i < $amount; $i++) {
        $pos--;
        $pos += 100 if $pos < 0;
        $pass++ if $pos == 0;
      }
    }
  }
}

print "Final password: $pass\n";
