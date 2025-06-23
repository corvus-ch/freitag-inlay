# Prologue
MAKEFLAGS += --warn-undefined-variables

# Internal variables
build_cmd := latexmk -pdf -use-make
clean_cmd := latexmk -c

# Rules and targets
.PHONY: all
all: bandplan-a5.pdf bandplan-a6.pdf bandplan-f26.pdf dotted-a5.pdf dotted-a6.pdf dotted-f26.pdf gridded-a5.pdf gridded-a6.pdf gridded-f26.pdf sota-log-a5.pdf sota-log-a6.pdf sota-log-f26.pdf

.PHONY: f26
f26: bandplan-f26.pdf dotted-f26.pdf gridded-f26.pdf sota-log-f26.pdf

.PHONY: a5
a5: bandplan-a5.pdf dotted-a5.pdf gridded-a5.pdf sota-log-a5.pdf

.PHONY: a6
a6: bandplan-a6.pdf dotted-a6.pdf gridded-a6.pdf sota-log-a6.pdf

tmp/%-f26.pdf: %.tex inlay.sty Makefile
	$(build_cmd) -outdir=tmp -usepretex='\PassOptionsToPackage{f26}{inlay}' -jobname=$*-f26 $<

tmp/%-a5.pdf: %.tex inlay.sty Makefile
	$(build_cmd) -outdir=tmp -usepretex='\PassOptionsToPackage{a5}{inlay}' -jobname=$*-a5 $<

tmp/%-a6.pdf: %.tex inlay.sty Makefile
	$(build_cmd) -outdir=tmp -usepretex='\PassOptionsToPackage{a6}{inlay}' -jobname=$*-a6 $<

tmp/%-nup.pdf: tmp/%.pdf
	pdfjam --vanilla --noautoscale true --nup 2x1 --landscape '--signature' 4 --twoside --shortedge -o $@ -- $< 3-

%.pdf: tmp/%.pdf  tmp/%-nup.pdf
	pdfjam --vanilla --rotateoversize true --paper a4paper -o $@ -- $< 1 tmp/$*-nup.pdf

.PHONY: clean
clean:
	$(clean_cmd) *.tex
	rm -f *.pdf
	rm -f *.run.xml
	rm -rf tmp
