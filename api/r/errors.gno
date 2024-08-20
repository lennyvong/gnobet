package gnobet

import "errors"

var (
	ErrInvalidDate = errors.New("invalid date")
	ErrWrongAmount = errors.New("wrong amount")
)