import { GnoJSONRPCProvider } from "@gnolang/gno-js-client";
import { create } from "zustand";
import { persist } from "zustand/middleware";

enum EAccountStatus {
  ACTIVE = "ACTIVE",
  INACTIVE = "IN_ACTIVE",
}

interface IPublicKeyInfo {
  "@type": string;
  value: string;
}

interface IAccountInfo {
  accountNumber: string;
  address: string;
  coins: string;
  chainId: string;
  sequence: string;
  status: EAccountStatus;
  public_key: IPublicKeyInfo;
}

const useAccountStore = create<{
  account: IAccountInfo | null;
  setAccount: (account: IAccountInfo | null) => void;
}>((set) => ({
  account: null,
  setAccount: (account) => set({ account }),
}));

const useProviderStore = create<{
  provider: GnoJSONRPCProvider | null;
  setProvider: (provider: GnoJSONRPCProvider) => void;
}>()(
  persist(
    (set) => ({
      provider: null,
      setProvider: (provider: GnoJSONRPCProvider) => set({ provider }),
    }),
    {
      name: "provider-storage",
    }
  )
);

export { useAccountStore, useProviderStore };
