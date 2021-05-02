PACKAGE-NAME		:= $(shell basename $(abspath .))
PACKAGE-EXE			:= $(PACKAGE-NAME).exe
PACKAGE-DIST		:= $(PACKAGE-NAME)_distribution
PACKAGE-DIST-TAR	:= $(PACKAGE-DIST).tar.gz
PACKAGE-ZIP			:= $(PACKAGE-NAME).zip

RACKET				:= racket
RACO				:= raco

ENTRYPOINT			:= $(PACKAGE-NAME)/main.rkt
COMPILE-FLAGS		:= -v
RUN-FLAGS			:=
EXE-FLAGS			:= -v -o $(PACKAGE-EXE)
DO-DOCS				:= --no-docs
INSTALL-FLAGS		:= --auto $(DO-DOCS)
DEPS-FLAGS			:= --check-pkg-deps --unused-pkg-deps


all:	install setup test

compile:
	$(RACO) make $(COMPILE-FLAGS) $(ENTRYPOINT)

run:
	$(RACKET) $(RUN-FLAGS) $(ENTRYPOINT)

exe:	compile
	$(RACO) exe $(EXE-FLAGS) $(ENTRYPOINT)

install:
	$(RACO) pkg install $(INSTALL-FLAGS) --name $(PACKAGE-NAME)

dist:	exe
	mkdir -p $(PACKAGE-DIST)
	$(RACO) distribute $(PACKAGE-DIST) $(PACKAGE-EXE)
	tar cfz $(PACKAGE-DIST-TAR) $(PACKAGE-DIST)

pkg:
	$(RACO) pkg create --source $(PWD)

distclean:
	if [ -d $(PACKAGE-DIST) ] ; then rm -r $(PACKAGE-DIST) ; fi
	if [ -f $(PACKAGE-DIST-TAR) ] ; then rm $(PACKAGE-DIST-TAR) ; fi
	if [ -f $(PACKAGE-ZIP) ] ; then rm $(PACKAGE-ZIP)* ; fi

clean:	distclean
	find . -depth -type d -name 'compiled' -exec rm -r {} \;
	if [ -f $(PACKAGE-EXE) ] ; then rm $(PACKAGE-EXE) ; fi

remove:
	$(RACO) pkg remove $(DO-DOCS) $(PACKAGE-NAME)

purge:	remove clean

reinstall:	remove install

# This builds docs
setup:
	$(RACO) setup --tidy --avoid-main $(DEPS-FLAGS) --pkgs $(PACKAGE-NAME)

check-deps:
	$(RACO) setup $(DO-DOCS) $(DEPS-FLAGS) $(PACKAGE-NAME)

test:
	$(RACO) test --package $(PACKAGE-NAME)
