import {
  VStack,
  Text,
  Card,
  HStack,
  Image,
  SimpleGrid,
} from "@chakra-ui/react";
import { FC } from "react";

const fixtures = [
  {
    teamA: "Real Madrid",
    teamB: "Barcelona",
    competition: "La Liga",
    competitionFlag: "https://cdn.ipregistry.co/flags/emojitwo/es.svg",
    sportLogo: "https://emojicdn.elk.sh/⚽️?style=twitter",
    scoreA: 2,
    scoreB: 1,
    bets: [30, 7.75, 1.5],
  },
  {
    teamA: "Manchester City",
    teamB: "Liverpool",
    competition: "Premier League",
    competitionFlag: "https://cdn.ipregistry.co/flags/emojitwo/gb.svg",
    sportLogo: "https://emojicdn.elk.sh/⚽️?style=twitter",
    scoreA: 0,
    scoreB: 0,
    bets: [2.5, 3.5, 2.5],
  },
  {
    teamA: "Juventus",
    teamB: "Inter Milan",
    competition: "Serie A",
    competitionFlag: "https://cdn.ipregistry.co/flags/emojitwo/it.svg",
    sportLogo: "https://emojicdn.elk.sh/⚽️?style=twitter",
    scoreA: 1,
    scoreB: 2,
    bets: [2.5, 3.5, 2.5],
  },
];

const Home: FC = () => {
  return (
    <SimpleGrid columns={{ base: 1, xl: 2 }} w="100%" spacing="24px">
      {fixtures.map((fixture) => (
        <Card p="12px" bg="gray.700" w="100%" key={fixture.teamA}>
          <VStack w="100%" h="100%" justify="space-between">
            <HStack w="100%" justify="space-between">
              <HStack spacing={0}>
                <Image src={fixture.sportLogo} h="20px" w="20px" />
                <Image
                  left="-5px"
                  position="relative"
                  src={fixture.competitionFlag}
                  h="20px"
                  w="20px"
                />
              </HStack>
              <Text fontWeight="semibold" fontSize="14px" color="gray.500">
                {fixture.competition}
              </Text>
              <Text fontWeight="semibold" color="red.500" fontSize="12px">
                25'
              </Text>
            </HStack>
            <VStack
              spacing={0}
              w="100%"
              h="100%"
              justify="center"
              textAlign="center"
            >
              <Text fontWeight="bold">
                {fixture.teamA} - {fixture.teamB}
              </Text>
              <Text fontWeight="black">
                {fixture.scoreA} - {fixture.scoreB}
              </Text>
            </VStack>
            <HStack w="100%">
              {fixture.bets.map((bet) => (
                <Card bg="gray.800" align="center" w="100%" p="8px" key={bet}>
                  <Text fontWeight="bold">{bet}</Text>
                </Card>
              ))}
            </HStack>
          </VStack>
        </Card>
      ))}
    </SimpleGrid>
  );
};

export default Home;
