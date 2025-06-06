# Prologue
MAKEFLAGS += --warn-undefined-variables

# Internal variables
build_cmd := latexmk -pdf -use-make
clean_cmd := latexmk -c

# Rules and targets
.PHONY: all
all: bandplan-a5.pdf bandplan.pdf dotted-a5.pdf dotted.pdf gridded-a5.pdf gridded.pdf sota-log-a5.pdf sota-log.pdf

tmp/%.pdf: %.tex inlay.sty
	$(build_cmd) -outdir=tmp -jobname=$* $<

tmp/%-nup.pdf: tmp/%.pdf
	pdfjam --vanilla --noautoscale true --nup 2x1 --landscape '--signature' 4 --twoside --shortedge -o $@ -- $< 3-

tmp/%-a5.pdf: %.tex inlay.sty
	$(build_cmd) -outdir=tmp -usepretex='\PassOptionsToPackage{a5}{inlay}' -jobname=$*-a5 $<

%.pdf: tmp/%.pdf  tmp/%-nup.pdf
	pdfjam --vanilla --rotateoversize true --paper a4paper -o $@ -- $< 1 tmp/$*-nup.pdf

.PHONY: clean
clean:
	$(clean_cmd) *.tex
	rm -f *.pdf
	rm -f *.run.xml
	rm -rf tmp
