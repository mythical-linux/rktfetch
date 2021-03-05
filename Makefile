PACKAGE-NAME		:= $(shell basename $(abspath .))

PACKAGE-ZIP			:= $(PACKAGE-NAME).zip
PACKAGE-COMPILED	:= $(PACKAGE-NAME)/compiled

DEPS-FLAGS			:= --check-pkg-deps --unused-pkg-deps


all:	install setup test

install:
	raco pkg install --auto --no-docs --name $(PACKAGE-NAME)

dist:
	raco pkg create --source $(PWD)

distclean:
	if [ -f $(PACKAGE-ZIP) ] ; then rm *.zip* ; fi

clean:	distclean
	if [ -d $(PACKAGE-COMPILED) ] ; then rm -r $(PACKAGE-COMPILED) ; fi

remove:
	raco pkg remove --no-docs $(PACKAGE-NAME)

purge:	remove clean

setup:
	raco setup --tidy --avoid-main $(DEPS-FLAGS) --pkgs $(PACKAGE-NAME)

check-deps:
	raco setup --no-docs $(DEPS-FLAGS) $(PACKAGE-NAME)

test:
	raco test --package $(PACKAGE-NAME)
