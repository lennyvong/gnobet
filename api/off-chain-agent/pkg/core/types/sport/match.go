package sport

type Match struct {
	HomeTeam Team   `json:"home_team"`
	AwayTeam Team   `json:"away_team"`
	League   League `json:"league"`
	DateTime string `json:"date_time"`
}
