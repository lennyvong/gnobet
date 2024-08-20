package gnorkle

type MatchData struct {
	HomeTeam Team   `json:"home_team"`
	AwayTeam Team   `json:"away_team"`
	League   League `json:"league"`
	DateTime string `json:"date_time"`
}

type Team struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type League struct {
	ID      string `json:"id"`
	Name    string `json:"name"`
	Country string `json:"country"`
	Season  string `json:"season"`
}
