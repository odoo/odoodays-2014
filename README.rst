Odoo Days 2014, R&D presentations
=================================

In case you do not wanting to use Powerpoint (and its templates)

* install sphinx >= 1.2 (you can check with ``sphinx-build --version``, you
  may need to use ``easy_install`` or ``pip``
  (e.g. ``pip install 'sphinx>=1.2'``) if your distribution only provides an
  old version of Sphinx.
* install hieroglyph >= 0.6.5 (http://hieroglyph.io not ``ttf-ancient-fonts``,
  you will probably have to use ``easy_install`` or ``pip``)
* look at `demo/` for instructions on how things work (``make dir=demo slides 
  html`` from the root directory to build, then look at
  ``demo/_build/slides/index.html`` and ``demo/_build/html/index.html``)

To start your own presentation
------------------------------

* create a directory named after your presentation, underscore_separated and
  lowercase
* add an index.rst file to it (this readme is not a presentation so it's not
  going to work right)
* ``make dir=$directory slides``
* the result is in ``$directory/_build/slides``
* Push your presentation stuff (and others) to this repository so it's 
  available to e.g. print out
* If you *need* specific graphical features missing from default Sphinx or
  the custom stylesheet and it's not already answered below, open an issue
  in the repository

Q&A
---

Can I remove the bit of previous and next slide?
    Nope, that's the slides style. Maybe next year (literally, hieroglyph
    is integrating the more recent Google IO slide templates, but that's
    not ready yet so we get the old one)
Is there a timer in the presenter's mode?
    No, sorry. There will be somebody timing so that shouldn't be too
    much of an issue
When I google image for "purple pony" I get G3 stuff!
    Google for "twilight sparkle"
Any other purple pony?
    Google for "MLP spike"
That's not a pony
    Hush
Can I use something else?
    No idea, take it to fp
