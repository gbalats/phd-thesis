PDFLATEX     := pdflatex -shell-escape -interaction=nonstopmode -file-line-error
BIBTEX       := bibtex -min-crossrefs=9000
PS2PDF       := ps2pdf -dEPSCrop
RM           := rm -f
MV           := mv
LPR          := lpr
PRINTER      := lp
PDFCROP      ?= pdfcrop
INKSCAPE     ?= inkscape

class.cls    := diphdthesis.cls
biblio.bib   := $(wildcard bib/*.bib)
biblio.bib   += $(wildcard bib/pointer-analysis/*.bib)
styles.sty   := $(wildcard styles/*.sty)
sources.tex  := $(wildcard *.tex)
sources.tex  += $(wildcard chapters/*.tex)
figures.eps  := $(wildcard figures/*.eps)
figures.svg  := $(wildcard figures/*.svg)
figures.pdf  := $(figures.eps:%.eps=%.pdf)
figures.pdf  += $(figures.svg:%.svg=%.pdf)
thesis.pdf   := thesis.pdf

dependencies := $(sources.tex) $(figures.pdf)
dependencies += $(biblio.bib)
dependencies += $(class.cls) $(styles.sty)

#--------------------------
# Default target
#--------------------------

.PHONY: all
all: $(thesis.pdf)

.PHONY: force
force:

$(thesis.pdf): %.pdf: %.tex force
	$(PDFLATEX) $<
	$(BIBTEX) $*.aux
	$(PDFLATEX) $<
	$(PDFLATEX) $<

.PHONY: print
print:
	$(LPR) -P$(PRINTER) $(thesis.pdf)
	$(LPR) -P$(PRINTER)

#--------------------------
# Process Figures
#--------------------------

$(figures.svg:%.svg=%.pdf): %.pdf: %.svg
	$(INKSCAPE) $< --export-pdf=$@
	$(PDFCROP) $@
	$(MV) $*-crop.pdf $@

$(figures.eps:%.eps=%.pdf): %.pdf: %.eps
	$(PS2PDF) $< $@

.PHONY: figures
figures: $(figures.pdf)


#--------------------------
# Cleanup target
#--------------------------

.PHONY: clean
clean:
	$(RM) $(subst .pdf,.log,$(thesis.pdf))
	$(RM) $(subst .pdf,.lof,$(thesis.pdf))
	$(RM) $(subst .pdf,.lot,$(thesis.pdf))
	$(RM) $(subst .pdf,.toc,$(thesis.pdf))
	$(RM) $(subst .pdf,.aux,$(thesis.pdf))
	$(RM) $(subst .pdf,.bbl,$(thesis.pdf))
	$(RM) $(subst .pdf,.blg,$(thesis.pdf))
	$(RM) $(subst .pdf,.out,$(thesis.pdf))
	$(RM) $(thesis.pdf)


#--------------------------
# Additional dependencies
#--------------------------

$(thesis.pdf): $(dependencies)


#--------------------------
# Git submodules
#--------------------------

.PHONY: setup
setup:
	git submodule update --init

update-submodules:
	git submodule update --remote --merge
