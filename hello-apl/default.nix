{ stdenv, gnuapl }:

stdenv.mkDerivation {
  pname = "hello-apl";
  version = "0.1.0";

  nativeBuildInputs = [ gnuapl ];

  unpackPhase = ":";
  installPhase = "install -m755 -D ${./hello.apl} $out/bin/hello-apl";
  dontPatchShebangs = 1;
  checkPhase = ''
    substituteInPlace bin/hello-apl \
      --replace '/usr/bin/env apl' ${gnuapl}/bin/apl
    bin/hello-apl
  '';
}
