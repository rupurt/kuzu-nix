{
  description = "Nix flake for Kuzu";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlay
        ];
      };
    in {
      # packages exported by the flake
      packages = rec {
        kuzu = pkgs.stdenv.mkDerivation {
          name = "kuzu";
          version = "v0.8.0";

          src = pkgs.fetchFromGitHub {
            owner = "kuzudb";
            repo = "kuzu";
            rev = "v0.8.0";
            sha256 = "sha256-iskxQzXb7uds4xpboh7hlUVWjkYXi6ACVJaMEXjQQbI=";
          };

          nativeBuildInputs = with pkgs; [
            cmake
            python312
          ];
        };
        default = kuzu;
      };

      # nix fmt
      formatter = pkgs.alejandra;

      # nix develop -c $SHELL
      devShells.default =
        pkgs.mkShell {
        };
    });
  in
    outputs
    // {
      # Overlay that can be imported so you can access the packages
      # using kuzu.overlay
      overlay = final: prev: {
        kuzu-pkgs = outputs.packages.${prev.system};
      };
    };
}
