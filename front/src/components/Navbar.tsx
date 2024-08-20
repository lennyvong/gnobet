import {
  VStack,
  Card,
  StackDivider,
  HStack,
  Text,
  Image,
  Box,
  Drawer,
  DrawerBody,
  DrawerContent,
  DrawerOverlay,
  useDisclosure,
} from "@chakra-ui/react";
import { FC } from "react";
import Searchbar from "./Searchbar";
import WalletDrawer from "./WalletDrawer";
import WalletIndicator from "./WalletDrawer/WalletIndicator";

const topCompetitions = [
  {
    title: "Ligue 1",
    img: "https://cdn.ipregistry.co/flags/emojitwo/fr.svg",
  },
  {
    title: "Premier League",
    img: "https://cdn.ipregistry.co/flags/emojitwo/gb.svg",
  },
  {
    title: "La Liga",
    img: "https://cdn.ipregistry.co/flags/emojitwo/es.svg",
  },
  {
    title: "Serie A",
    img: "https://cdn.ipregistry.co/flags/emojitwo/it.svg",
  },
  {
    title: "Bundesliga",
    img: "https://cdn.ipregistry.co/flags/emojitwo/de.svg",
  },
];

const sports = [
  {
    title: "Football",
    img: "https://emojicdn.elk.sh/⚽️?style=twitter",
    isAvailable: true,
  },
  {
    title: "Basketball",
    img: "https://emojicdn.elk.sh/🏀?style=twitter",
  },
  {
    title: "Rugby",
    img: "https://emojicdn.elk.sh/🏉?style=twitter",
  },
  {
    title: "American Football",
    img: "https://emojicdn.elk.sh/🏈?style=twitter",
  },
  {
    title: "Tennis",
    img: "https://emojicdn.elk.sh/🎾?style=twitter",
  },
  {
    title: "Boxing",
    img: "https://emojicdn.elk.sh/🥊?style=twitter",
  },
  {
    title: "MMA",
    img: "https://emojicdn.elk.sh/🥋?style=twitter",
  },
];

const Navbar: FC = () => {
  const { isOpen, onOpen, onClose } = useDisclosure();

  return (
    <>
      <Drawer size="md" isOpen={isOpen} placement="left" onClose={onClose}>
        <DrawerOverlay />
        <DrawerContent onMouseLeave={onClose}>
          <DrawerBody p="16px" bg="gray.100">
            <WalletDrawer />
          </DrawerBody>
        </DrawerContent>
      </Drawer>
      <VStack
        spacing="24px"
        w="100%"
        h="100%"
        background="gray.200"
        align="start"
      >
        <HStack w="100%">
          <Searchbar />
          <Box onMouseEnter={onOpen}>
            <WalletIndicator />
          </Box>
        </HStack>
        <VStack align="start" w="100%">
          <Text fontWeight="bold">Top competitions</Text>
          <Card w="100%" p="8px">
            <VStack align="start" divider={<StackDivider />}>
              {topCompetitions.map(({ img, title }) => (
                <HStack key={title}>
                  <Image src={img} alt={title} width="24px" height="24px" />
                  <Text fontWeight="semibold" fontSize="14px">
                    {title}
                  </Text>
                </HStack>
              ))}
            </VStack>
          </Card>
        </VStack>
        <VStack align="start" w="100%">
          <Text fontWeight="bold">Sports</Text>
          <Card w="100%">
            <VStack align="start" divider={<StackDivider />} spacing={0}>
              {sports.map(({ img, title, isAvailable }) => (
                <HStack
                  transitionDuration="0.2s"
                  p="8px"
                  w="100%"
                  h="100%"
                  opacity={!isAvailable ? 0.5 : 1}
                  _hover={
                    !isAvailable
                      ? { cursor: "not-allowed" }
                      : { cursor: "pointer", bg: "gray.100" }
                  }
                  key={title}
                >
                  <Image src={img} alt={title} width="24px" height="24px" />
                  <Text userSelect="none" fontWeight="semibold" fontSize="14px">
                    {title}
                  </Text>
                </HStack>
              ))}
            </VStack>
          </Card>
        </VStack>
      </VStack>
    </>
  );
};

export default Navbar;
