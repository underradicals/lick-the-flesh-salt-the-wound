import { defineConfig, UserConfig, BuildEnvironmentOptions } from "vite";
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import autoprefixer from "autoprefixer";
import presetENV from "postcss-preset-env";

const __dirname = dirname(fileURLToPath(import.meta.url))

type Server = UserConfig["server"]
type CSS = UserConfig["css"]

const ServerOptions = {
  port: 3000,
  host: '0.0.0.0'
} satisfies Server;


const BuildOptions = {
  outDir: 'dist',
  emptyOutDir: true,
} satisfies BuildEnvironmentOptions;


const CSSOptions = {
  postcss: {
    plugins: [presetENV, autoprefixer]
  }
} satisfies CSS;

const ViteConfiguration = {
  server: ServerOptions,
  build: BuildOptions,
  css: CSSOptions
} satisfies UserConfig;


export default defineConfig(ViteConfiguration);