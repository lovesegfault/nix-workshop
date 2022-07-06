SRCFILE=hello.apl
OUTFILE=hello-apl

.PHONY: clean
clean:
	rm -rf $(OUTDIR)
	rm -rf $(DESTDIR)$(PREFIX)

.PHONY: install
install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin/
	install -m 755 $(SRCFILE) $(DESTDIR)$(PREFIX)/bin/$(OUTFILE)
