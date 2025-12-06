#!/usr/bin/perl
use strict;
use warnings;

my $file = "data";
$file = "test" if $ENV{TEST};
open my $fh, "<", $file or die "Cannot open $file: $!";

my @ranges;
while (<$fh>) {
  chomp;
  next unless /^\s*(\d+)\s*-\s*(\d+)\s*$/;
  my ($start, $end) = ($1, $2);
  push @ranges, [$start, $end];
}
close $fh;

@ranges = sort { $a->[0] <=> $b->[0] } @ranges;

my @merged;
foreach my $r (@ranges) {
  if (!@merged || $r->[0] > $merged[-1]->[1]) {
      push @merged, [ @$r ];
  }
  else {
      $merged[-1]->[1] = $r->[1] if $r->[1] > $merged[-1]->[1];
  }
}

my @merged_strings = map { "$_->[0]-$_->[1]" } @merged;

my $pass = 0;

foreach my $m (@merged_strings) {
  if ($m =~ /(\d+)\-(\d+)/) {
    $pass += $2 - $1 + 1;
  }
}

print "Final Pass: $pass\n";

