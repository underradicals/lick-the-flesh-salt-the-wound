import { defineConfig, UserConfig, BuildEnvironmentOptions } from "vite";
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import autoprefixer from "autoprefixer";
import presetENV from "postcss-preset-env";

const __dirname = dirname(fileURLToPath(import.meta.url))

type Server = UserConfig["server"]
type CSS = UserConfig["css"]

const ServerOptions = {

} satisfies Server;


const BuildOptions = {

} satisfies BuildEnvironmentOptions;


const CSSOptions = {
  postcss: {
    plugins: [presetENV, autoprefixer]
  }
} satisfies CSS;

const ViteConfiguration = {

} satisfies UserConfig;


export default defineConfig(ViteConfiguration);