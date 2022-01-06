# Prologue
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

# Internal variables
build_cmd := latexmk -pdf -pdflatex="xelatex -shell-escape -interaction=nonstopmode" -use-make
clean_cmd := latexmk -c

# Rules and targets
.PHONY: all
all: dotted.pdf gridded.pdf

.SUFFIXES: -inlay.pdf
%-inlay.pdf: %-inlay.tex
	$(build_cmd) $<

.SUFFIXES: .pdf
%.pdf: %.tex %-inlay.pdf inlay.sty
	$(build_cmd) $<

.PHONY: clean
clean:
	$(clean_cmd) *.tex
	rm -f *.pdf
	rm -f *.run.xml
