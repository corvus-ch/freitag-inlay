# Prologue
MAKEFLAGS += --warn-undefined-variables

# Internal variables
build_cmd := latexmk -pdf -use-make --aux-directory=build
pdfjam_cmd := pdfjam --vanilla

formats=a5 a6 f26
documents=$(basename $(wildcard *.tex))
languages=de en

# Rules and targets
.PHONY: all
all: $(foreach document,$(documents), $(foreach format,$(formats), $(foreach language,$(languages), $(document)-$(format)-$(language)-booklet.pdf)))

define DOCUMENT_RULE
.PHONY: $(document)
$(document): $(addsuffix .pdf, $(addprefix $(document)-, $(foreach format,$(formats), $(addprefix $(format)-, $(languages)))))
endef

$(foreach document,$(documents), $(eval $(DOCUMENT_RULE) ) )

define FORMAT_RULE
.PHONY: $(format)
$(format): $(foreach language,$(languages), $(addsuffix -$(format)-$(language).pdf, $(documents)))
endef

$(foreach format,$(formats), $(eval $(FORMAT_RULE) ) )

define LANGUAGE_RULE
.PHONY: $(language)
$(language): $(foreach format,$(formats), $(addsuffix -$(format)-$(language).pdf, $(documents)))
endef

$(foreach language,$(languages), $(eval $(LANGUAGE_RULE) ) )

define BUILD_RULE
%-$(format)-$(language).pdf : %.tex inlay.sty Makefile
	$$(build_cmd) -jobname=$$*-$(format)-$(language) -usepretex='\PassOptionsToPackage{$(format), $(language)}{inlay}' $$<
endef

$(foreach format,$(formats), $(foreach language,$(languages), $(eval $(BUILD_RULE))))

build/%-nup.pdf: %.pdf Makefile
	$(pdfjam_cmd) --noautoscale true --nup 2x1 --landscape '--signature' 4 --twoside --shortedge -o $@ -- $< 3-

%-booklet.pdf: %.pdf  build/%-nup.pdf Makefile
	$(pdfjam_cmd) --rotateoversize true --paper a4paper -o $@ -- $< 1 build/$*-nup.pdf

.PHONY: clean
clean:
	rm -f *.pdf
	rm -rf build
