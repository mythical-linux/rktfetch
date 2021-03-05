PACKAGE-NAME		:= $(shell basename $(abspath .))
PACKAGE-EXE			:= $(PACKAGE-NAME).exe
PACKAGE-ZIP			:= $(PACKAGE-NAME).zip

RACKET				:= racket
RACO				:= raco

RUN-FLAGS			:=
EXE-FLAGS			:= -v -o $(PACKAGE-EXE)
DO-DOCS				:= --no-docs
INSTALL-FLAGS		:= --auto $(DO-DOCS)
DEPS-FLAGS			:= --check-pkg-deps --unused-pkg-deps


all:	install setup test

run:
	$(RACKET) $(RUN-FLAGS) $(PACKAGE-NAME)/main.rkt

exe:
	$(RACO) exe $(EXE-FLAGS) $(PACKAGE-NAME)/main.rkt

install:
	$(RACO) pkg install $(INSTALL-FLAGS) --name $(PACKAGE-NAME)

dist:
	$(RACO) pkg create --source $(PWD)

distclean:
	if [ -f $(PACKAGE-ZIP) ] ; then rm *.zip* ; fi

clean:	distclean
	sh -c "find . -type d -name 'compiled' -exec rm -r {} \; ; exit 0"
	if [ -f $(PACKAGE-EXE) ] ; then rm $(PACKAGE-EXE) ; fi

remove:
	$(RACO) pkg remove $(DO-DOCS) $(PACKAGE-NAME)

purge:	remove clean

reinstall:	remove install

setup:
	$(RACO) setup --tidy --avoid-main $(DEPS-FLAGS) --pkgs $(PACKAGE-NAME)

check-deps:
	$(RACO) setup $(DO-DOCS) $(DEPS-FLAGS) $(PACKAGE-NAME)

test:
	$(RACO) test --package $(PACKAGE-NAME)
