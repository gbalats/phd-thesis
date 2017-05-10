LATEX        := pdflatex
LATEX        += -shell-escape -interaction=nonstopmode -file-line-error
BIBTEX       := bibtex -min-crossrefs=9000
PS2PDF       := ps2pdf -dEPSCrop
DOT          := dot
RM           := rm -f
MV           := mv
LPR          := lpr
PRINTER      := lp
PDFCROP      ?= pdfcrop
INKSCAPE     ?= inkscape

class.cls    := llncs.cls
biblio.bib   := $(wildcard ../bib/*.bib)
biblio.bib   += $(wildcard ../bib/pointer-analysis/*.bib)
styles.sty   := $(wildcard ../styles/*.sty)
sources.tex  := $(wildcard *.tex)
algo.tex     := $(shell find ../algorithms/ -type f -name '*.tex')

figures.eps  := $(wildcard ../figures/*.eps)
figures.eps  += $(wildcard ../figures/complementation/*.eps)
figures.eps  += $(wildcard ../figures/structsens/*.eps)
figures.eps  += $(wildcard ../figures/reflection/*.eps)
figures.svg  := $(wildcard ../figures/*.svg)
figures.svg  += $(wildcard ../figures/complementation/*.svg)
figures.svg  += $(wildcard ../figures/structsens/*.svg)
figures.svg  += $(wildcard ../figures/reflection/*.svg)
figures.dot  := $(wildcard ../figures/*.dot)
figures.dot  += $(wildcard ../figures/complementation/*.dot)
figures.dot  += $(wildcard ../figures/structsens/*.dot)
figures.dot  += $(wildcard ../figures/reflection/*.dot)
figures.odg  := $(wildcard ../figures/*.odg)
figures.odg  += $(wildcard ../figures/complementation/*.odg)
figures.odg  += $(wildcard ../figures/structsens/*.odg)
figures.odg  += $(wildcard ../figures/reflection/*.odg)
figures.pdf  := $(figures.eps:%.eps=%.pdf)
figures.pdf  += $(figures.svg:%.svg=%.pdf)
figures.pdf  += $(figures.dot:%.dot=%.pdf)
figures.pdf  += $(figures.odg:%.odg=%.pdf)

abstract.pdf := extended-abstract.pdf

dependencies := $(sources.tex) $(figures.pdf)
dependencies += $(biblio.bib)
dependencies += $(class.cls) $(styles.sty)
dependencies += $(algo.tex)

#--------------------------
# Default target
#--------------------------

.PHONY: all
all: $(abstract.pdf)

.PHONY: force
force:

$(abstract.pdf): %.pdf: %.tex force
	$(LATEX) $<
	$(BIBTEX) $*.aux
	$(LATEX) $<
	$(LATEX) $<

extended-abstract-full.tex: extended-abstract.tex force
	perl ../latexpand --expand-bbl extended-abstract.bbl $< > $@

.PHONY: print
print:
	$(LPR) -P$(PRINTER) $(abstract.pdf)
	$(LPR) -P$(PRINTER)

#--------------------------
# Process Figures
#--------------------------

$(figures.svg:%.svg=%.pdf): %.pdf: %.svg
	$(INKSCAPE) $< --export-pdf=$@
	$(PDFCROP) $@
	$(RM) $@
	$(MV) $*-crop.pdf $@

$(figures.eps:%.eps=%.pdf): %.pdf: %.eps
	$(PS2PDF) $< $@

$(figures.dot:%.dot=%.pdf): %.pdf: %.dot
	$(DOT) $< -Tpdf -o $@

$(figures.odg:%.odg=%.pdf): %.pdf: %.odg
	unoconv -f pdf $<
	$(PDFCROP) $@
	$(RM) $@
	$(MV) $*-crop.pdf $@

.PHONY: figures
figures: $(figures.pdf)


#--------------------------
# Cleanup target
#--------------------------

.PHONY: clean
clean:
	$(RM) $(subst .pdf,.log,$(abstract.pdf))
	$(RM) $(subst .pdf,.lof,$(abstract.pdf))
	$(RM) $(subst .pdf,.lot,$(abstract.pdf))
	$(RM) $(subst .pdf,.toc,$(abstract.pdf))
	$(RM) $(subst .pdf,.aux,$(abstract.pdf))
	$(RM) $(subst .pdf,.bbl,$(abstract.pdf))
	$(RM) $(subst .pdf,.blg,$(abstract.pdf))
	$(RM) $(subst .pdf,.out,$(abstract.pdf))
	$(RM) -r $(abstract.pdf:%.pdf=_minted-%/)
	$(RM) $(abstract.pdf)


#--------------------------
# Additional dependencies
#--------------------------

$(abstract.pdf): $(dependencies)
