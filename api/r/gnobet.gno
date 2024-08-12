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

	matchResult := avl.NewTree()
)

type postGnorkleMessageHandler struct {}

func (h postGnorkleMessageHandler) Handle(i *gnorkle.Instance, funcType message.FuncType, feed gnorkle.Feed) error {
	if funcType != message.FuncTypeIngest {
		return nil
	}

	result, _, consumable := feed.Value()
	if !consumable {
		return nil
	}

	return nil
}

func init() {
	oracle := gnorkle.NewInstance()
	oracle.AddToWhitelist("", []string{string(ownerAddress)})
}

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
}

func GnorkleEntrypoint(message string) string {
	result, err := oracle.HandleMessage(message, postHandler)
	if err != nil {
		panic(err)
	}

	return result
}