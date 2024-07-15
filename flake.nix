{
  description = "nokazn/me";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    naersk.url = "github:nix-community/naersk/master";
  };

  outputs =
    { nixpkgs
    , flake-utils
    , naersk
    , ...
    }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      workspace = {
        name = "nokazn.me";
        buildInputs = with pkgs ; [
          dprint
          nixpkgs-fmt
        ];
      };
      webLib = import ./packages/web {
        inherit pkgs workspace;
      };
      workerLib = import ./packages/worker {
        inherit pkgs workspace naersk;
      };
    in
    rec {
      name = workspace.name;

      devShells =
        let
          makeDevShells =
            pkgs.lib.foldl
              (current: package: {
                buildInputs = current.buildInputs ++ package.devShells.default.buildInputs;
                shellHook = current.shellHook + package.devShells.default.shellHook;
              })
              {
                buildInputs = workspace.buildInputs;
                shellHook = "";
              };
        in
        {
          default = pkgs.mkShell ({ inherit name; } // makeDevShells [ webLib workerLib ]);
        };

      packages = rec{
        default = worker;
        web = webLib.packages.default;
        worker = workerLib.packages.default;
      };
    });
}
