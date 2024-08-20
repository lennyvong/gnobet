import {
  VStack,
  Divider,
  Wrap,
  Card,
  HStack,
  Text,
  Button,
  useToast,
  Box,
} from "@chakra-ui/react";
import { FC, useCallback, useEffect, useState } from "react";
import { BiCoinStack } from "react-icons/bi";
import { GiCrossedChains } from "react-icons/gi";
import { ImConnection } from "react-icons/im";
import { IoCopy } from "react-icons/io5";
import WalletIndicator from "./WalletIndicator";
import { useAccountStore } from "../../store";
import {
  establishConnection,
  switchNetwork,
  getAccountInfo,
} from "adena-sdk-ts";
import { constants } from "../../constants";

const WalletDrawer: FC = () => {
  const { account, setAccount } = useAccountStore();

  const [isLoading, setIsLoading] = useState(false);

  const toast = useToast();

  const handleWalletConnect = useCallback(() => {
    setIsLoading(true);

    establishConnection("gnobet")
      .then(() =>
        switchNetwork(constants.chainID).then(() =>
          getAccountInfo().then((info) => {
            setAccount(info);
            toast({
              colorScheme: "purple",
              title: "Connected to Adena",
              description: `Connected to ${info.address}`,
              status: "success",
              duration: 3000,
              isClosable: true,
            });
          })
        )
      )
      .catch((e) => {
        console.error(e);
        toast({
          title: "Failed to connect to Adena",
          description: "Please make sure you have the Adena wallet installed",
          status: "error",
          duration: 5000,
          isClosable: true,
        });
      })
      .finally(() => setIsLoading(false));
  }, [setAccount, toast]);

  useEffect(() => {
    handleWalletConnect();
  }, [handleWalletConnect, setAccount]);

  return (
    <VStack spacing="24px">
      <WalletIndicator />
      <Divider />
      {account ? (
        <VStack>
          <HStack>
            <Text>{account?.address}</Text>
            <Box
              onClick={() => {
                navigator.clipboard.writeText(account?.address);
                toast({
                  title: "Address copied",
                  status: "success",
                  duration: 2000,
                  isClosable: true,
                });
              }}
              cursor="pointer"
              color="gray.700"
              _hover={{
                color: "gray.600",
              }}
            >
              <IoCopy />
            </Box>
          </HStack>
          <Button size="sm" onClick={() => setAccount(null)}>
            Disconnect Wallet
          </Button>
        </VStack>
      ) : (
        <Button
          onClick={handleWalletConnect}
          loadingText="Connecting wallet"
          isLoading={isLoading}
        >
          Connect Wallet
        </Button>
      )}
      <Divider />
      {!!account && (
        <Wrap>
          <Card p="16px">
            <HStack>
              <ImConnection color="blue" fontSize="24px" />
              <Text>{account?.status}</Text>
            </HStack>
          </Card>
          <Card p="16px">
            <HStack>
              <BiCoinStack color="gold" fontSize="24px" />
              <Text>{account?.coins}</Text>
            </HStack>
          </Card>
          <Card p="16px">
            <HStack>
              <GiCrossedChains color="red" fontSize="24px" />
              <Text>{account?.chainId}</Text>
            </HStack>
          </Card>
        </Wrap>
      )}
    </VStack>
  );
};

export default WalletDrawer;
