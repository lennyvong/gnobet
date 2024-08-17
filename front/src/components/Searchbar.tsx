import { HStack, InputGroup, InputLeftElement, Input } from "@chakra-ui/react";
import { FC } from "react";
import { BiSearch } from "react-icons/bi";

const Searchbar: FC = () => {
  return (
    <HStack
      w="100%"
      h="40px"
      background="white"
      borderRadius="8px"
      justify="space-between"
    >
      <InputGroup>
        <InputLeftElement children={<BiSearch />} />
        <Input placeholder="Search" />
      </InputGroup>
    </HStack>
  );
};

export default Searchbar;
