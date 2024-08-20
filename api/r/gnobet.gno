package gnobet

import (
	"std"
	"strconv"

	"gno.land/p/demo/gnorkle/feeds/continious"
	"gno.land/p/demo/gnorkle/gnorkle"
	"gno.land/p/demo/gnorkle/message"
  	"gno.land/p/demo/ufmt"
  	"gno.land/p/demo/json"
)

var (
	ownerAddress = std.GetOrigCaller()
	oracle 	 *gnorkle.Instance
	postHandler = &postGnorkleMessageHandler{}

	matches = &[]MatchData{}
)

type postGnorkleMessageHandler struct {}

// Handle handles the gnorkle message
func (h postGnorkleMessageHandler) Handle(i *gnorkle.Instance, funcType message.FuncType, feed gnorkle.Feed) error {
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
   ufmt.Println("decodedData.Size(): ", decodedData.Size())
   for i := 0; i < decodedData.Size(); i++ {
	 node, err := decodedData.GetIndex(i)
	 if err != nil {
	   ufmt.Println("error getting node")
	   return nil
	 }
	 ufmt.Println("CACA")
	 test, err := MatchDataFromJSON(node, len(*matches))
	 if err != nil {
	   ufmt.Println("error decoding data")
	   return nil
	 }
	 ufmt.Println("ICI")
	 ufmt.Println("test ", i, ":", test.HomeTeam.Name)
	 *matches = append(*matches, test)
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
func RequestMatchDate(date string) {
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
	std.Emit("RequestMatchesDate", "sport", "football", "date", date)
}

// GnorkleEntrypoint is the entrypoint for the oracle by the off-chain agent
func GnorkleEntrypoint(message string) string {
	result, err := oracle.HandleMessage(message, postHandler)
	if err != nil {
		panic(err)
	}

	return result
}

func Test() string {
	bets := &[]Bet{}

	for _, match := range *matches {
		if match.ID == 0 {
			bets = &match.Bets
		}
	}
	return (*bets)[0].Bettor.String()
}

// BetOnAMatch allows a user to bet on a match
func BetOnAMatch(matchID int) {
	coinSent := std.GetOrigSend() // get Coins sent with call
	caller := std.GetOrigCaller() // get tx sender

	(*matches)[matchID].Bets = append((*matches)[matchID].Bets, Bet{
		Bettor: caller,
		ID:     len((*matches)[matchID].Bets),
		Amount: int(coinSent.AmountOf("ugnot")),
	})
}

func GetMatches() string {
	matchesJson := json.ArrayNode("", []*json.Node{})
	for _, match := range *matches {
		betsJson := json.ArrayNode("", []*json.Node{})
		for _, bet := range match.Bets {
			betJson := json.ObjectNode("", map[string]*json.Node{
				"bettor":     json.StringNode("bettor", bet.Bettor.String()),
				"id": json.StringNode("id", strconv.Itoa(bet.ID)),
				"amout":  json.StringNode("amount", strconv.Itoa(bet.Amount)),
			})
			betsJson.AppendArray(betJson)
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
			"bets": 	betsJson,
		})
		matchesJson.AppendArray(matchJson)
	}

	encoded, err := json.Marshal(matchesJson)
	if err != nil {
		panic(ufmt.Errorf("error: %v", err))
	}

	return string(encoded)
}
