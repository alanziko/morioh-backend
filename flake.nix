{
  description = "Morioh Backend";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
  };

  outputs = { self, nixpkgs, flake-utils, naersk }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      naerskLib = pkgs.callPackage naersk {};
      pythonEnv = pkgs.python3.withPackages(p: with p; [
        pytest
        requests
      ]);
    in {
      packages.default = naerskLib.buildPackage {
        src = ./.;
      };
    
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          cargo
          rustc
          pythonEnv
        ];
      };
    }
  );
}
