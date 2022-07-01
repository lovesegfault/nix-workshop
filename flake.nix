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

        helloPkgs = {
          hello-c = pkgs.callPackage ./hello-c { };
          hello-go = pkgs.callPackage ./hello-go { };
          hello-poetry = pkgs.callPackage ./hello-poetry { };
          hello-rust = pkgs.callPackage ./hello-rust { };
          hello-setuptools = pkgs.python3Packages.callPackage ./hello-setuptools { };
        };
      in
      {
        packages = {
          default = pkgs.symlinkJoin {
            name = "nix-workshop";
            paths = [ self.packages.${system}.hello-all ] ++ (lib.attrValues helloPkgs);
          };
          hello-all = pkgs.writeShellApplication {
            name = "hello-all";
            runtimeInputs = lib.attrValues helloPkgs;
            text = lib.concatStringsSep "\n" (map lib.getExe (lib.attrValues helloPkgs));
          };
          docker-image = pkgs.dockerTools.buildImage {
            name = "hello-docker";
            contents = [ self.packages.${system}.default ];
            config.Cmd = [ "/bin/hello-all" ];
          };
        } // helloPkgs;

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
