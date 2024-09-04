package sports

import (
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/types/gnorkle"
)

type Sport interface {
	GetOddsOfMatch(fixtureID string) (gnorkle.OddData, error)
	GetMatchesAtDate(date string, day_interval string) ([]gnorkle.MatchData, error)
}
