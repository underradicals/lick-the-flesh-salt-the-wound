import { defineConfig, UserConfig, BuildEnvironmentOptions } from "vite";

type Server = UserConfig["server"]
type CSS = UserConfig["css"]

const ServerOptions = {

} satisfies Server;


const BuildOptions = {

} satisfies BuildEnvironmentOptions;


const CSSOptions = {

} satisfies CSS;

const ViteConfiguration = {

} satisfies UserConfig;


export default defineConfig(ViteConfiguration);