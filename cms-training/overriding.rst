Overriding controllers
======================

Odoo Days 2014

Creation
--------

* Extend ``openerp.http.Controller``.
* Definine routes with ``openerp.http.route``

.. code-block:: python

   class MyController(http.Controller):
       @http.route('/foo', auth='public')
       def foo(self, **kw):
           return "foo"

Add routes
----------

* Extend the controller
* Only direct subclasses of ``Controller`` (single level)

.. code-block:: python

   class Changes(MyController):
       @http.route('/bar/', auth='public')
       def bar(self, **kw):
           return "bar"

.. note::

   that's not actually very useful, you could just define a new and
   independent contoller, unless you need to call utility methods defined by
   the original

Override existing
-----------------

* Exposed endpoints looked up on the terminal method
* Just overriding the method will "unpublish" it

.. code-block:: python

   class Changes(MyController):
       def foo(self, **kw):
           return "[{}]".format(super(Changes, self).foo(**kw))

.. nextslide::

* ``route()`` to keep the route exposed
* arguments get inherited (last definition wins)
* not possible to add new patterns

.. code-block:: python

   class Changes(MyController):
       @http.route()
       def foo(self, **kw):
           return "[{}]".format(super(Changes, self).foo(**kw))

Templates
---------

* Inheritance to change template itself
* ``http.request.render`` creates ``http.Response``
* Defaults to ``lazy=True``
* Only rendered at last possible moment
* ``response.qcontext`` for template rendering context
* ``response.template`` for template name

.. warning::

   if ``http.request.render(lazy=False)``, template rendered immediately. Can
   be checked with ``response.is_qweb`` (``True`` -> not rendered yet)
