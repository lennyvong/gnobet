package sport

type Fixture struct {
	ID       int    `json:"id"`
	Date     string `json:"date"`
	TimeZone string `json:"timezone"`
}
