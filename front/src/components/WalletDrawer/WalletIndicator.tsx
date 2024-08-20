import { Icon } from "@chakra-ui/react";
import { FC } from "react";
import { BsFillWalletFill } from "react-icons/bs";
import { useAccountStore } from "../../store";

const WalletIndicator: FC = () => {
  const { account } = useAccountStore();

  return (
    <Icon
      as={BsFillWalletFill}
      fontSize="32px"
      color={account ? "gray.700" : "red.300"}
    />
  );
};

export default WalletIndicator;
