package events

import (
	"github.com/gnolang/gno/gnovm/stdlibs/std"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/sports"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/sports/football"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/types"
)

type EventHandler struct {
	sports map[types.SportName]sports.Sport
}

func NewEventHandler() (*EventHandler, error) {
	football, err := football.NewSport()
	if err != nil {
		return nil, err
	}
	return &EventHandler{
		sports: map[types.SportName]sports.Sport{
			types.Football: football,
		},
	}, nil
}

func eventHandler(event std.GnoEvent) {
}
