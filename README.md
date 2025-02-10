# kuzu-nix

Nix flake for the [Kuzu](https://kuzudb.com/) graph database

## Usage

This `kuzu-nix` flake assumes you have already [installed nix](https://determinate.systems/posts/determinate-nix-installer)

### Custom Flake with Overlay

```nix
# flake.nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.kuzu-nix.url = "github:rupurt/kuzu-nix";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    kuzu-nix,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          kuzu-nix.overlay
        ];
      };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.kuzu-pkgs.kuzu
          ];
        };
      };
    );
}
```

## License

`kuzu-nix` is released under the [MIT license](./LICENSE)
