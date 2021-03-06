package models

import "time"

type WordResult struct {
	Definition  string        `json:"definition"`
	Permalink   string        `json:"permalink"`
	ThumbsUp    int           `json:"thumbs_up"`
	SoundUrls   []interface{} `json:"sound_urls"`
	Author      string        `json:"author"`
	Word        string        `json:"word"`
	Defid       int           `json:"defid"`
	CurrentVote string        `json:"current_vote"`
	WrittenOn   time.Time     `json:"written_on"`
	Example     string        `json:"example"`
	ThumbsDown  int           `json:"thumbs_down"`
}
