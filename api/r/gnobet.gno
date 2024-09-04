package gnobet

import (
	"std"
	"strconv"

	"gno.land/p/demo/gnorkle/feeds/continious"
	"gno.land/p/demo/gnorkle/gnorkle"
	"gno.land/p/demo/gnorkle/message"
  	"gno.land/p/demo/ufmt"
  	"gno.land/p/demo/json"
	"gno.land/p/demo/avl"
)

var (
	ownerAddress = std.GetOrigCaller()
	oracle 	 *gnorkle.Instance
	postHandler = &postGnorkleMessageHandler{}

	matches = &[]MatchData{}
  odds = avl.NewTree() // matchID -> Odds
  bets = avl.NewTree() // std.Address -> Bet
)

type postGnorkleMessageHandler struct {}

// Handle handles the gnorkle message
func (h postGnorkleMessageHandler) Handle(i *gnorkle.Instance, funcType message.FuncType, feed gnorkle.Feed) error {
	caller := std.GetOrigCaller() // get tx sender

	if funcType != message.FuncTypeCommit && funcType != message.FuncTypeIngestCommit {
    ufmt.Println("funcType != message.FuncTypeCommit")
		return nil
	}

	result, _, consumable := feed.Value()
	if !consumable {
    ufmt.Println("!consumable")
		return nil
	}
  decodedData, err := json.Unmarshal([]byte(result.String))
   if err != nil {
     ufmt.Println("error decoding data")
     return nil
   }
   matchData, err := decodedData.GetKey("match_data")
    if err != nil {
      ufmt.Println("error getting match_data")
      return nil
   }
   oddData, err := decodedData.GetKey("odd_data")
   if err != nil {
     ufmt.Println("error getting odd_data")
     return nil
   }
   for i := 0; i < matchData.Size(); i++ {
    matchID := len(*matches)
	  node, err := matchData.GetIndex(i)
	  if err != nil {
	   ufmt.Println("error getting node")
	   return nil
	  }
	  matchFromJson, err := matchDataFromJSON(node, matchID)
	  if err != nil {
	   ufmt.Println("error decoding data")
	   return nil
	  }
    oddNode, err := oddData.GetIndex(i)
    if err != nil {
      ufmt.Println("error getting oddNode")
      return nil
    }
    oddFromJson, err := oddDataFromJSON(oddNode, matchID)
    if err != nil {
      ufmt.Println("error decoding data")
      return nil
    }
	  *matches = append(*matches, matchFromJson)
    oddCaller, ok := odds.Get(caller.String())
    if !ok {
      oddCaller = []OddData{}
    }
    oddsCaller := append(oddCaller.([]OddData), oddFromJson)
    odds.Set(caller.String(), oddsCaller)
   }
  // matches = append(matches,result.String.(MatchData))
	return nil
}

// Set the owner address and whitelist off-chain agent
func init() {
	oracle = gnorkle.NewInstance()
	oracle.AddToWhitelist("", []string{string(ownerAddress), string(std.Address("g1uvyyu9h367wcmc6n888de3nur47xk687udc2ex"))})
}

// RequestMatchDate requests the match date, add feeds to the oracle
func RequestMatchDate(sport string, date string, dayInterval string) {
  if sport != "football" {
    panic(ufmt.Errorf("unsupported sport: %s", sport))
  }
	if err := checkDate(date); err != nil {
		panic(err)
	}
	if err := oracle.AddFeeds(
		continious.NewSingleValueFeed(
			date,
			"string",
			&matchDateTask{date},
		),
	); err != nil {
		panic(err)
	}
	std.Emit("RequestMatchesDate", "sport", sport, "date", date, "day_interval", dayInterval)
}

// GnorkleEntrypoint is the entrypoint for the oracle by the off-chain agent
func GnorkleEntrypoint(message string) string {
	result, err := oracle.HandleMessage(message, postHandler)
	if err != nil {
		panic(err)
	}

	return result
}

// BetOnAMatch allows a user to bet on a match
func BetOnAMatch(matchID int, bet MatchWinner) {
	coinSent := std.GetOrigSend() // get Coins sent with call
	caller := std.GetOrigCaller() // get tx sender

	(*matches)[matchID].Bettors = append((*matches)[matchID].Bettors, caller)
  ufmt.Println((*matches)[matchID].Bettors[0].String())
  callerBets, ok := bets.Get(caller.String())
  if !ok {
    callerBets = []Bet{}
  }
  callersBets := append(callerBets.([]Bet), Bet{
    Bettor: caller,
    ID:     len(callerBets.([]Bet)),
    Amount: int(coinSent.AmountOf("ugnot")),
    Bet:   string(bet),
    MatchID: matchID,
  })
  bets.Set(caller.String(), callersBets)
}

