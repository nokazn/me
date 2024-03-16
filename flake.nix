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
      web = import ./packages/web { inherit pkgs; };
    in
    {
      name = "nokazn.me";

      devShells = web.devShells;

      packages = rec {
        default = web;
        web = web.packages.web;
      };
    });
}
