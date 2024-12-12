{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flakeParts.url = "github:hercules-ci/flake-parts";
    haskellFlake.url = "github:srid/haskell-flake";
    flakeUtils.url = "github:numtide/flake-utils";
  };

  outputs = { flakeParts, haskellFlake, flakeUtils, ... }@inputs:
    flakeParts.lib.mkFlake { inherit inputs; } {
      systems = flakeUtils.lib.defaultSystems;
      imports = [
        haskellFlake.flakeModule
      ];
      perSystem = { self', system, lib, config, pkgs, ... }: {
        haskellProjects.default = {
          devShell = {
            hlsCheck.enable = false;
          };

          autoWire = [ "packages" "apps" "checks" "devShells"];
        };
      };
    };
}
