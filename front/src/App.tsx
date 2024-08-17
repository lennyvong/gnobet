import {
  Box,
  ChakraProvider,
  Drawer,
  DrawerBody,
  DrawerContent,
  DrawerOverlay,
  HStack,
  useDisclosure,
} from "@chakra-ui/react";
import { GnoJSONRPCProvider } from "@gnolang/gno-js-client";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { FC, useEffect } from "react";
import { BrowserRouter, Outlet, Route, Routes } from "react-router-dom";
import { constants } from "./constants";
import Home from "./pages";
import { useProviderStore } from "./store";
import WalletDrawer from "./components/WalletDrawer";
import WalletIndicator from "./components/WalletDrawer/WalletIndicator";

const Layout: FC = () => {
  const { isOpen, onClose, onOpen } = useDisclosure();

  return (
    <>
      <Drawer size="md" isOpen={isOpen} placement="right" onClose={onClose}>
        <DrawerOverlay />
        <DrawerContent onMouseLeave={onClose}>
          <DrawerBody p="16px" bg="gray.100">
            <WalletDrawer />
          </DrawerBody>
        </DrawerContent>
      </Drawer>
      <HStack w="100%" h="100vh" align="start" justify="space-between">
        <Outlet />
        <Box
          onMouseEnter={onOpen}
          right="0px"
          position="fixed"
          h="100%"
          p="16px"
        >
          <WalletIndicator />
        </Box>
      </HStack>
    </>
  );
};

const queryClient = new QueryClient();

const App: FC = () => {
  const { setProvider } = useProviderStore();

  useEffect(() => {
    const provider = new GnoJSONRPCProvider(constants.chainRPC);
    setProvider(provider);
  }, [setProvider]);

  return (
    <QueryClientProvider client={queryClient}>
      <ChakraProvider>
        <BrowserRouter>
          <Routes>
            <Route element={<Layout />}>
              <Route index element={<Home />} />
            </Route>
          </Routes>
        </BrowserRouter>
      </ChakraProvider>
    </QueryClientProvider>
  );
};

export default App;
