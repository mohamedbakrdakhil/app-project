import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        "bg-primary": "#060810",
        "bg-secondary": "#0d1520",
        anatomy: "#ff4d6d",
        physiology: "#00d4ff",
        "text-primary": "#e8edf5",
        "text-secondary": "#9aa8ba",
        "text-muted": "#5a6678",
        success: "#00ff78",
        warning: "#ffb347",
        "xp-color": "#ffb347",
        "streak-color": "#ff4d6d",
      },
    },
  },
  plugins: [],
};

export default config;
