# This example uses a different pattern than many of the
# others in this repository, by relying on a "trivial builder"
#
# See the manual for more details:
#
# <https://nixos.org/manual/nixpkgs/stable/#trivial-builder-writeShellApplication>

{writeShellApplication}:

writeShellApplication {
    name = "hello-shell";

    runtimeInputs = [];

    text = ''
      echo Hello, shell world!
    '';
}
