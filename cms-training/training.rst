Website Training Core
=====================

Odoo Days 2014

Trivial module
--------------

.. code-block:: console

    $ ./oe scaffold -h
    usage:  scaffold [-h] [options] MODULE DIRECTORY

    Generate an OpenERP module skeleton.

.. code-block:: console

   $ ./oe scaffold Academy my-modules

creates directory ``my-modules/academy``

.. nextslide::

.. code-block:: text

    academy
    ├── __init__.py
    ├── __openerp__.py
    ├── controllers
    │   ├── __init__.py
    │   └── academy.py
    ├── models
    │   ├── __init__.py
    │   └── academy.py
    └── security
        └── ir.model.access.csv

.. nextslide::

.. code-block:: python

    {
        'name': "Academy",
        # short description, used as subtitles on modules listings
        'summary': "",
        # long description of module purpose
        'description': """
    """,
        # Who you are
        'author': "",
        'website': "",

        # categories can be used to filter modules in modules listing
        'category': 'Uncategorized',
        'version': '0.1',

        # any module necessary for this one to work correctly
        'depends': ['web'],
        'data': ['security/ir.model.access.csv'],
        'tests': [],
    }

.. nextslide::

.. code-block:: console

   createdb academy
   ./openerp-server --addons-path=addons,my-modules -d academy -i academy

* launch browser
* open http://localhost:8069
* see "Hello, world!"

.. nextslide::

.. code-block:: python

    from openerp import http
    from openerp.addons.web.controllers import main

    class academy(main.Home):
        @http.route('/', auth='none')
        def index(self):
            return "Hello, world!"

.. note::

   * extending web's Home to ensure correct ordering wrt dependencies
   * default auth is ``user``, requires valid logged-in user

     - ``none`` does not require log-in, always active (even if no database
       e.g. log-in page)
     - ``public``, either logged-in user or ``base.public_user``

.. nextslide::

Returned text is interpreted as HTML (not ``text/plain``)

.. only:: training

   .. topic:: Tasks

      1. Style by linking in ``/web/static/lib/bootstrap/css/bootstrap.min.css``
         (hook class: ``container``)

.. nextslide::

.. code-block:: html

    <!doctype html>
    <link
        rel="stylesheet"
        href="/web/static/lib/bootstrap/css/bootstrap.min.css">
    <body class="container">
        Hello, world!
    </body>

Parameterized
-------------

* Query string parameters (``?foo=3``) passed in as function parameters
* no validation
* no conversion

.. only:: training

   .. topic:: Tasks

      1. create some teaching assistants
      2. display links to TA indivdual pages using query strings
      3. display name & description of TA on their page

.. note::

   global array with dicts for TAs, name & description keys

.. nextslide::

http://localhost:8069/tas/?id=2

.. code-block:: python

    @http.route('/tas', auth='none')
    def ta(self, id):
        # code

.. note::

   * no default value => HTTP 500 if missing

   query string generally w/ default values, used for optional parameters

Converters
----------

* URL string can contain a converter pattern e.g. ``/foo/<var>``
* Passed as function (keyword) parameters
* Explicit converter function e.g. ``/foo/<int:var>``

.. only:: training

   .. topic:: Tasks

      1. use converter pattern for TA

.. note::

   * conversion function optional
   * validation (default: string, 1+, no ``/``)
   * type conversion (default: none)

.. nextslide::

http://localhost:8069/tas/2/

.. code-block:: python

    @http.route('/tas/<int:id>', auth='none')
    def ta(self, id):
        # code

.. note::

   Can easily be used for *mandatory* parameters, hierarchy

Templating
----------

* .. code-block:: xml

      <template id="..." name="...">
          html
      </template>

* Sugar for

  .. code-block:: xml

     <record id="..." model="ir.ui.view">
         <field name="name">...</field>
         ...
         <field name="arch" type="xml">
             html
         </field>
     </record>

.. note::

   * ``inherit_id``
   * ``groups``
   * ``primary=True``
   * ``optional`` (enabled/disabled)
   * ``page=True``

.. nextslide::

.. code-block:: python

    http.request.render(template[, values])

.. nextslide::

