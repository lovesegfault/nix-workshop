PREFIX ?= ./install

build: hello.c
	mkdir -p build
	cc -o build/hello-c hello.c

.PHONY: clean
clean:
	rm -rf build
	rm -rf $(DESTDIR)$(PREFIX)

.PHONY: install
install: build
	mkdir -p $(DESTDIR)$(PREFIX)/bin/
	install -m 755 build/hello-c $(DESTDIR)$(PREFIX)/bin/
