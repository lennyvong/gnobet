package types

import (
	"fmt"

	"github.com/gnolang/gno/gnovm/stdlibs/std"
)

type EventData struct {
	Name       string
	PkgPath    string
	Function   string
	Attributes []Attribute
}

func (e EventData) AssertABCIEvent() {}

type Attribute struct {
	Key   string
	Value string
}

func convertToEventData(event interface{}) EventData {
	fmt.Println("Event: ", event.(std.GnoEvent).Type)
	panic("implement me")
}
