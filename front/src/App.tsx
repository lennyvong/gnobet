import { ChakraProvider } from "@chakra-ui/react";
import { GnoJSONRPCProvider } from "@gnolang/gno-js-client";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { FC, useEffect } from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { constants } from "./constants";
import Home from "./pages";
import { useProviderStore } from "./store";
import HomeLayout from "./layouts/HomeLayout";
import theme from "./theme";

const queryClient = new QueryClient();

const App: FC = () => {
  const { setProvider } = useProviderStore();

  useEffect(() => {
    const provider = new GnoJSONRPCProvider(constants.chainRPC);
    setProvider(provider);
  }, [setProvider]);

  return (
    <QueryClientProvider client={queryClient}>
      <ChakraProvider theme={theme}>
        <BrowserRouter>
          <Routes>
            <Route element={<HomeLayout />}>
              <Route index element={<Home />} />
            </Route>
          </Routes>
        </BrowserRouter>
      </ChakraProvider>
    </QueryClientProvider>
  );
};

export default App;
