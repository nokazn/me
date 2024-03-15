import { defineConfig } from "vite";
// @ts-expect-error
import elmPlugin from "vite-plugin-elm";

export default defineConfig({
  plugins: [elmPlugin()],
  assetsInclude: ["**/*.jpg"],
});
