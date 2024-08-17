import { from } from "env-var";

const vars = {
  VITE_CHAIN_ID: import.meta.env.VITE_CHAIN_ID,
  VITE_CHAIN_RPC: import.meta.env.VITE_CHAIN_RPC,
  VITE_REALM_PATH: import.meta.env.VITE_REALM_PATH,
};

const env = from(vars, {});

export const constants = {
  chainID: env.get("VITE_CHAIN_ID").default("dev").asString(),
  chainRPC: env
    .get("VITE_CHAIN_RPC")
    .default("http://127.0.0.1:26657")
    .asString(),
  realmPath: env
    .get("VITE_REALM_PATH")
    .default("gno.land/r/demo/gnobet")
    .asString(),
};
