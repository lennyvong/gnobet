package events

import (
	"fmt"

	"github.com/gnolang/gno/gnovm/stdlibs/std"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/sports"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/sports/football"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/types"
	log "github.com/sirupsen/logrus"
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

func (e *EventHandler) HandleEvent(event std.GnoEvent) {
	switch event.Type {
	case "RequestMatchesDate":
		{
			matches, err := e.sports[types.SportName(event.Attributes[0].Value)].GetMatchesAtDate(event.Attributes[1].Value)
			if err != nil {
				log.WithField("error", err).Error("failed to get matches")
				return
			}
			fmt.Println(matches)
		}
	}
}
