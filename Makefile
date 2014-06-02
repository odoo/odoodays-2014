ifndef dir
  $(error the 'dir' parameter must be provided e.g. make dir=project $(MAKEFILE_LIST))
endif

ifeq ($(wildcard $(dir)/index.rst),)
  $(error 'dir' must be an existing directory with an index.rst)
endif

ifdef conf
    ifeq ($(wildcard $(conf)/conf.py),)
      $(error 'conf' dir must be an existing directory with a conf.py file)
    endif
else
    conf = master
endif

export ABSDIR = $(abspath $(dir))
SPHINXBUILD = sphinx-build2
BUILDDIR = $(dir)/_build

PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = \
	-c $(conf) \
	-q \
    -d $(BUILDDIR)/doctrees \
    $(PAPEROPT_$(PAPER)) \
    $(SPHINXOPTS) \
	$(dir)

.phony: html slides latexpdf clean

help:
	@echo "Use 'make <target>' where <target> is one of html, slides or latexpdf"

clean:
	rm -rf $(BUILDDIR)/*

html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html

slides:
	$(SPHINXBUILD) -b slides $(ALLSPHINXOPTS) $(BUILDDIR)/slides

latexpdf:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
