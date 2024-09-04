package main

import (
	"github.com/lennyvong/gnobet/off-chain-agent/cmd/core"
	"github.com/lennyvong/gnobet/off-chain-agent/cmd/updater"
)

func main() {
	go core.Main()
	updater.Main()
}
