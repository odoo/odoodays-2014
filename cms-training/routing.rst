Website Routing
===============

Odoo Days 2014

Type
----

* ``http``
* ``json``

Auth
----

* ``none``

  ``request.uid`` is ``None``
* ``public``

  ``request.uid`` is ``request.session.uid`` or ``base.public_user``
* ``user``

  ``request.uid`` is ``request.session.uid``

.. nextslide::

``ir.http``

.. code-block:: python

   def _auth_method_$authtype(self):
       # set uid

.. note::

   ``_auth_method_calendar`` uses token in query string

HTTP methods
------------

.. code-block:: python

   @route('/foo', methods=['POST'])
   def m(self, **kw):
       # code

.. only:: training

   .. topic:: Tasks

      1. dispatch same URL to different functions based on HTTP methods (use
         forms)

.. note::

   * restrict URL to specific method

     - caching issues
     - cross-site requests
   * dispatch based on method (HTTP-based API)
   
Converters
----------

* ``<param>``
* ``<converter:param>``
* ``<converter(0, arg1=foo, arg2="foo bar"):param>``

.. note::

   * unquoted string if valid identifier (strings & letters)

.. nextslide::

* ``string(minlength=1, maxlength=None, length=None)``
* ``path``
* ``any(*items)``
* ``int([fixed_digits][, min][, max])``
* ``float([min][, max])``
* ``uuid`` (Werkzeug 0.10)
* ``model(model_name)``

.. only:: training

   .. topic:: Tasks

      1. try out converters in URLs

.. note::

   * default converter is ``string``
   * ``path`` is ``string`` w/ ``/`` inclured, as short as possible

.. nextslide::

``ir.http``: ``_get_converters(self): {name: class}``

* Extend ``werkzeug.routing.BaseConverter``
* Set ``self.regex``
* Define ``to_python(self, value): a``
* Define ``to_url(self, value): str``

.. only:: training

   .. topic:: Tasks

      1. Create and test a converter from hex to dec

.. note::

   Probably not the most useful thing, but if it can be useful to know that it
   does exist.

   Actual good use might be a RegexConverter.

Multiple patterns
-----------------

.. code-block:: python

   @route('/foo')
   def m1(self):
       pass

   @route(['/foo', '/bar'])
   def m2(self):
       pass

.. only:: training

   .. topic:: Tasks

      1. Create a controller with an optional routed parameter

.. note::

   May or may not be better than multiple converters delegating to a "master"
   method

Website support
---------------

.. code-block:: python

   @route('/foo', website=True)
   def m(self):
       pass

* ``request.website``
* ``request.lang``
* ``request.redirect(url)``

.. note::

   ``request.website``

     instance of the current ``Website`` object, equivalent to calling
     ``get_current_website``. No multiple website supported currently, but
     useful shortcut in case

   ``request.lang``

     language identifier from the URL or default language for the website,
     also set in request context

   ``request.redirect(url)``

     shortcut for language-aware ``werkzeug.util.redirect``


Website support: multilang
--------------------------

.. todo explain multilang

.. todo explain website translations
