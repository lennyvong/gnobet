package sport

type League struct {
	ID      int    `json:"id"`
	Name    string `json:"name"`
	Country string `json:"country"`
	Season  int    `json:"season"`
}
