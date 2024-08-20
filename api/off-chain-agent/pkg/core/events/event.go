package events

import (
	"fmt"

	"github.com/gnolang/gno/gnovm/stdlibs/std"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/gnorkle"
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

func (e *EventHandler) HandleEvent(event std.GnoEvent) error {
	log.WithField("event", event).Info("handling event")
	switch event.Type {
	case "RequestMatchesDate":
		{
			matches, err := e.sports[types.SportName(event.Attributes[0].Value)].GetMatchesAtDate(event.Attributes[1].Value)
			if err != nil {
				return fmt.Errorf("failed to get matches: %w", err)
			}
			err = gnorkle.Entrypoint(gnorkle.IngestCommit, event.Attributes[1].Value, matches, "gno.land/r/demo/gnobet", "GnorkleEntrypoint")
			if err != nil {
				return err
			}
		}
	}
	return nil
}
