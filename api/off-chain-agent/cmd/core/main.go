package main

import (
	"log"

	"github.com/gnolang/gno/gno.land/pkg/gnoclient"
	rpcclient "github.com/gnolang/gno/tm2/pkg/bft/rpc/client"
	"github.com/gnolang/gno/tm2/pkg/crypto/keys"
	"github.com/joho/godotenv"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/events"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/listener"
)

func setup() (gnoclient.Client, error) {
	keybase, _ := keys.NewKeyBaseFromDir("/Users/lennyvongphouthone/Library/Application Support/gno")

	signer := gnoclient.SignerFromKeybase{
		Keybase:  keybase,
		Account:  "caca2",
		Password: "lenny",
		ChainID:  "dev",
	}
	rpc, err := rpcclient.NewHTTPClient("http://127.0.0.1:26657")
	if err != nil {
		return gnoclient.Client{}, err
	}

	client := gnoclient.Client{
		Signer:    signer,
		RPCClient: rpc,
	}
	log.Println("Signer and RPCClient initialized")
	return client, nil
}

func main() {
	// Load the .env file
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("error: failed to load the env file")
	}

	client, err := setup()
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
