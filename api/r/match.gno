package gnobet

import (
	"std"
	"strconv"
  "gno.land/p/demo/json"
  "gno.land/p/demo/ufmt"
)

type MatchData struct {
	ID int `json:"id"`
	HomeTeam Team `json:"home_team"`
	AwayTeam Team `json:"away_team"`
  	League League `json:"league"`
  	DateTime string `json:"date_time"`
	Scores struct {
		HalfTime Score `json:"half_time"`
		FullTime Score `json:"full_time"`
		ExtraTime Score `json:"extra_time"`
		Penalties Score `json:"penalties"`
	} `json:"scores"`
	Status Status `json:"status"`
	Bets []Bet `json:"bets"`
}

func MatchDataFromJSON(data *json.Node, id int) (MatchData, error) {
	ufmt.Println("MatchDataFromJSON")
	matchDateTime, err := data.MustKey("date_time").Value()
	if err != nil {
		return MatchData{}, ufmt.Errorf("error getting date_time: %v", err)
	}
	ufmt.Println("HomeTeam")
	homeTeam, err := TeamFromJSON(data.MustKey("home_team"))
	if err != nil {
		return MatchData{}, ufmt.Errorf("error getting home_team: %v", err)
	}
	ufmt.Println("AwayTeam")
	awayTeam, err := TeamFromJSON(data.MustKey("away_team"))
	if err != nil {
		return MatchData{}, ufmt.Errorf("error getting away_team: %v", err)
	}
	ufmt.Println("League")
	league, err := LeagueFromJSON(data.MustKey("league"))
	if err != nil {
		return MatchData{}, ufmt.Errorf("error getting league: %v", err)
	}
	ufmt.Println("MatchDataFromJSONEND")
	return MatchData{
		ID: id,
		HomeTeam: homeTeam,
		AwayTeam: awayTeam,
		League: league,
		DateTime: matchDateTime.(string),
	}, nil
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
	ID int `json:"id"`
	Name string `json:"name"`
	League string `json:"league"`
}

func TeamFromJSON(data *json.Node) (Team, error) {
	ufmt.Println("TeamFromJSON")
	teamID, err := data.MustKey("id").Value()
	if err != nil {
		return Team{}, err
	}
	ufmt.Println("1")
	teamIDInt, err := strconv.Atoi(teamID.(string))
	if err != nil {
	ufmt.Println("1")
		return Team{}, err
	}
	ufmt.Println("2")
	teamName, err := data.MustKey("name").Value()
	if err != nil {
		return Team{}, err
	}
	return Team{
		ID: teamIDInt,
		Name: teamName.(string),
		League: "",
	}, nil
}

type Score struct {
	Home int
	Away int
}

type Bet struct {
	Bettor std.Address `json:"bettor"`
	ID int `json:"id"`
	Amount int `json:"amount"`
	Status BetStatus `json:"status"`
}

type BetStatus string

const (
	Running BetStatus = "running"
	Finish BetStatus = "finish"
)

type League struct {
  ID int `json:"id"`
  Name string `json:"name"`
  Country string `json:"country"`
  Season string `json:"season"`
}

func LeagueFromJSON(data *json.Node) (League, error) {
  leagueID, err := data.MustKey("id").Value()
  if err != nil {
	return League{}, err
  }
  ufmt.Println("leagueID: ", leagueID)
  leagueIDInt, err := strconv.Atoi(leagueID.(string))
  if err != nil {
	return League{}, err
  }
  ufmt.Println("leagueIDInt: ", leagueIDInt)
  leagueName, err := data.MustKey("name").Value()
  if err != nil {
	return League{}, err
  }
  leagueCountry, err := data.MustKey("country").Value()
  if err != nil {
	return League{}, err
  }
  leagueSeason, err := data.MustKey("season").Value()
  if err != nil {
	return League{}, err
  }
  return League{
	ID: leagueIDInt,
	Name: leagueName.(string),
	Country: leagueCountry.(string),
	Season: leagueSeason.(string),
  }, nil
}