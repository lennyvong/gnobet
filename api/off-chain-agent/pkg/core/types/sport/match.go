package sport

type Match struct {
	HomeTeam Team   `json:"homeTeam"`
	AwayTeam Team   `json:"awayTeam"`
	League   League `json:"league"`
	DateTime string `json:"dateTime"`
}
