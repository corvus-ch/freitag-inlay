# Prologue
MAKEFLAGS += --warn-undefined-variables

# Internal variables
build_cmd := latexmk -pdf -use-make
clean_cmd := latexmk -c

formats=a5 a6 f26
documents=$(basename $(wildcard *.tex))

# Rules and targets
.PHONY: all
all: $(foreach document,$(documents), $(foreach format,$(formats), $(document)-$(format)-booklet.pdf))

define DOCUMENT_RULE
.PHONY: $(document)
$(document): $(addsuffix .pdf, $(addprefix $(document)-, $(formats)))
endef

$(foreach document,$(documents), $(eval $(DOCUMENT_RULE) ) )

define FORMAT_RULE
.PHONY: $(format)
$(format): $(addsuffix -$(format).pdf, $(documents))
endef

$(foreach format,$(formats), $(eval $(FORMAT_RULE) ) )


define BUILD_RULE
tmp/%-$(format).pdf : %.tex inlay.sty Makefile
	$$(build_cmd) -outdir=tmp -jobname=$$*-$(format) -usepretex='\PassOptionsToPackage{$(format)}{inlay}' $$<
endef

$(foreach format,$(formats), $(eval $(BUILD_RULE) ) )

tmp/%-nup.pdf: tmp/%.pdf
	pdfjam --vanilla --noautoscale true --nup 2x1 --landscape '--signature' 4 --twoside --shortedge -o $@ -- $< 3-

%-booklet.pdf: tmp/%.pdf  tmp/%-nup.pdf
	pdfjam --vanilla --rotateoversize true --paper a4paper -o $@ -- $< 1 tmp/$*-nup.pdf

.PHONY: clean
clean:
	$(clean_cmd) *.tex
	rm -f *.pdf
	rm -f *.run.xml
	rm -rf tmp
