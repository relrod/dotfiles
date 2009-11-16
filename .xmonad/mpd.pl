#!/usr/bin/env perl
use warnings;
use strict;
use Switch;
use Audio::MPD;
use Data::Dumper;
my $mpd = Audio::MPD->new();
my $status = $mpd->status()->{'state'};

switch($status) {
   case 'play' { $status = 'Playing'; }
   case 'stop' { $status = 'Stopped'; }
   case 'pause' { $status = 'Paused'; }
}

print "[$status] ".$mpd->current()->{'artist'}." - ".$mpd->current()->{'title'};
