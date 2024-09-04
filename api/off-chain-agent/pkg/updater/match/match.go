package match

import (
	"fmt"
	"time"

	"github.com/gnolang/gno/gno.land/pkg/gnoclient"
	"github.com/lennyvong/gnobet/off-chain-agent/pkg/updater/utils"
	log "github.com/sirupsen/logrus"
)

func UpdateMatchList(client gnoclient.Client, signer gnoclient.Signer) error {
	fmt.Println("UpdateMatchList")
	signerInfo, err := signer.Info()
	if err != nil {
		return err
	}
	for {
		now := time.Now()
		formattedNow := now.Format("2006-01-02")
		txConfig := utils.TxConfig{
			GasFee:    "1000000ugnot",
			GasWanted: 20000000,
			Memo:      "Match List Update",
		}
		utils.CallReq(signerInfo, client, txConfig, gnoclient.MsgCall{
			PkgPath:  "gno.land/r/demo/gnobet",
			FuncName: "RequestMatchDate",
			Args:     []string{"football", formattedNow, "7"},
		})
		if err != nil {
			log.Info("Failed to update match list: ", err)
			time.Sleep(5 * time.Minute)
			continue
		}
		time.Sleep(7 * (12 * time.Hour))
	}
}
