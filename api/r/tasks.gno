package gnobet

import (
	"bufio"
	"bytes"
)

type matchDateTask struct {
	date string
}

// MarshalJSON marshals the task contents to JSON.
func (t *matchDateTask) MarshalJSON() ([]byte, error) {
	buf := new(bytes.Buffer)
	w := bufio.NewWriter(buf)

	w.Write(
		[]byte(`{"date":"` + t.date + `"}`),
	)

	w.Flush()
	return buf.Bytes(), nil
}