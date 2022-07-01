{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, flake-utils, nixpkgs, poetry2nix }:
  let
    supportedSystems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
  in
  flake-utils.lib.eachSystem supportedSystems (system:
    let
      system = "aarch64-darwin";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          poetry2nix.overlay
        ];
      };
      inherit (pkgs) lib;

      helloPkgs = lib.filterAttrs (n: v: lib.hasPrefix "hello-" n) self.packages.${system};
    in
    {
      packages = {
        default = pkgs.symlinkJoin {
          name = "nix-workshop";
          paths = lib.attrValues helloPkgs;
        };
        hello-c = pkgs.callPackage ./hello-c { };
        hello-poetry = pkgs.callPackage ./hello-poetry { };
        hello-rust = pkgs.callPackage ./hello-rust { };
        hello-go = pkgs.callPackage ./hello-go { };
        hello-setuptools = pkgs.python3Packages.callPackage ./hello-setuptools { };
        dockerImages = lib.mapAttrs
          (n: v: pkgs.dockerTools.buildImage {
            name = "${n}-docker";
            config.Cmd = [ "${v}/bin/${n}" ];
          })
          helloPkgs;
      };

      devShells.default = pkgs.mkShell {
        name = "nix-workshop";

        inputsFrom = lib.attrValues helloPkgs;

        nativeBuildInputs = with pkgs; [
          # C
          clang-tools
          cppcheck
          # Nix
          nix-linter
          nix-tree
          nixpkgs-fmt
          rnix-lsp
          # Python
          pyright
          # Rust
          cargo-edit
          cargo-fuzz
          rust-analyzer
          # Shell
          shellcheck
          shfmt
          # Generic
          graphviz
        ];

        buildInputs = with pkgs; [ ];
      };
    });
  }