#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

my $fn = "data";
$fn = "test" if $ENV{TEST};

open(my $FH, '<', $fn) or die("Could not open file $fn: " . $!);

my @lines = <$FH>;
close($FH);

my @fresh;
my @incredients;

foreach my $line (@lines) {
  chomp($line);
  if ($line =~ /(\d+)\-(\d+)/) {
    push(@fresh, $line);
  }
  elsif ($line =~ /^(\d+)$/) {
    push(@incredients, $1);
  }
}

if ($ENV{DEBUG}) {
  print "Fresh: " . Dumper(@fresh);
  print "Incredients: " . Dumper(@incredients);
}
my $pass = 0;

foreach my $incredient (@incredients) {
  foreach my $range (@fresh) {
    if ($range =~ /(\d+)\-(\d+)/) {
      if ($incredient >= $1 && $incredient <= $2) {
        $pass++;
        if ($ENV{DEBUG}) {
          print "Found hit: Range: $range; Number: $incredient\n";
        }
        last;
      }
    }
  }
}

print "Final password: $pass\n";
