declare module "*.elm" {
  export const Elm: { Main: { init: (options: { node: Element }) => unknown } };
}
