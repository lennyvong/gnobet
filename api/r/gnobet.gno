package gnobet

import (
	"std"

	"gno.land/p/demo/gnorkle/feeds/continious"
	"gno.land/p/demo/gnorkle/gnorkle"
	"gno.land/p/demo/gnorkle/message"
  	"gno.land/p/demo/ufmt"
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

  ufmt.Println("result.String : ", result.String[0].(MatchData))
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

func GetMatches() []MatchData {
  return *matches
}
