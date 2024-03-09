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
    in
    {
      devShells.default = pkgs.mkShell {
        name = "me";
        buildInputs = (with pkgs; [
          nodejs
          elm2nix
        ])
        ++ (with pkgs.elmPackages; [
          elm
          elm-format
          elm-test
        ]);
      };
    });
}
