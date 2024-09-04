package main

import (
	"log"

	"github.com/gnolang/gno/gno.land/pkg/gnoclient"
	"github.com/joho/godotenv"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/events"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/listener"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/onchain"
)

var Signer gnoclient.Signer

func main() {
	// Load the .env file
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("error: failed to load the env file")
	}

	client, err := onchain.Setup()
	if err != nil {
		log.Fatal(err)
	}
	eventHandler, err := events.NewEventHandler()
	if err != nil {
		log.Fatal(err)
	}
	err = listener.Run(client, *eventHandler)
	if err != nil {
		log.Fatal(err)
	}
}
