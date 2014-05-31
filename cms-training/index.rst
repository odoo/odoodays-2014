Website Training
================

Odoo Days 2014

Core
----

Working knowledge of the new Website module(s) and features:

* Responding to HTTP requests
* QWeb (py) templates
* Displaying business data in your website
* Using and customizing existing modules

Advanced field formatting
-------------------------

- default (``html-escape: True``)
- float
- date (``format: lang.date_format``)
- datetime (``format: lang.date_format + ' ' + lang.time_format``)
- text
- selection
- many2one
- html
- image
- monetary (``display_currency``)
- duration (float, ``unit``)
- relative (datetime, to now)
- contact (res.partner?, ``fields``)

Advanced routing features
-------------------------

- type
- auth
- method
- converters

  + ``<param>``, ``<converter:param>``, ``<converter(0, arg1=foo, arg2="foo,
    bar"):param>``
  + ``string(minlength=1, maxlength=None, length=None)``, ``path``,
    ``any(*items)``, ``int([fixed_digits][, min][, max])``, ``float([min][,
    max])``, ``uuid`` (Werkzeug 0.10)
- multiple patterns
- multilang & translations

Controller overriding?
----------------------

- ``@route()``
- accumulation of routing info (partial override)
- name-based (mostly)
- single-level (?)
- lazy rendering (by default) -> overrides can extend the (HTML) template and
  inject new values in the rendering context before the rendering actually
  happens

Asset bundles
-------------

Javascript website APIs
-----------------------

Snippets
--------

Dependencies
------------

Uses the "new API" (``apiculture``) branch. Not much of the new API will be
used, if you want that see the *V8 API* training session.
 
Sections
--------

.. toctree::
   :maxdepth: 1

   training
