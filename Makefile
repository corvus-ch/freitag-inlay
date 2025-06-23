# Prologue
MAKEFLAGS += --warn-undefined-variables

# Internal variables
build_cmd := latexmk -pdf -use-make --aux-directory=build

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
%-$(format).pdf : %.tex inlay.sty Makefile
	$$(build_cmd) -jobname=$$*-$(format) -usepretex='\PassOptionsToPackage{$(format)}{inlay}' $$<
endef

$(foreach format,$(formats), $(eval $(BUILD_RULE) ) )

build/%-nup.pdf: %.pdf
	pdfjam --vanilla --noautoscale true --nup 2x1 --landscape '--signature' 4 --twoside --shortedge -o $@ -- $< 3-

%-booklet.pdf: %.pdf  build/%-nup.pdf
	pdfjam --vanilla --rotateoversize true --paper a4paper -o $@ -- $< 1 build/$*-nup.pdf

.PHONY: clean
clean:
	rm -f *.pdf
	rm -rf build
