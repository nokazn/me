{ pkgs, workspace, ... }:

let
  deps = with pkgs; [
    nodejs
    elm2nix
    nodePackages.pnpm
    elmPackages.elm
    wrangler
  ];
  devDeps = with pkgs; [
    elmPackages.elm-format
    elmPackages.elm-test
    elmPackages.elm-test-rs
    elmPackages.elm-review
    elmPackages.elm-json
  ];
  bin = with pkgs; with nodePackages; [
    (writeScriptBin "check" ''
      ${pnpm}/bin/pnpm run -r check
      ${pnpm}/bin/pnpm run -r test
    '')
    (writeScriptBin "build" ''
      ${pnpm}/bin/pnpm run -r build
    '')
    (writeScriptBin "deploy" ''
      ${pnpm}/bin/pnpm run -r deploy
    '')
  ];
  shellHook = ''
    pnpm install
  '';
in
rec {
  name = workspace.name + "/web";

  devShells = {
    default = {
      inherit shellHook;
      buildInputs = deps ++ devDeps ++ bin;
    };
    build = {
      inherit shellHook;
      buildInputs = deps;
    };
  };

  packages = {
    default = pkgs.stdenv.mkDerivation {
      inherit name;
      inherit (devShells.build) buildInputs;

      src = pkgs.lib.cleanSource ../..;

      configurePhase = pkgs.elmPackages.fetchElmDeps {
        elmPackages = import ./elm-srcs.nix;
        elmVersion = "0.19.1";
        registryDat = ./registry.dat;
      };

      # TODO: fix `pnpm run build` errors
      buildPhase = ''
        export HOME=$(pwd)
        export NIX_GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
        export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
        pnpm install --frozen-lockfile
        pnpm run -r build
      '';
      # TODO: fix `cp` errors
      installPhase = ''
        runHook preInstall
        cp package.json $out/package.json
        cp -r dist $out/dist
        runHook postInstall
      '';
    };
  };
}
