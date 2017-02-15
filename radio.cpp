/* radio.cpp
	 Copyright (c) 2016 Nathalie Tate, Some Rights Reserved
	 This code may be freely modified and distrubuted under the terms of the MIT
	 License (see /docs/LICENSE.txt)
*/

#include<stdio.h>
#include<string>
#include<fstream>
#include<iostream>
#include<deque>
#include<iterator>
using std::deque;
using std::ifstream;
using std::string;

//Change this to match your podcast directory
//string PODCASTDIR = "~/gPodder/Downloads/";
/*debug*/string PODCASTDIR = "~/podcasts/";

string PODCAST;
deque<string> podcasts;
deque<string> episodes;
deque<string>::iterator currentEpisode;
deque<string>::iterator currentPodcast;

void getEpisodes()
{
	ifstream file("episodes.txt");
	episodes.clear();
	string line;
	while(getline(file, line))
	{
		episodes.push_back(line);
	}

	currentEpisode = episodes.end();
	file.close();
}

void getPodcasts()
{
	ifstream file("podcasts.txt");
	podcasts.clear();
	string line;
	while(getline(file, line))
	{
		podcasts.push_back(line);
	}

	currentPodcast = podcasts.end();
	PODCAST = *currentPodcast;
	file.close();
}

void updateList()
{
	system(("ls -lrt " + PODCASTDIR + " " + PODCAST + " |cut -f 9 -d ' ' > episodes.txt").c_str());

	system(("ls -lrt " + PODCASTDIR + " |cut -f 9 -d ' ' > podcasts.txt").c_str());

	getPodcasts();
	getEpisodes();
}

void sync()
{
	system("gpo download");
	updateList();
}

void play()
{
	system(("mpg123 " + PODCASTDIR + PODCAST + *currentEpisode).c_str());
}

void nextPodcast()
{
	if(currentPodcast != podcasts.end())
	{
		++currentPodcast;
		PODCAST = *currentPodcast;
		updateList();
		play();
	}
}

void prevPodcast()
{
	if(currentPodcast != podcasts.begin())
	{
		--currentPodcast;
		PODCAST = *currentPodcast;
		updateList();
		play();
	}
}

void nextEpisode()
{
	if(currentEpisode != episodes.end())
	{
		++currentEpisode;
		play();
	}
}

void prevEpisode()
{
	if(currentEpisode != episodes.begin())
	{
		--currentEpisode;
		play();
	}
}

int main()
{
	//sync();

	/*debug*/updateList();

}
