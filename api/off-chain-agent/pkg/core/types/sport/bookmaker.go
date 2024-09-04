package sport

type Bookmaker struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
	Bets []Bet  `json:"bets"`
}
