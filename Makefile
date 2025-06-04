# Prologue
MAKEFLAGS += --warn-undefined-variables

# Internal variables
build_cmd := latexmk -pdf -pdflatex="xelatex -shell-escape -interaction=nonstopmode" -use-make
clean_cmd := latexmk -c

# Rules and targets
.PHONY: all
all: dotted.pdf gridded.pdf sota-log.pdf

.SUFFIXES: .pdf
%.pdf: %.tex freitag.sty
	$(build_cmd) $<

.PHONY: clean
clean:
	$(clean_cmd) *.tex
	rm -f *.pdf
	rm -f *.run.xml
