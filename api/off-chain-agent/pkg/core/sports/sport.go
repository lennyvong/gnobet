package sports

import (
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/types/gnorkle"
)

type Sport interface {
	GetMatchesAtDate(date string) ([]gnorkle.MatchData, error)
}
