PACKAGE-NAME		:= $(shell basename $(abspath .))
EXE-NAME			:= $(PACKAGE-NAME).exe

PACKAGE-ZIP			:= $(PACKAGE-NAME).zip
PACKAGE-COMPILED	:= $(PACKAGE-NAME)/compiled

RACKET				:= racket
RACO				:= raco

RUN-FLAGS			:=
EXE-FLAGS			:= -v -o $(EXE-NAME)
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
	if [ -d $(PACKAGE-COMPILED) ] ; then rm -r $(PACKAGE-COMPILED) ; fi
	if [ -f $(EXE-NAME) ] ; then rm $(EXE-NAME) ; fi

remove:
	$(RACO) pkg remove $(DO-DOCS) $(PACKAGE-NAME)

purge:	remove clean

setup:
	$(RACO) setup --tidy --avoid-main $(DEPS-FLAGS) --pkgs $(PACKAGE-NAME)

check-deps:
	$(RACO) setup $(DO-DOCS) $(DEPS-FLAGS) $(PACKAGE-NAME)

test:
	$(RACO) test --package $(PACKAGE-NAME)
