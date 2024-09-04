import {
  Box,
  Button,
  Card,
  HStack,
  StackDivider,
  Text,
  VStack,
} from "@chakra-ui/react";
import { FC } from "react";
import { Outlet } from "react-router-dom";
import Navbar from "../components/Navbar";

const HomeLayout: FC = () => {
  return (
    <HStack
      background="gray.800"
      w="100%"
      h="100vh"
      align="start"
      justify="space-between"
    >
      <Box maxW="400px" p="24px" w="100%" h="100%">
        <Navbar />
      </Box>
      <Box p="24px" w="100%" h="100%">
        <Outlet />
      </Box>
      <Box maxW="400px" p="24px" w="100%" h="100%">
        <Card bg="gray.700" w="100%" h="100%" borderRadius="12px">
          <VStack
            p="12px"
            align="start"
            w="100%"
            h="100%"
            divider={<StackDivider borderColor="gray.700" />}
          >
            <HStack>
              <Text fontSize="14px" fontWeight="semibold" userSelect="none">
                0 selection
              </Text>
            </HStack>
            <VStack h="100%" w="100%" justify="center" textAlign="center">
              <Text fontWeight="bold">Add your first bet !</Text>
              <Text fontWeight="semibold" fontSize="14px" color="gray.500">
                You didn't select any bets, click on one to add it to the cart
              </Text>
            </VStack>
            <VStack w="100%" spacing="16px">
              <HStack w="100%" justify="space-between">
                <Text fontWeight="bold">Possible gains</Text>
                <Text fontWeight="bold">0 ugnot</Text>
              </HStack>
              <Button variant="primary" w="100%">
                Bet
              </Button>
            </VStack>
          </VStack>
        </Card>
      </Box>
    </HStack>
  );
};

export default HomeLayout;
