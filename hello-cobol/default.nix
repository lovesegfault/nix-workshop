{ stdenv, gnu-cobol, lib }:

stdenv.mkDerivation {
  pname = "hello-cobol";
  version = "0.1.0";

  src = lib.cleanSource ./.;

  nativeBuildInputs = [ gnu-cobol.bin gnu-cobol.dev ];

  buildInputs = [ gnu-cobol.lib ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # disable stackprotector on aarch64-darwin for now
  hardeningDisable = lib.optionals (stdenv.isAarch64 && stdenv.isDarwin) [ "stackprotector" ];
}
