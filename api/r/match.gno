package gnobet

import (
	"std"
	"strconv"
  "gno.land/p/demo/json"
  "gno.land/p/demo/ufmt"
)

type OddData struct {
  ID int `json:"id"`
  MatchID int `json:"match_id"`
  BookMakerName string `json:"name"`
  OddsType []OddType `json:"bets"`

}

func oddDataFromJSON(data *json.Node, matchID int) (OddData, error) {
  bookMakerName, err := data.MustKey("bookmaker").Value()
  if err != nil {
    return OddData{}, err
  }
	betsData, err := data.GetKey("bets")
  if err != nil {
    return OddData{}, err
  }
  oddType := []OddType{}
  for i := 0; i < betsData.Size(); i++ {
    node, err := betsData.GetIndex(i)
    if err != nil {
      return OddData{}, err
    }
    oddTypeData, err := oddTypeFromJSON(node)
    if err != nil {
      return OddData{}, err
    }
    oddType = append(oddType, oddTypeData)
  }
  return OddData{
    BookMakerName: bookMakerName.(string),
    MatchID: matchID,
    OddsType: oddType,
  }, nil
}

type OddType struct {
  Name string `json:"name"`
  OddsValue []OddValue `json:"values"`
}

func oddTypeFromJSON(data *json.Node) (OddType, error) {
	name, err := data.MustKey("name").Value()
	if err != nil {
		return OddType{}, err
	}
  valuesData, err := data.GetKey("values")
  if err != nil {
    return OddType{}, err
  }
  oddData := []OddValue{}
  for i := 0; i < valuesData.Size(); i++ {
    node, err := valuesData.GetIndex(i)
    if err != nil {
      return OddType{}, err
    }
    oddValueData, err := oddValueFromJSON(node)
    if err != nil {
      return OddType{}, err
    }
    oddData = append(oddData, oddValueData)
  }

	return OddType{
    Name: name.(string),
    OddsValue: oddData,
  }, nil
}

type OddValue struct {
  Value string `json:"value"`
  Odd string `json:"odd"`
}

func oddValueFromJSON(data *json.Node) (OddValue, error) {
	value, err := data.MustKey("value").Value()
	if err != nil {
		return OddValue{}, err
	}
	odd, err := data.MustKey("odd").Value()
	if err != nil {
		return OddValue{}, err
	}
	return OddValue{
    Value: value.(string),
    Odd: odd.(string),
  }, nil
}

type GnorkleEntrypointData struct {
  Matches []MatchData `json:"matches"`
  Odds []OddData `json:"odds"`
}

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
	Winner MatchWinner `json:"winner"`
	Bettors []std.Address `json:"bettors"`
  Odds OddData `json:"odds"`
}

type MatchWinner string

const (
	HomeTeam MatchWinner = "HomeTeam"
	AwayTeam MatchWinner = "AwayTeam"
	Draw MatchWinner = "Draw"
)

func matchDataFromJSON(data *json.Node, id int) (MatchData, error) {
	matchDateTime, err := data.MustKey("date_time").Value()
	if err != nil {
		return MatchData{}, ufmt.Errorf("error getting date_time: %v", err)
	}
	homeTeam, err := teamFromJSON(data.MustKey("home_team"))
	if err != nil {
		return MatchData{}, ufmt.Errorf("error getting home_team: %v", err)
	}
	awayTeam, err := teamFromJSON(data.MustKey("away_team"))
	if err != nil {
		return MatchData{}, ufmt.Errorf("error getting away_team: %v", err)
	}
	league, err := leagueFromJSON(data.MustKey("league"))
	if err != nil {
		return MatchData{}, ufmt.Errorf("error getting league: %v", err)
	}
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

func teamFromJSON(data *json.Node) (Team, error) {
	teamID, err := data.MustKey("id").Value()
	if err != nil {
		return Team{}, err
	}
	teamIDInt, err := strconv.Atoi(teamID.(string))
	if err != nil {
		return Team{}, err
	}
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
	Bet string `json:"bet"`
	Status BetStatus `json:"status"`
  MatchID int `json:"match_id"`
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

func leagueFromJSON(data *json.Node) (League, error) {
  leagueID, err := data.MustKey("id").Value()
  if err != nil {
	return League{}, err
  }
  leagueIDInt, err := strconv.Atoi(leagueID.(string))
  if err != nil {
	return League{}, err
  }
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
