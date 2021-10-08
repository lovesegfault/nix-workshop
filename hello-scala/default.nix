{ sbt, lib, jre_headless, makeWrapper }:

sbt.mkDerivation rec {
  pname = "hello-scala";
  version = "0.1.0";

  depsSha256 = "sha256-zvSm8PxYvVfVrts3JwSFc+4qnI3+D9lR1e/a9Op5ViY=";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    sbt assembly
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/java}

    install -m 644 \
      target/scala-*/${pname}-assembly-${version}.jar \
      $out/share/java/${pname}.jar

    makeWrapper ${jre_headless}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${pname}.jar" \
      --unset _JAVA_OPTIONS
  '';
}
