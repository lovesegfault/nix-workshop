{ stdenv, gnuapl, lib }:

stdenv.mkDerivation {
  pname = "hello-apl";
  version = "0.1.0";

  buildInputs = [ gnuapl ];

  src = lib.cleanSource ./.;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  dontPatchShebangs = true;

  postPatch = ''
    substituteInPlace ./hello.apl \
      --replace '/usr/bin/env -S apl' ${gnuapl}/bin/apl
  '';

  checkPhase = ''
    $out/bin/hello-apl
  '';
}
