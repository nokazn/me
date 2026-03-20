{ pkgs, workspace, naersk, ... }:

let
  buildInputs = with pkgs; [
    cargo
    rustc
    rustfmt
    rustPackages.clippy
    cargo-watch
    openssl.dev
  ];
  naerskLib = pkgs.callPackage naersk { };
in
{
  name = workspace.name + "/worker";

  devShells = {
    default = {
      inherit buildInputs;
      shellHook = "";
    };
  };

  packages = {
    default = naerskLib.buildPackage {
      inherit buildInputs;
      src = ../..;
    };
  };
}
