package onchain

import (
	"errors"
	"os"

	"github.com/gnolang/gno/gno.land/pkg/gnoclient"
	rpcclient "github.com/gnolang/gno/tm2/pkg/bft/rpc/client"
	"github.com/gnolang/gno/tm2/pkg/crypto/keys"
	log "github.com/sirupsen/logrus"
)

func Setup() (gnoclient.Client, error) {
	gnokey_path := os.Getenv("GNOKEY_PATH")
	if gnokey_path == "" {
		return gnoclient.Client{}, errors.New("GNOKEY_PATH not set")
	}
	gnokey_account := os.Getenv("GNOKEY_ACCOUNT")
	if gnokey_account == "" {
		return gnoclient.Client{}, errors.New("GNOKEY_ACCOUNT not set")
	}
	gnokey_password := os.Getenv("GNOKEY_PASSWORD")
	if gnokey_password == "" {
		return gnoclient.Client{}, errors.New("GNOKEY_PASSWORD not set")
	}
	gnokey_chainid := os.Getenv("GNOKEY_CHAIN_ID")
	if gnokey_chainid == "" {
		return gnoclient.Client{}, errors.New("GNOKEY_CHAIN_ID not set")
	}
	rpc_url := os.Getenv("RPC_URL")
	if rpc_url == "" {
		return gnoclient.Client{}, errors.New("RPC_URL not set")
	}

	keybase, _ := keys.NewKeyBaseFromDir(gnokey_path)

	signer := gnoclient.SignerFromKeybase{
		Keybase:  keybase,
		Account:  gnokey_account,
		Password: gnokey_password,
		ChainID:  gnokey_chainid,
	}
	rpc, err := rpcclient.NewHTTPClient(rpc_url)
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