func ApplicateBet(matchID int) error {
	realmAddr := std.CurrentRealm().Addr()
	banker := std.GetBanker(std.BankerTypeOrigSend)

  match := (*matches)[matchID]
  for _, bettor := range match.Bettors {
    bet, ok := bets.Get(bettor.String())
    if !ok {
      return ufmt.Errorf("bettor %s has no bet", bettor.String())
    }
    for _, b := range bet.([]Bet) {
      if b.MatchID == matchID {
        if b.Bet == string(match.Winner) {
			    banker.SendCoins(realmAddr, bettor, std.Coins{std.NewCoin("ugnot", int64(b.Amount))})
        }
      }
    }
  }
  return nil
}

func GetMatch(matchID int) string {
	match := (*matches)[matchID]
	bettorsJson := json.ArrayNode("", []*json.Node{})

	for _, bettor := range match.Bettors {
		bettorsJson.AppendArray(json.StringNode("adress", bettor.String()))
	}
	homeTeamJson := json.ObjectNode("", map[string]*json.Node{
		"id":    json.StringNode("id", strconv.Itoa(match.HomeTeam.ID)),
		"name":   json.StringNode("name", match.HomeTeam.Name),
		"league": json.StringNode("league", match.HomeTeam.League),
	})
	awayTeamJson := json.ObjectNode("", map[string]*json.Node{
		"id":    json.StringNode("id", strconv.Itoa(match.AwayTeam.ID)),
		"name":   json.StringNode("name", match.AwayTeam.Name),
		"league": json.StringNode("league", match.AwayTeam.League),
	})
	leagueJson := json.ObjectNode("", map[string]*json.Node{
		"id":    json.StringNode("id", strconv.Itoa(match.League.ID)),
		"name":   json.StringNode("name", match.League.Name),
		"country": json.StringNode("country", match.League.Country),
		"season": json.StringNode("season", match.League.Season),
	})
	scoresJson := json.ObjectNode("", map[string]*json.Node{
		"half_time": json.ObjectNode("", map[string]*json.Node{
			"home": json.StringNode("home", strconv.Itoa(match.Scores.HalfTime.Home)),
			"away": json.StringNode("away", strconv.Itoa(match.Scores.HalfTime.Away)),
		}),
		"full_time": json.ObjectNode("", map[string]*json.Node{
			"home": json.StringNode("home", strconv.Itoa(match.Scores.FullTime.Home)),
			"away": json.StringNode("away", strconv.Itoa(match.Scores.FullTime.Away)),
		}),
		"extra_time": json.ObjectNode("", map[string]*json.Node{
			"home": json.StringNode("home", strconv.Itoa(match.Scores.ExtraTime.Home)),
			"away": json.StringNode("away", strconv.Itoa(match.Scores.ExtraTime.Away)),
		}),
		"penalties": json.ObjectNode("", map[string]*json.Node{
			"home": json.StringNode("home", strconv.Itoa(match.Scores.Penalties.Home)),
			"away": json.StringNode("away", strconv.Itoa(match.Scores.Penalties.Away)),
		}),
	})
	matchJson := json.ObjectNode("", map[string]*json.Node{
		"id":          json.StringNode("id", strconv.Itoa(match.ID)),
		"home_team":   homeTeamJson,
		"away_team":   awayTeamJson,
		"league":      leagueJson,
		"date_time":   json.StringNode("date_time", match.DateTime),
		"scores": 	scoresJson,
		"status": 	json.StringNode("status", string(match.Status)),
		"bettors": 	bettorsJson,
	})
	encoded, err := json.Marshal(matchJson)
	if err != nil {
		panic(ufmt.Errorf("error: %v", err))
	}

	return string(encoded)
}

func GetBet(address std.Address) string {
  bet, ok := bets.Get(address.String())
  if !ok {
    return ""
  }
  betJson := json.ArrayNode("", []*json.Node{})
  for _, b := range bet.([]Bet) {
    betJson.AppendArray(json.ObjectNode("", map[string]*json.Node{
      "id": json.StringNode("id", strconv.Itoa(b.ID)),
      "amount": json.StringNode("amount", strconv.Itoa(b.Amount)),
      "bet": json.StringNode("bet", b.Bet),
    }))
  }
  encoded, err := json.Marshal(betJson)
  if err != nil {
    panic(ufmt.Errorf("error: %v", err))
  }
  return string(encoded)
}

