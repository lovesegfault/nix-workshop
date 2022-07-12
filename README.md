# nix-workshop

This aims to show how you can package a simple `Hello world!` program in every
programming language with Nix.

Please contribute your language of choice!

## Usage

### Building

In order to build a specific `hello` program, you can use `nix build
.#hello-whatever`, for example:

```console
$ nix build -L .#hello-cobol
hello-cobol> unpacking sources
hello-cobol> unpacking source archive /nix/store/z5vgi7ykf5rrz5j5cv3k2x7q3zsm2svq-source
hello-cobol> source root is source
hello-cobol> patching sources
hello-cobol> updateAutotoolsGnuConfigScriptsPhase
hello-cobol> configuring
hello-cobol> no configure script, doing nothing
hello-cobol> building
hello-cobol> build flags: SHELL=/nix/store/gzcbs0pkzsv1q3rngvf4i53z3vv7vxl4-bash-5.1-p16/bin/bash PREFIX=/nix/store/9miyav5d5ky5y4603rsxss3yvsd7s2bp-hello-cobol-0.1.0
hello-cobol> mkdir -p build
hello-cobol> cobc -x -o build/hello-cobol hello.cbl
hello-cobol> installing
hello-cobol> install flags: SHELL=/nix/store/gzcbs0pkzsv1q3rngvf4i53z3vv7vxl4-bash-5.1-p16/bin/bash PREFIX=/nix/store/9miyav5d5ky5y4603rsxss3yvsd7s2bp-hello-cobol-0.1.0 install
hello-cobol> mkdir -p /nix/store/9miyav5d5ky5y4603rsxss3yvsd7s2bp-hello-cobol-0.1.0/bin/
hello-cobol> install -m 755 build/hello-cobol /nix/store/9miyav5d5ky5y4603rsxss3yvsd7s2bp-hello-cobol-0.1.0/bin/
hello-cobol> post-installation fixup
hello-cobol> strip is /nix/store/2jsaz8bif2shdfgbmxf1wydz4azdzzd0-clang-wrapper-11.1.0/bin/strip
hello-cobol> stripping (with command strip and flags -S) in /nix/store/9miyav5d5ky5y4603rsxss3yvsd7s2bp-hello-cobol-0.1.0/bin
hello-cobol> patching script interpreter paths in /nix/store/9miyav5d5ky5y4603rsxss3yvsd7s2bp-hello-cobol-0.1.0
```
*hint: the `-L` makes build logs show up*

### Running

Once you've built a package, a `result` symlink will show up in your CWD,
pointing to the package's location in the nix store. You can use it to run your
program:

```console
$ ./result/bin/hello-cobol
Hello, Cobol world!
```

You can build and run a program in one go by using `nix run`:

```console
$ nix run .#hello-rust
Hello, Rust world!
```

### Docker

We have a special package, `hello-docker`, which demonstrates how we can
generate a docker image with all our `hello-program`s. Running `hello-docker` is
a little more involved, here's how you do it:

```console
$ nix build -L .#hello-docker
docker-image-hello-docker.tar.gz> Adding layer...
docker-image-hello-docker.tar.gz> tar: Removing leading `/' from member names
docker-image-hello-docker.tar.gz> Adding meta...
docker-image-hello-docker.tar.gz> Cooking the image...
docker-image-hello-docker.tar.gz> Finished.

$ docker load -i result
Loaded image: hello-docker:dn6j5y4fz1w7c92clbc2lv6d9zidwncx

$ docker run hello-docker:dn6j5y4fz1w7c92clbc2lv6d9zidwncx
Hello, C world!
Hello, Cobol world!
Hello, Go World!
Hello, Poetry world!
Hello, Rust world!
Hello, Setuptools world!
```

### All

If you wish to run all `hello-program`s without using Docker, you can use the
`hello-all` aggregate. It's just a shell script that call each `hello-program`
for you:

```console
$ nix run .#hello-all
Hello, C world!
Hello, Cobol world!
Hello, Go World!
Hello, Poetry world!
Hello, Rust world!
Hello, Setuptools world!
```

## Contributing

1. `mkdir hello-$lang && cd hello-$lang`
2. Implement a program that prints `Hello, $lang world!`
3. Package it with a `default.nix`
4. Add it to `packages` in `flake.nix`
5. Update the README list

If you need any help, you can open an issue here, or reach out to @lovesegfault.

## Languages

* C
* Cobol
* Go
* Python (poetry)
* Python (setuptools)
* Rust
