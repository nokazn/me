{
  description = "nokazn/me";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      webDeps = with pkgs; [
        nodejs
        elm2nix
        nodePackages.pnpm
        elmPackages.elm
        wrangler
      ];
      webDevDeps = with pkgs; [
        elmPackages.elm-format
        elmPackages.elm-test-rs
        elmPackages.elm-review
        elmPackages.elm-json
      ];
      shellHook = ''
        pnpm install
      '';
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
    in
    rec {
      name = "nokazn/me";

      devShells = {
        default = pkgs.mkShell {
          inherit name shellHook;
          buildInputs = webDeps ++ webDevDeps ++ bin;
        };
        build = pkgs.mkShell {
          inherit name shellHook;
          buildInputs = webDeps ++ bin;
        };
      };

      packages =
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.stdenv.mkDerivation {
            inherit name;
            buildInputs = webDeps;
            src = pkgs.lib.cleanSource ./.;

            configurePhase = pkgs.elmPackages.fetchElmDeps {
              elmPackages = import ./packages/web/elm-srcs.nix;
              elmVersion = "0.19.1";
              registryDat = ./packages/web/registry.dat;
            };

            # TODO: fix `pnpm run build` errors
            buildPhase = ''
              export HOME=$(pwd)
              export NIX_GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
              export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
              pnpm install
              pnpm run build
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
    });
}