func GetOdd(address std.Address) string {
  odd, ok := odds.Get(address.String())
  if !ok {
    return ""
  }
  oddJson := json.ArrayNode("", []*json.Node{})
  for _, o := range odd.([]OddData) {
    oddsType := json.ArrayNode("", []*json.Node{})
    for _, oddType := range o.OddsType {
      oddsValue := json.ArrayNode("", []*json.Node{})
      for _, oddValue := range oddType.OddsValue {
        oddsValue.AppendArray(json.ObjectNode("", map[string]*json.Node{
          "value": json.StringNode("value", oddValue.Value),
          "odd": json.StringNode("odd", oddValue.Odd),
        }))
      }
      oddsType.AppendArray(json.ObjectNode("", map[string]*json.Node{
        "name": json.StringNode("name", oddType.Name),
        "values": oddsValue,
      }))
    }
    oddJson.AppendArray(json.ObjectNode("", map[string]*json.Node{
      "id": json.StringNode("id", strconv.Itoa(o.ID)),
      "match_id": json.StringNode("match_id", strconv.Itoa(o.MatchID)),
      "bookmaker": json.StringNode("bookmaker", o.BookMakerName),
      "odds_type": oddsType,
    }))
  }
  encoded, err := json.Marshal(oddJson)
  if err != nil {
    panic(ufmt.Errorf("error: %v", err))
  }
  return string(encoded)
}

func GetMatches() string {
	matchesJson := json.ArrayNode("", []*json.Node{})
	for _, match := range *matches {
		bettorsJson := json.ArrayNode("", []*json.Node{})
		for _, bettor := range match.Bettors {
			bettorsJson.AppendArray(json.StringNode("adress", bettor.String()))
		}

		homeTeamJson := json.ObjectNode("", map[string]*json.Node{
			"id":    json.StringNode("id", strconv.Itoa(match.HomeTeam.ID)),
			"name":   json.StringNode("name", match.HomeTeam.Name),
			"league": json.StringNode("league", match.HomeTeam.League),
		})

		awayTeamJson := json.ObjectNode("", map[string]*json.Node{
			"id":    json.StringNode("id", strconv.Itoa(match.AwayTeam.ID)),
			"name":   json.StringNode("name", match.AwayTeam.Name),
			"league": json.StringNode("league", match.AwayTeam.League),
		})

		leagueJson := json.ObjectNode("", map[string]*json.Node{
			"id":    json.StringNode("id", strconv.Itoa(match.League.ID)),
			"name":   json.StringNode("name", match.League.Name),
			"country": json.StringNode("country", match.League.Country),
			"season": json.StringNode("season", match.League.Season),
		})

		scoresJson := json.ObjectNode("", map[string]*json.Node{
			"half_time": json.ObjectNode("", map[string]*json.Node{
				"home": json.StringNode("home", strconv.Itoa(match.Scores.HalfTime.Home)),
				"away": json.StringNode("away", strconv.Itoa(match.Scores.HalfTime.Away)),
			}),
			"full_time": json.ObjectNode("", map[string]*json.Node{
				"home": json.StringNode("home", strconv.Itoa(match.Scores.FullTime.Home)),
				"away": json.StringNode("away", strconv.Itoa(match.Scores.FullTime.Away)),
			}),
			"extra_time": json.ObjectNode("", map[string]*json.Node{
				"home": json.StringNode("home", strconv.Itoa(match.Scores.ExtraTime.Home)),
				"away": json.StringNode("away", strconv.Itoa(match.Scores.ExtraTime.Away)),
			}),
			"penalties": json.ObjectNode("", map[string]*json.Node{
				"home": json.StringNode("home", strconv.Itoa(match.Scores.Penalties.Home)),
				"away": json.StringNode("away", strconv.Itoa(match.Scores.Penalties.Away)),
			}),
		})

		matchJson := json.ObjectNode("", map[string]*json.Node{
			"id":          json.StringNode("id", strconv.Itoa(match.ID)),
			"home_team":   homeTeamJson,
			"away_team":   awayTeamJson,
			"league":      leagueJson,
			"date_time":   json.StringNode("date_time", match.DateTime),
			"scores": 	scoresJson,
			"status": 	json.StringNode("status", string(match.Status)),
			"bets": 	bettorsJson,
		})
		matchesJson.AppendArray(matchJson)
	}

	encoded, err := json.Marshal(matchesJson)
	if err != nil {
		panic(ufmt.Errorf("error: %v", err))
	}

	return string(encoded)
}
