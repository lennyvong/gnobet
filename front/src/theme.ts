import { extendTheme } from "@chakra-ui/react";

const theme = extendTheme({
  fonts: {
    heading: "Poppins, sans-serif",
    body: "Whyte, sans-serif",
  },
  components: {
    Card: {
      parts: ["container"],
      baseStyle: {
        container: {
          border: `1px solid black`,
          boxShadow: "lg",
          bg: "gray.800",
        },
      },
    },
    Button: {
      variants: {
        primary: {
          bg: "red.700",
          color: "gray.50",
          _hover: {
            bg: "red.800",
          },
        },
      },
      defaultProps: {
        size: "md",
        variant: "primary",
      },
    },
    Text: {
      baseStyle: {
        color: "gray.50",
      },
    },
  },
});

export default theme;
