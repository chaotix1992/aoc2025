#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use List::Util qw(sum);
use Memoize;

my $fn = "data";
$fn = "test2" if $ENV{TEST};

open(my $FH, '<', $fn) or die("Could not open file $fn: " . $!);

chomp(my @lines = <$FH>);
close($FH);

my $data;

foreach my $line (@lines) {
  if ($line =~ /^(.*):\s(.*)$/) {
    my $key = $1;
    my @values = split(/ /, $2);
    $data->{$key} = \@values;
  }
}

memoize('process');
my $pass = process('svr', 0, 0);
print "Final pass: $pass\n";

sub process {
  my $in = shift;
  my $dac = shift;
  my $fft = shift;
  
  if ($in eq 'out') { return $dac && $fft ? 1 : 0; }
  if ($in eq 'dac') { $dac = 1; }
  if ($in eq 'fft') { $fft = 1; }
  return sum(map { process($_, $dac, $fft) } @{$data->{$in}}); 
}
