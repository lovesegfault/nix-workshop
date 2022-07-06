{ stdenv, gnuapl }:

stdenv.mkDerivation {
  pname = "hello-apl";
  version = "0.1.0";

  buildInputs = [ gnuapl ];

  dontPatchShebangs = 1;

  # Optimization for single-script files.
  unpackPhase = ":";
  installPhase = "install -m755 -D ${./hello.apl} $out/bin/hello-apl";
  checkPhase = ''
    runHook preCheck
    substituteInPlace bin/hello-apl \
      --replace '/usr/bin/env apl' ${gnuapl}/bin/apl
    bin/hello-apl
    runHook postCheck
  '';
}
