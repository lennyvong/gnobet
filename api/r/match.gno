package gnobet

import (
	"std"
)

type MatchData struct {
	ID int `json:"id"`
	MatchDateTime string
	HomeTeam Team `json:"home_team"`
	AwayTeam Team `json:"away_team"`
  League League `json:"league"`
  DateTime string `json:"date_time"`
	Scores struct {
		HalfTime Score
		FullTime Score
		ExtraTime Score
		Penalties Score
	}
	Status Status
	Bets []Bet
}

type Status string

const (
	NotStarted Status = "NotStarted"
	InPlay Status = "InPlay"
	Finished Status = "Finished"
	Postponed Status = "Postponed"
	Cancelled Status = "Cancelled"
)

type Team struct {
	ID int
	Name string
	League string
}

type Score struct {
	Home int
	Away int
}

type Bet struct {
	Bettor std.Address
	ID int
	Amount int
}

type League struct {
  ID int `json:"id"`
  Name string `json:"name"`
  Country string `json:"country"`
  Season string `json:"season"`
}
