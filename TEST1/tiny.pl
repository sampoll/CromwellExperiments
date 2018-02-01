#!/usr/bin/perl
 
unless ( @ARGV >= 1 )  {
  print "Error: not enough arguments\n";
  exit 1;
}

my $fin = $ARGV[0];

open(my $h0, "<", $fin) || die "COF $!";
while (my $l = <$h0>)  {
  chomp($l);
  $l =~ s/^[\s]+//;
  push(@L, $l);
}
close($fin);

@L = sort { $b <=> $a } @L;
printf "%d\n", $L[0];