QWeb (Python flavored)

* Python expressions
* No inheritance, uses Odoo view inheritance

.. nextslide::

* ``t`` support element
* ``t-esc="$expr"``
* ``t-raw="$expr"``

.. code-block:: xml

    <p><t t-set="name"/></p>

.. only:: training

   .. topic:: Tasks

      1. move HTML to templates

.. note::

   add template file to manifest ``data``

.. nextslide::

* ``t-foreach="$expr" t-as="$name"``
* ``t-att-*="$expr"`` / ``t-attf-*="$format"``

.. code-block:: xml

   <ul>
       <t t-foreach="range" t-as="number">
           <li><t t-esc="number"/></li>
       </t>
   </ul>
   <ul>
       <li t-foreach="range" t-as="number">
           <t t-esc="number"/>
       </li>
   </ul>

.. nextslide::

.. only:: training

   .. topic:: Tasks

      1. move iteration/link generation of index to templates

Website support
---------------

.. code-block:: console

    $ ./openerp-server --addons-path=../web/addons,../addons,../my-modules \
                       -d academy -u academy --db-filter=academy

.. note::

   * add dependency
   * route ``website=True``

     - listing in sitemap
     - request.website
     - request.lang & multilang
     - request.redirect
   * ``auth='public'``

.. nextslide::

* ``t-call="$template_name"``
* ``website.layout``

.. only:: training

   .. topic:: Tasks

      1. convert templates to use website.layout

