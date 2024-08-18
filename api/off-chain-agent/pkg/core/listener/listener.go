package listener

import (
	"log"

	"github.com/gnolang/gno/gno.land/pkg/gnoclient"
	"github.com/gnolang/gno/gnovm/stdlibs/std"
)

func Listener(client gnoclient.Client) error {
	prevHeight, err := client.LatestBlockHeight()
	if err != nil {
		return err
	}

	log.Println("Listening for events: ")
	for {
		height, err := client.LatestBlockHeight()
		if err != nil {
			return err
		}
		if height <= prevHeight {
			continue
		}

		for i := prevHeight; i < height; i++ {
			blockResult, err := client.BlockResult(i)
			if err != nil {
				return err
			}

			for _, tx := range blockResult.Results.DeliverTxs {
				for _, event := range tx.Events {
					if event.(std.GnoEvent).PkgPath == "gno.land/r/demo/gnobet" {
						// eventsHandler(event.(std.GnoEvent))
					}
				}
			}
		}
		prevHeight = height
	}
}
