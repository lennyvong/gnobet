package sports

import (
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/types/sport"
)

type Sport interface {
	GetMatchesAtDate(date string) ([]sport.Match, error)
}