Website blocks (snippets
------------------------

* :guilabel:`Sign In`
* :guilabel:`Website`

* :menuselection:`Customize --> HTML Editor`
* :guilabel:`Edit`

.. note::

   blocks don't work

   enabled by specific pieces of markup in source (targets)

.. nextslide::

.. code-block:: xml

   <div id="wrap">
       <div class="oe_structure"/>
       <div class="oe_structure">
           <div class="container">

.. only:: training

   .. topic:: Tasks

      1. enable blocks on pages
      2. do edition on index (blocks & RTE)

.. only:: training

   Data storage and display
   ------------------------

   .. topic:: Tasks

      1. add blocks to a TA page
      2. go to other TA

   .. note::

      edits template itself, if template shared all instances are impacted


Data storage and display
------------------------

* Dynamic data should be in models
* ``http.request.registry[model]`` to get model

.. only:: training

   .. topic:: Tasks

      1. rename existing model
      2. convert index template to use model
      3. move TAs to data files

.. note::

   * may require ``-i``
   * TA page broken (still looks for removed global array)

.. nextslide::

New converter ``model(model_name)``::

    @http.route('/tas/<model("foo.bar"):value>/',
                auth='public', website=True)
    def ta(self, value):
        assert isinstance(value, Model)

.. only:: training

   .. topic:: Tasks

      1. fix TA page to use browse record

.. note::

   * ``model`` converter provides a record (browse) from an ID
   * can provide own converter by overriding ``_get_converters`` on
     ``ir.http``
   * TA name can not be edited

.. nextslide::

* ``t-field=record.field``
* must be placed on real node (not ``t``)

.. only:: training

   .. topic:: Tasks

      1. use ``t-field`` in TA template

.. note::

   ``t-esc`` is non-editable (and makes content around it non-editable):
   opaque arbitrary logic

   ``t-field`` is a specific edition sub-context, can be surrounded by an
   edition context

.. nextslide::

* template edition shared between template uses
* fields specific to object

.. only:: training

   .. topic:: Tasks

      1. add an HTML field (``biography``) to the TA model
      2. add ``biography`` to template for edition

.. note::

   full editor is enabled in HTML fields, can use blocks

More fields
-----------

* ``t-field-options`` can customise rendering
* ``date`` field take ``format`` option, `Locale Data Markup Language format
  pattern
  <http://unicode.org/reports/tr35/tr35-dates.html#Date_Format_Patterns>`_

.. only:: training

   .. topic:: Tasks

      1. Add a Lectures model with a ``Date`` field (& name)
      2. Add lectures data file
      3. Add table of lectures to index

.. note::

   * ``table class="table table-condensed table-hover"``
   * can display the same field multiple times, values not linked, draw winner
     is random
   * heavily formatted fields (e.g. date/datetime) revert to canonical
     representation during edition

Reusing work
------------

"Lectures" are a kind of "Event"

.. only:: training

   .. topic:: Tasks

      1. add ``website_event`` dependency

.. note::

   * kinda hypocritical
   * reload with ``-u``

.. nextslide::

* New "Events" menu
* Menus are records of ``website.menu``
* Menu-edition UI

.. only:: training

   .. topic:: Tasks

      1. Rename via data file (``website_event.menu_events``)

.. nextslide::

* Events/Lectures page listing
* Optional sidebar
* HTML editor for introspection
* Optional view inheritance

  - ``application``: ``always``, ``enabled``, ``disabled``
  - ``template optional="enabled|disabled"``

.. only:: training

   .. topic:: Tasks

      1. Remove sidebar via data file

.. nextslide::

* Lectures listing items complex

.. only:: training

   .. topic:: Tasks

      1. remove breadcrumbs
      2. remove "organized by"
      3. remove type

.. note::

   * HTML templates -> class over id
   * native XPath -> no support for class selection

     - ``contains(concat(' ', normalize-space(@class), ' '), concat(' ', $classname, ' '))``
     - ``tokenize(@class, '\s+') = $classname``
   * ``hasclass`` XPath function, for simpler selection within QWeb (py)
     templates, can take multiple classes ``//*[hasclass('foo', 'bar')]``

.. nextslide::

.. only:: training

   .. topic:: Tasks

      1. remove existing event data (registrations, events & event types)
      2. add "lectures" event type
      3. convert lectures demo data to events
      4. read & display events instead of lectures (restrict to lecture ``type``)

.. note::

   * Events page uses ``website_published`` field to know if an object should
     appear in the website
   * Can also replace TA object with ``res.users`` + ``res.partner``

     - add biography to partner
     - create teaching assistants ``res.groups``, only display those users
     - fixup visibility for reading users: "read access on my commercial
       partner" screws it up and prevents reading any user at all

Styling & Scripting
-------------------

Static assets

* Manifest declaration (web client, deprecated)
* Direct page inclusion
* Assets bundle

.. note::

   Template-based assets bundle:

   * bundle created (or not) during template rendering
   * new files added to bundle via template inheritance

.. nextslide::

* static files in ``/static`` directory (automatically mounted/accessible)
* presence

  - all templates (bundles)
  - some templates (layout ``head``)

.. only:: training

   .. topic:: Tasks

      1. Add file to all pages (``website.assets_frontend``), print message to
         console (``console.log``)

.. note::

   need short JS tutorial?

   all templates
     * increases loading size
     * executes on all pages (fail fast)
     * allows concatenation/minification
     * preloaded
   some templates
     * no minification
     * YAGNI
     * looser requirements

.. nextslide::

* jQuery
* bootstrap
* underscore
* underscore.string
* web client core
* website front

.. note::

   plenty of other stuff is included, those are the important ones

.. nextslide:: Web Client core

* ``openerp.Class``
* ``openerp.Widget``
* ``openerp.jsonRpc(url, 'call', args)``

.. note::

   ``Widget`` is ``Class`` with:
   * parenting relations (and cleanups)
   * lifecycle
   * own events
   * properties (w/ events)

.. nextslide:: Website front

* ``website.dom_ready``
* ``website.ready``
* ``website.add_template_file``
* ``website.reload``

.. note::

   ``ready``
     ``dom_ready`` + templates (+ translations if editable)
   ``add_template_file(url)``
     loads JS QWeb file (from /static)

.. nextslide:: Styling & Scripting

* ``@route(type='json')``
* openerp.jsonRpc(route, 'call', args)

.. note::

   could be rolled by hand over straight HTTP, JSON routes:

   * do JSON decoding of request and encoding of response
   * handle and encode errors
   * ``openerp.jsonRpc`` converts JSON-RPC errors (!HTTP) into deferred
     rejections failures

.. only:: training

   .. topic:: Tasks

      1. Create a controller letting you read a TA's biography over JSON-RPC
      2. Display a TA's biography on hover using e.g. bootstrap's popover

