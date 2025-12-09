#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

my $fn = "data";
$fn = "test" if $ENV{TEST};

open(my $FH, '<', $fn) or die("Could not open file $fn: " . $!);

chomp(my @lines = <$FH>);
close($FH);

# Clean up input
my @data;
foreach my $line (@lines) {
  if ($line =~ /(\d+),(\d+)/) {
    my @val = ($1, $2);
    push(@data, \@val);
  }
}

my $pass = 0;
my $combo;

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
      # Check if the other corners are inside the shape
      if (segment_inside_poly($ax, $ay, $bx, $ay, \@data) && segment_inside_poly($ax, $ay, $ax, $by, \@data) && segment_inside_poly($ax, $by, $bx, $by, \@data) && segment_inside_poly($bx, $ay, $bx, $by, \@data)) {
        my $dx = $bx - $ax;
        $dx *= -1 if $dx < 0;
        my $dy = $by - $ay;
        $dy *= -1 if $dy < 0;
        if (($dx + 1) * ($dy + 1) > $pass) {
          $pass = ($dx + 1) * ($dy + 1);
          $combo = "Point A: $ax, $ay\nPoint B: $bx, $by\n";
          print '.';
        }
      }
    }
  }
}

print "\nFinal pass: $pass\n";
print "Points:\n$combo";


sub point_on_segment {
    my ($px,$py,$x1,$y1,$x2,$y2) = @_;

    if ($x1 == $x2) { # vertical
        return $px == $x1 && $py >= $y1 && $py <= $y2 ||
               $py >= $y2 && $py <= $y1;
    }
    if ($y1 == $y2) { # horizontal
        return $py == $y1 && $px >= $x1 && $px <= $x2 ||
               $px >= $x2 && $px <= $x1;
    }
    return 0;
}

sub point_in_poly {
    my ($px,$py,$poly) = @_;
    my $inside = 0;

    my $n = @$poly;
    for (my $i = 0; $i < $n; $i++) {
        my ($x1,$y1) = @{$poly->[$i]};
        my ($x2,$y2) = @{$poly->[($i+1)%$n]};

        return 1 if point_on_segment($px,$py,$x1,$y1,$x2,$y2);

        next unless $x1 == $x2;     # vertical only
        next unless $py > ($y1 < $y2 ? $y1 : $y2)
                 && $py <= ($y1 > $y2 ? $y1 : $y2);
        next unless $x1 > $px;

        $inside = !$inside;
    }
    return $inside;
}

sub segment_inside_poly {
    my ($x1,$y1,$x2,$y2,$poly) = @_;

    return 0 unless point_in_poly($x1,$y1,$poly);
    return 0 unless point_in_poly($x2,$y2,$poly);

    my $n = @$poly;

    if ($y1 == $y2) {
        my $y = $y1;
        my ($xa,$xb) = ($x1<$x2) ? ($x1,$x2) : ($x2,$x1);

        for (my $i=0; $i<$n; $i++) {
            my ($xA,$yA) = @{$poly->[$i]};
            my ($xB,$yB) = @{$poly->[($i+1)%$n]};

            next unless $xA == $xB;

            next unless $y >= ($yA < $yB ? $yA : $yB) &&
                         $y <= ($yA > $yB ? $yA : $yB);

            next unless $xA > $xa && $xA < $xb;

            return 0;
        }
        return 1;
    }

    if ($x1 == $x2) {
        my $x = $x1;
        my ($ya,$yb) = ($y1<$y2) ? ($y1,$y2) : ($y2,$y1);

        for (my $i=0; $i<$n; $i++) {
            my ($xA,$yA) = @{$poly->[$i]};
            my ($xB,$yB) = @{$poly->[($i+1)%$n]};

            next unless $yA == $yB;

            next unless $x >= ($xA < $xB ? $xA : $xB) &&
                         $x <= ($xA > $xB ? $xA : $xB);

            next unless $yA > $ya && $yA < $yb;

            return 0;
        }
        return 1;
    }

    die "Segment must be horizontal or vertical\n";
}

