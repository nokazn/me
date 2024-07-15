{ pkgs, workspace, naersk, ... }:

let
  buildInputs = with pkgs; [
    cargo
    rustc
    rustfmt
    rustPackages.clippy
    cargo-watch
    openssl.dev
    libiconv
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
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
