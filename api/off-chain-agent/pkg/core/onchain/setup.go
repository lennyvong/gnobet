package onchain

import (
	"github.com/gnolang/gno/gno.land/pkg/gnoclient"
	rpcclient "github.com/gnolang/gno/tm2/pkg/bft/rpc/client"
	"github.com/gnolang/gno/tm2/pkg/crypto/keys"
	log "github.com/sirupsen/logrus"
)

func Run() (gnoclient.Client, error) {
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

	Client = gnoclient.Client{
		Signer:    signer,
		RPCClient: rpc,
	}

	Signer = signer
	log.Info("RPC and Keybase setup complete")
	return Client, nil
}
