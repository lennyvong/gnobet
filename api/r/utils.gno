package gnobet

import (
	"strings"
	"strconv"
)

func checkDate(date string) error {
	if len(date) != 10 {
		return ErrInvalidDate
	}

	for _, nb := range strings.Split(date, "-") {
		if _, err := strconv.Atoi(nb); err != nil {
			return ErrInvalidDate
		}
	}

	return nil
}