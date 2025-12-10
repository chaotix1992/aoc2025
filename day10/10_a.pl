#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

my $fn = "data";
$fn = "test" if $ENV{TEST};

open(my $FH, '<', $fn) or die("Could not open file $fn: " . $!);

chomp(my @lines = <$FH>);
close($FH);

my $pass = 0;

foreach my $line (@lines) {
  my @input = split(/ /, $line);
  my $lights = $input[0];
  my @buttons_raw = @input[1..@input - 2];
  #my $joltage = $input[-1];

  $lights =~ s/[\[\]]//g;
  my $target = 0;
  my $i = 0;
  foreach my $c (split(//, $lights)) {
    $target += 2 ** $i if $c eq '#';
    $i++;
  }
  my @buttons;
  foreach my $button (@buttons_raw) {
    $button =~ s/[\(\)]//g;
    my @vals = split(',', $button);
    my $button_val;
    foreach my $val (@vals) {
      $button_val += 2 ** $val;
    }
    push(@buttons, $button_val);
  }

  my $score = scalar(@buttons);

  for (my $j = 0; $j < 2 ** scalar(@buttons); $j++) {
    my $jn = 0;
    my $j_score = 0;
    for (my $k = 0; $k < @buttons; $k++) {
      if (($j >> $k) % 2 == 1) {
        $jn = $jn ^ $buttons[$k];
        $j_score++;
      }
    }
    if ($jn == $target) {
      $score = $j_score if $j_score < $score;
    }
  }

  $pass += $score;
}

print "Final pass: $pass\n";
