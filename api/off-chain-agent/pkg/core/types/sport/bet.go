package sport

type Bet struct {
	Name      string     `json:"name"`
	BetValues []BetValue `json:"values"`
}

type BetValue struct {
	Value string `json:"value"`
	Odd   string `json:"odd"`
}
