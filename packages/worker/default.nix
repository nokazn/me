{ pkgs, workspace, ... }:

let
  buildInputs = with pkgs; [
    cargo
    rustc
    rustfmt
    rustPackages.clippy
    cargo-watch
    llvmPackages.lld
  ];
in
{
  name = workspace.name + "/worker";

  devShells = {
    default = {
      inherit buildInputs;
      shellHook = ''
        rustup target add wasm32-unknown-unknown 2>/dev/null || true
      '';
    };
  };

  packages = {
    default = null;
  };
}
