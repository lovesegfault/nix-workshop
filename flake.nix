{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, flake-utils, nixpkgs, poetry2nix, pre-commit-hooks }:
    let
      supportedSystems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            poetry2nix.overlay
          ];
        };
        inherit (pkgs) lib;

        helloPkgs = lib.filterAttrs (n: _: lib.hasPrefix "hello-" n) self.packages.${system};
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
          docker-image = pkgs.dockerTools.buildImage {
            name = "hello-docker";
            contents = lib.attrValues helloPkgs;
            config.Cmd =
              let
                runner = lib.concatMapStringsSep " && " (n: "/bin/${n}") (lib.attrNames helloPkgs);
              in
              [ runner ];
          };
        };

        devShells.default = pkgs.mkShell {
          name = "nix-workshop";

          inputsFrom = (lib.attrValues helloPkgs)
            ++ (lib.attrValues self.checks.${system});

          nativeBuildInputs = with pkgs; [
            # GHA
            act
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

        checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = lib.cleanSource ./.;
          hooks = {
            nix-linter.enable = true;
            nixpkgs-fmt.enable = true;
            statix.enable = true;
            actionlint = {
              enable = true;
              files = "^.github/workflows/";
              types = [ "yaml" ];
              entry = lib.getExe pkgs.actionlint;
            };
          };
        };
      });
}
