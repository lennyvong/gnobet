package sports

import (
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/types/gnorkle"
)

type Sport interface {
	GetMatchesAtDate(date string, day_interval string) ([]gnorkle.MatchData, error)
}
