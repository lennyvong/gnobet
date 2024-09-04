package updater

import (
	"log"
	"sync"

	"github.com/joho/godotenv"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/onchain"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/updater/match"
)

var wg sync.WaitGroup

func Main() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("error: failed to load the env file")
	}

	client, err := onchain.Setup()
	if err != nil {
		log.Fatal(err)
	}
	wg.Add(1)
	go match.UpdateMatchList(client, onchain.Signer)
	wg.Wait()
}
