package main

import (
	"log"

	"github.com/gnolang/gno/gno.land/pkg/gnoclient"
	rpcclient "github.com/gnolang/gno/tm2/pkg/bft/rpc/client"
	"github.com/gnolang/gno/tm2/pkg/crypto/keys"
	"github.com/joho/godotenv"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/listener"
)

func setup() gnoclient.Client {
	keybase, _ := keys.NewKeyBaseFromDir("/Users/lennyvongphouthone/Library/Application Support/gno")

	signer := gnoclient.SignerFromKeybase{
		Keybase:  keybase,
		Account:  "caca2",
		Password: "lenny",
		ChainID:  "dev",
	}
	rpc, err := rpcclient.NewHTTPClient("http://127.0.0.1:26657")
	if err != nil {
		panic(err)
	}

	client := gnoclient.Client{
		Signer:    signer,
		RPCClient: rpc,
	}
	log.Println("Signer and RPCClient initialized")
	return client
}

func main() {
	// Load the .env file
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("error: failed to load the env file")
	}

	client := setup()

	err = listener.Run(client)
	if err != nil {
		log.Fatal(err)
	}
}
