import { InputGroup, InputLeftElement, Input } from "@chakra-ui/react";
import { FC } from "react";
import { BiSearch } from "react-icons/bi";

const Searchbar: FC = () => {
  return (
    <InputGroup borderColor="gray.600">
      <InputLeftElement color="gray.100" children={<BiSearch />} />
      <Input placeholder="Search" />
    </InputGroup>
  );
};

export default Searchbar;
