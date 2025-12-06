#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

my $fn = "data";
$fn = "test" if $ENV{TEST};

open(my $FH, '<', $fn) or die("Could not open file $fn: " . $!);

my @lines = <$FH>;
close($FH);

my @numbers;
my @operations;

foreach my $line (@lines) {
  chomp($line);
  # Split lines
  if ($line =~ /\d/) {
    my @row = split(/\s+/, $line);
    push(@numbers, \@row);
  }
  else {
    push(@operations, split(/\s+/, $line))
  }
}

print "Numbers: " . Dumper(@numbers) . "Operations: " . Dumper(@operations)
  if $ENV{DEBUG} == 2;
if ($ENV{DEBUG}) {
  my $i = 1;
  foreach my $line (@numbers) {
    print "Size of row $i:" . scalar(@{$line}) . "\n";
  }
  print "Size of row operations: " . @operations . "\n";
}

my $pass = 0;

for (my $i = 0; $i < @operations; $i++) {
  my $operation = $operations[$i];
  my $val;

  if ($operation eq '*') {
    $val = 1;
    foreach my $number (@numbers) {
      $val *= $number->[$i];
    }
  }
  else {
    $val = 0;
    foreach my $number (@numbers) {
      $val += $number->[$i];
    }
  }
  $pass += $val;
}

print "Final pass: " . $pass . "\n";
