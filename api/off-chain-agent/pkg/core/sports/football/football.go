package football

import (
	"fmt"
	"os"

	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/types/sport"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/utils"
)

type Sport struct {
	ApiUrl string
	ApiKey string
}

func NewSport() (*Sport, error) {
	apiUrl := os.Getenv("FOOTBALL_API_URL")
	if apiUrl == "" {
		return nil, fmt.Errorf("FOOTBALL_API_URL is not set")
	}
	apiKey := os.Getenv("FOOTBALL_API_KEY")
	if apiKey == "" {
		return nil, fmt.Errorf("FOOTBALL_API_KEY is not set")
	}

	return &Sport{
		ApiUrl: apiUrl,
		ApiKey: apiKey,
	}, nil
}

type GetFixturesResponse struct {
	Response []struct {
		Fixture sport.Fixture `json:"fixture"`
		League  sport.League  `json:"league"`
		Teams   struct {
			HomeTeam sport.Team `json:"home"`
			AwayTeam sport.Team `json:"away"`
		} `json:"teams"`
	}
}

func (s *Sport) GetMatchesAtDate(date string) ([]sport.Match, error) {
	res := []sport.Match{}
	getMatchRes, err := utils.GetFromJsonReq[GetFixturesResponse](s.ApiUrl+"/fixtures?date="+date+"&league=39&season=2024", utils.GET, "",
		[]utils.Header{
			{
				Key:   "x-rapidapi-key",
				Value: s.ApiKey,
			},
			{
				Key:   "x-rapidapi-host",
				Value: "api-football-v1.p.rapidapi.com",
			},
		}, "")
	if err != nil {
		return nil, fmt.Errorf("failed to get matches: %w", err)
	}
	for _, match := range getMatchRes.Response {
		res = append(res, sport.Match{
			HomeTeam: match.Teams.HomeTeam,
			AwayTeam: match.Teams.AwayTeam,
			League:   match.League,
			DateTime: match.Fixture.Date,
		})
	}
	return res, nil
}
