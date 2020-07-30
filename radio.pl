#!/usr/bin/perl
use strict;
use warnings;
use XML::RSS::Parser;

# Copyright (c) 2017-20 Nathalie Tate, Some Rights Reserved
# This code may be freely modified and distributed under the terms of the MIT
# License (see /docs/LICENSE.txt)


#set this to the directory that contains your podcasts
my $PODCASTDIR = "$ENV{HOME}/.radio";

my $parser = XML::RSS::Parser->new;

open my $rssFH, "<", "$PODCASTDIR/podcasts" or die;
chomp (my @RSSFEEDS = <$rssFH>);
close $rssFH;

for my $feedURI (@RSSFEEDS)
{
    my $feed = $parser->parse_uri($feedURI);
    print $feed->query("/channel/title") . "\n";
    #print $feedURI . "\n";
}

#utitlity functions
sub trim
{
    my $s = shift;
    $s =~ s/^\s+|\s+$//g;
    return $s
}

### MAIN
