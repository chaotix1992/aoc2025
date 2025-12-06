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
    my @row = split(//, $line);
    push(@numbers, \@row);
  }
  else {
    push(@operations, split(//, $line))
  }
}

print "Numbers: " . Dumper(@numbers) . "Operations: " . Dumper(@operations)
  if (defined($ENV{DEBUG}) && $ENV{DEBUG} == 2);
if ($ENV{DEBUG}) {
  my $i = 1;
  foreach my $line (@numbers) {
    print "Size of row $i:" . scalar(@{$line}) . "\n";
    $i++
  }
  print "Size of row operations: " . @operations . "\n";
}

my $pass = 0;

# An operator indicates the index of the next set of numbers
my $i = 0;
my $current_operator;
my $running_val;

foreach my $operator (@operations) {
  my $val;
  my $sum_up = 1;
  for (my $j = 0; $j < @numbers; $j++) {
    $sum_up = 0 if $numbers[$j]->[$i] ne ' ';
  }
  if ($sum_up) {
    $pass += $running_val;
    $i++;
    next;
  }
  if ($operator ne '*' && $operator ne '+') {
    foreach my $row (@numbers) {
      $val .= $row->[$i] if $row->[$i] ne ' ';
    }
    $i++;
  }
  else {
    foreach my $row (@numbers) {
      $val .= $row->[$i] if $row->[$i] ne ' ';
    }
    $i++;
    $current_operator = $operator;
    if ($current_operator eq '*') {
      $running_val = 1;
    }
    elsif ($current_operator eq '+') {
      $running_val = 0;
    }
  }
  if ($current_operator eq '*') {
    $running_val *= $val;
  }
  elsif ($current_operator eq '+') {
    $running_val += $val;
  }
  print "Current value: $val; current running value: $running_val; current operator: $current_operator\n"
    if $ENV{DEBUG};
}

$pass += $running_val;

print "Final pass: " . $pass . "\n";
