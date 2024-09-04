package utils

import (
	"github.com/gnolang/gno/gno.land/pkg/gnoclient"
	"github.com/gnolang/gno/tm2/pkg/crypto/keys"
	log "github.com/sirupsen/logrus"
)

type TxConfig struct {
	GasFee    string
	GasWanted int64
	Memo      string
}

func CallReq(signer keys.Info, client gnoclient.Client, txCfg TxConfig, msgCall gnoclient.MsgCall) {
	log.Info("Sending a Call Request")
	accountRes, _, err := client.QueryAccount(signer.GetAddress())
	if err != nil {
		panic(err)
	}
	baseTxCfg := gnoclient.BaseTxCfg{
		GasFee:         txCfg.GasFee,
		GasWanted:      txCfg.GasWanted,
		AccountNumber:  accountRes.GetAccountNumber(),
		SequenceNumber: accountRes.GetSequence(),
		Memo:           txCfg.Memo,
	}
	_, err = client.Call(baseTxCfg, msgCall)
	if err != nil {
		panic(err)
	}
}
