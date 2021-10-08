{ stdenv, lib }:
stdenv.mkDerivation {
  pname = "hello-c";
  version = "0.1.0";

  src = lib.cleanSource ./.;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
}
