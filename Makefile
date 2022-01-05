# Prologue
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

# Internal variables
build_cmd := latexmk -pdf -pdflatex="xelatex -interaction=nonstopmode" -use-make
clean_cmd := latexmk -c

# Rules and targets
.PHONY: all
all: dotted-template.pdf gridded-template.pdf

.SUFFIXES: -template.pdf
%-template.pdf: %-2x1.pdf license.pdf
	pdfjam --vanilla --noautoscale true --outfile $*-template.pdf $^

.SUFFIXES: -2x1.pdf
%-2x1.pdf: %.pdf
	pdfjam --vanilla --noautoscale true --angle 90 --nup 2x1 --suffix '2x1' --booklet true $<

.SUFFIXES: .pdf
%.pdf: %.tex freitag-inlay.sty
	$(build_cmd) $<

.PHONY: clean
clean:
	$(clean_cmd) *.tex
	rm -f *.pdf
	rm -f *.run.xml
