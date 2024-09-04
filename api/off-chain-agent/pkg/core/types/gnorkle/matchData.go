package gnorkle

import (
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/types/sport"
)

type MatchData struct {
	FixtureID string `json:"fixture_id"`
	HomeTeam  Team   `json:"home_team"`
	AwayTeam  Team   `json:"away_team"`
	League    League `json:"league"`
	DateTime  string `json:"date_time"`
}

type Team struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type League struct {
	ID      string `json:"id"`
	Name    string `json:"name"`
	Country string `json:"country"`
	Season  string `json:"season"`
}

type OddData struct {
	FixtureID string      `json:"fixture_id"`
	Bookmaker string      `json:"bookmaker"`
	Bets      []sport.Bet `json:"bets"`
}

type GnorkleEntrypoint struct {
	MatchData []MatchData `json:"match_data"`
	OddData   []OddData   `json:"odd_data"`
}
