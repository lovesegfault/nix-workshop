{ buildPythonApplication, lib }:
buildPythonApplication {
  pname = "hello_setuptools";
  version = "0.1.0";

  src = lib.cleanSource ./.;
}
