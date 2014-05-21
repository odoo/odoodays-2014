Presentation title
==================

with a subtitle (presenter's name?)

Secondary titles
----------------

generate a new slide

Presenter's mode
----------------

Is opened by pressing :kbd:`c` (try it)

.. note::

   notes become presenter's notes

   They can be **fully** marked up

Slide table
-----------

can be opened by pressing :kbd:`t` to get an overview. Pressing :kbd:`t` again
will switch back to normal presentation mode.

A primary title in the middle
=============================

creates a section cut, with a subtitle

Sphinx markup
-------------

All the normal sphinx markup works:

* a list
* *emphasis*
* **strong**
* ``code``
* :abbr:`ABBR (eviations)`

not everything's useful though, and don't go overboard with per-slide content,
it can easily cut out

if you
  have too
many things
  in your
slides
  like this

Code
----

`Code blocks work <http://sphinx-doc.org/markup/code.htm>`_, with python as
default highlighting language::

    def foo(self):
        print 42

but as always the language can be specified:

.. code-block:: javascript

   function foo() {
       console.log(42);
   }

Code (cont)
-----------

Inline code can be a bear, so `including a separate file
<http://sphinx-doc.org/markup/code.html#includes>`_ can be useful

.. literalinclude:: code/foo.js
   :language: javascript
   :linenos:

although the language is not inferred, if it's not Python it has to be
explicitly specified. And the content-height warning still applies, although
``literalinclude`` lets you slice out bits of files (line numbers are not the
original file if sliced)

Multiple outputs
----------------

.. ifslides::

    You can have content just for slides (see HTML version)

.. ifnotslides::

    You can have content only in not-slides (e.g. HTML), which lets you expand
    on slides content or say different things to readers of non-slide formats
    (or the source).

.. note::

   and of course presenter's notes remain an option, depending on needs

Naming slides
-------------

is hard work, and sometimes a single "feature" must be spread over multiple
slides.

.. nextslide::

which is totally possible with the :rst:dir:`nextslide` directive. It'll
repeat the title for you.

.. nextslide::
   :increment:

plus it can increment a counter, if you like that stuff

.. nextslide::

don't mix and match though, either use ``:increment:`` everywhere or nowhere

.. nextslide::
   :increment:

otherwise it just looks weird

.. nextslide::

nice part: the HTML or PDF output will appear as a single section, no titles
breaking the flow. Not that a bunch of small paragraphs is necessarily
readable.

Images
------

you can put them in, I recommend odoo-colored ponies

.. image:: images/purple.png   
   :width: 50%

.. slide:: Images
   :class: fullscreen
   :inline-contents: True

   .. figure:: images/purple3.jpg
      :class: fill

      such odoo
   
   You can have fullscreen images too.

.. nextslide::

And the theme doesn't handle it very well by default, you have to use a
special :rst:dir:`slide` directive with a few options set

A primary title at the end
==========================

Looks like the first slide. You can thank your mom here, or those who listened
to your ramblings.
