package football

import (
	"fmt"
	"os"
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
