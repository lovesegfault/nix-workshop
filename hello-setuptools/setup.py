from distutils.core import setup

setup(name = "hello_setuptools",
      version = "0.1.0",
      description = "Setuptools + Nix demo",
      author = "Bernardo Meurer <beme@google.com>",
      packages = ["hello_setuptools"],
      entry_points = {
        "console_scripts": [ "hello_setuptools=hello_setuptools:main" ]
      },
)
