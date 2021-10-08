{ buildGoModule, lib }:

buildGoModule {
  name = "hello-go";
  version = "0.1.0";

  src = lib.cleanSource ./.;

  vendorSha256 = null;
}
