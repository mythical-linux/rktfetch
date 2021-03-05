PACKAGE-NAME		:= $(shell basename $(abspath .))
EXE-NAME			:= $(PACKAGE-NAME).exe

PACKAGE-ZIP			:= $(PACKAGE-NAME).zip
PACKAGE-COMPILED	:= $(PACKAGE-NAME)/compiled

RUN-FLAGS			:=
EXE-FLAGS			:= -v -o $(EXE-NAME)
DEPS-FLAGS			:= --check-pkg-deps --unused-pkg-deps


all:	install setup test

run:
	racket $(RUN-FLAGS) $(PACKAGE-NAME)/main.rkt

exe:
	raco exe $(EXE-FLAGS) $(PACKAGE-NAME)/main.rkt

install:
	raco pkg install --auto --no-docs --name $(PACKAGE-NAME)

dist:
	raco pkg create --source $(PWD)

distclean:
	if [ -f $(PACKAGE-ZIP) ] ; then rm *.zip* ; fi

clean:	distclean
	if [ -d $(PACKAGE-COMPILED) ] ; then rm -r $(PACKAGE-COMPILED) ; fi
	if [ -f $(EXE-NAME) ] ; then rm $(EXE-NAME) ; fi

remove:
	raco pkg remove --no-docs $(PACKAGE-NAME)

purge:	remove clean

setup:
	raco setup --tidy --avoid-main $(DEPS-FLAGS) --pkgs $(PACKAGE-NAME)

check-deps:
	raco setup --no-docs $(DEPS-FLAGS) $(PACKAGE-NAME)

test:
	raco test --package $(PACKAGE-NAME)
