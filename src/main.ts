import { Elm } from "./Main.elm";

if (process.env.NODE_ENV === "development") {
  const ElmDebugTransform = await import("elm-debug-transformer");
  ElmDebugTransform.register({
    simple_mode: true,
  });
}

const node = document.querySelector("#app");
if (node == null) {
  throw new Error("No #app element");
}
Elm.Main.init({ node });
