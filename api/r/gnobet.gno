package gnobet

import (
	"std"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/gnorkle/feeds/static"
	"gno.land/p/demo/gnorkle/gnorkle"
	"gno.land/p/demo/gnorkle/message"
)

var (
	ownerAddress = std.GetOrigCaller()
	oracle 	 *gnorkle.Instance
	postHandler = &postGnorkleMessageHandler{}

	matchResult = avl.NewTree()
)

type postGnorkleMessageHandler struct {}

// Handle handles the gnorkle message
func (h postGnorkleMessageHandler) Handle(i *gnorkle.Instance, funcType message.FuncType, feed gnorkle.Feed) error {
	if funcType != message.FuncTypeIngest {
		return nil
	}

	_, _, consumable := feed.Value()
	if !consumable {
		return nil
	}

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
		static.NewSingleValueFeed(
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
