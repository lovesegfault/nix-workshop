SRCFILE=hello.apl
BINFILE=hello-apl
PREFIX ?= ./install

.PHONY: clean
clean:
	rm -rf $(DESTDIR)$(PREFIX)

.PHONY: install
install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin/
	install -m 755 $(SRCFILE) $(DESTDIR)$(PREFIX)/bin/$(BINFILE)
