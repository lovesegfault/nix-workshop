PREFIX ?= ./install

build: hello.cbl
	mkdir -p build
	cobc -x -o build/hello-cobol hello.cbl

.PHONY: clean
clean:
	rm -rf build
	rm -rf $(DESTDIR)$(PREFIX)

.PHONY: install
install: build
	mkdir -p $(DESTDIR)$(PREFIX)/bin/
	install -m 755 build/hello-cobol $(DESTDIR)$(PREFIX)/bin/

