{ rustPlatform, lib }:

rustPlatform.buildRustPackage {
  name = "hello-rust";

  src = lib.cleanSource ./.;

  cargoLock.lockFile = ./Cargo.lock;
}
