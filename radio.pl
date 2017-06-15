#!/usr/bin/perl
use strict;
use warnings;

# Copyright (c) 2017 Nathalie Tate, Some Rights Reserved
# This code may be freely modified and distributed under the terms of the MIT
# License (see /docs/LICENSE.txt)


#set this to the directory that contains your podcasts
my $PODCASTDIR = "~/gPodder/Downloads/";

my $PODCAST;                #string, dir name of current podcast
my @episodes;               #string[]
my @podcasts;               #string[]
my $currentEpisode;         #int
my $currentPodcast;         #int

sub getEpisodes
{
  system("ls -lrt $PODCASTDIR$PODCAST |cut -f 9 -d ' ' > episodes.txt");
  open EPISODES,"<","episodes.txt"  or die;
  @episodes = <EPISODES>;

  for my $i (@episodes)
  {
    $episodes[$i] = trim($episodes[$i]);
  }

  $currentEpisode = @episodes - 1;
  close EPISODES;
}

sub getPodcasts
{
  system("ls -lrt $PODCASTDIR |cut -f 9 -d ' ' > podcasts.txt");
  open PODCASTS,"<","podcasts.txt"  or die;
  @podcasts = <PODCASTS>;

  for my $i (@podcasts)
  {
    $podcasts[$i] = trim($podcasts[$i]);
  }

  $currentPodcast = @podcasts - 1;
  $PODCAST = $podcasts[$currentPodcast];
  close PODCASTS;
}

sub sync
{
  getPodcasts;
  system("gpo download");
  getEpisodes;
}

sub play
{
  system("mpg123 $PODCASTDIR$PODCAST$episodes[$currentEpisode]");
}

sub nextPodcast
{
  if ($currentPodcast != @podcasts -1)
  {
    $currentPodcast++;
  }
  $PODCAST = $podcasts[$currentPodcast];
  getEpisodes;
  play;
}

sub prevPodcast
{
  if ($currentPodcast != 0)
  {
    $currentPodcast--;
  }
  $PODCAST = $podcasts[$currentPodcast];
  getEpisodes;
  play;
}

sub nextEpisode
{
  if ($currentEpisode != @episodes -1)
  {
    $currentEpisode++;
    play;
  }
}

sub prevEpisode
{
  if ($currentEpisode != 0)
  {
    $currentEpisode--;
    play;
  }
}

#utitlity function
sub trim
{
  my $s = shift;
  $s =~ s/^\s+|\s+$//g;
  return $s
}

### MAIN
sync;

my $input;

while( $input != "q")
{
  $input = <>;
  $input = trim($input);
}
