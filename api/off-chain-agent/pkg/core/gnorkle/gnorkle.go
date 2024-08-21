package gnorkle

import (
	"encoding/json"
	"fmt"

	"github.com/gnolang/gno/gno.land/pkg/gnoclient"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/core/onchain"
	log "github.com/sirupsen/logrus"
)

type GnorkleCommand string

const (
	IngestCommit GnorkleCommand = "ingest_commit"
	Ingest       GnorkleCommand = "ingest"
	Commit       GnorkleCommand = "commit"
)

func Entrypoint[T any](cmd GnorkleCommand, id string, data T, pkgPath string, funcName string) error {
	log.Info("Sending gnorkle transaction")
	signerInfo, err := onchain.Signer.Info()
	if err != nil {
		return err
	}
	accountRes, _, err := onchain.Client.QueryAccount(signerInfo.GetAddress())
	if err != nil {
		return err
	}
	encodedData, err := json.Marshal(data)
	if err != nil {
		return err
	}
	txCfg := gnoclient.BaseTxCfg{
		GasFee:         "1000000ugnot",                 // gas price
		GasWanted:      2000000,                        // gas limit
		AccountNumber:  accountRes.GetAccountNumber(),  // account ID
		SequenceNumber: accountRes.GetSequence(),       // account nonce
		Memo:           "This is a cool how-to guide!", // transaction memo
	}
	msg := gnoclient.MsgCall{}
	switch cmd {
	case Ingest:
		msg = gnoclient.MsgCall{
			PkgPath:  pkgPath,                                                      // wrapped ugnot realm path
			FuncName: funcName,                                                     // function to call
			Args:     []string{string(cmd) + "," + id + "," + string(encodedData)}, // arguments in string format
			Send:     "",                                                           // coins to send along with transaction
		}
	case Commit:
		msg = gnoclient.MsgCall{
			PkgPath:  pkgPath,                   // wrapped ugnot realm path
			FuncName: funcName,                  // function to call
			Args:     []string{string(cmd), id}, // arguments in string format
			Send:     "",                        // coins to send along with transaction
		}
	case IngestCommit:
		msg = gnoclient.MsgCall{
			PkgPath:  pkgPath,                                                      // wrapped ugnot realm path
			FuncName: funcName,                                                     // function to call
			Args:     []string{string(cmd) + "," + id + "," + string(encodedData)}, // arguments in string format
			Send:     "",                                                           // coins to send along with transaction
		}
	default:
		return fmt.Errorf("invalid command: %s", cmd)
	}
	res, err := onchain.Client.Call(txCfg, msg)
	if err != nil {
		return err
	}
	log.Info("Gnorkle transaction sent: ", res)
	return nil
}
