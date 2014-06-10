CMS performances optimization
=============================

Fabien Meghazi

.. note::

    This presentation is splitted in two parts (performance, scalability)

Performance
===========

Refers to the capability of a system to provide a certain response time.

.. note::

    Performance and scalability are often confused terms.

Performance
-----------

What has been done in odoo in terms of performance optimization ?

.. rst-class:: build

1.  **A new type of view (QWeb)**

    .. rst-class:: build

    - QWeb views are Odoo objects (`ir.ui.view`)
    - ORM Cache activated on those views (and their translations)
    - Same fexibility than other view types (inheritance)
    - No additional SQL queries for snippets or custom content

.. nextslide::

1. A new type of view (QWeb)
2. **Asset bundles**

.. nextslide::

Here's what we can find in the `document > body > head` of most CMS's default setup.

.. code-block:: html

    <head>
        <link href="/files/css/css_pbm0lsQQJ7A7WCCIMgxLho6mI_kBNgznNUWmTWcnfoE.css" type="text/css" rel="stylesheet"/>
        <link href="/files/css/css_GgerrJ1eO2p2FAGV0vkRGdFa8QLXDr0-mUgvpPQTbXU.css" type="text/css" rel="stylesheet"/>
        <link href="/files/css/css_GLOpzAhXMtWYvS4h5wbl6MtSyjZs8gh4uS0H2yCFKMQ.css" type="text/css" rel="stylesheet"/>
        <link href="/files/css/css_FA2n7wdGXAxEt6RZrMKCEcj3lLJtYSo_M5fkYjNGzYY.css" type="text/css" rel="stylesheet"/>
        <link href="/files/css/css_BxX7fMKqodl8G9DZ2zEO8tz0u1pex3OS77VssQ6kAbs.css" type="text/css" rel="stylesheet"/>
        <script src="/files/js/js_xAPl0qIk9eowy_iS9tNkCWXLUVoat94SQT48UBCFkyQ.js" type="text/javascript"></script>
        <script src="/files/js/js_pWaEh3PAhCcBT2MOtrKzosTxS9eM5SUYFirhq9KQa0M.js" type="text/javascript"></script>
        <script src="/files/js/js_sqDzf_5suPJcQpKY1lVF0I5wO_5bUrj5RwpiTKV3w3o.js" type="text/javascript"></script>
        <script src="/files/js/js_TA8qfKqSlPTRUeVEmNo6g-LK6_BQOwPCT-lpp_13vP8.js" type="text/javascript"></script>
        <script src="/files/js/js_rv_BKYv7yieH0IgHddhWHDC-bWGan8yiJbusyOpr0mw.js" type="text/javascript"></script>
        <script src="/files/js/js_fZbsGtwY7jnTvjaAvTzUEFJKO-FkHlZC6o1x2O_56wc.js" type="text/javascript"></script>
        ...

.. note::

    Before you check the html of our website, you have to know that this
    feature is in master but not yet deployed for our website.

.. nextslide::

*Why is it a problem?*

=========== =====
Browser     Max. concurrent connections per domain
=========== =====
Firefox 3+  6
Opera 12+   6
Safari 5+   6
IE 8        6
IE 10       8
Chrome      6
=========== =====

.. rst-class:: build
Lack of @aync or @defer makes javascript loading synchronous.


.. note::

    @defer can help to defer the execution thus allowing the browser to
    continue parsing. But @defer might behave differently from browser to browser
    @async allow to load script asynchronously but the order of execution is
    not granted.
    If neither @async or @defer is present: each script is fetched and
    executed immediately, before the browser continues parsing the page

.. nextslide::

Solved by asset bundles!

.. code-block:: html

    <head>
        <link href="/web/css/website.assets_frontend" rel="stylesheet"/>
        <script src="/web/js/website.assets_frontend"></script>

An asset bundle automatically concatenates and minifies javascripts and
stylesheets in order to reduce the page load latency.
Of course, once a bundle is generated, it's cached.

.. code-block:: html

    <script src="/web/js/website.assets_frontend/da39a3e"></script>

Versioned bundles (still to be merged in master for v8)

.. note::

    Currently in master, once a file is changed, the visitors will still use
    the previous generated bundle until it's cache expires (5min)

    We'll add bundle versioning in order to solve this issue.

.. nextslide::

Asset bundles are Odoo views too (`ir.ui.view`) !

.. code-block:: xml

    <template id="my_theme" inherit_id="website.assets_frontend">
    <xpath expr="." position="inside">
        <script src="/my_theme/static/src/js/my_theme.js"></script>
        <link href="/my_theme/static/src/css/my_theme.css" rel="stylesheet"/>
    </xpath>
    </template>

As such, they benefit of all the advantages we just talked about in the previous topics.

.. nextslide::

1. A new type of view (QWeb)
2. Asset bundles
3. **E-tags for images**

Scalability
===========

Ability of a system to handle a growing amount of work in a capable manner.

Scalability
-----------

What does Odoo provides in terms of scalability?

1.  **ORM prefetch**

.. code-block:: python

    # res.partner
    companies = self.search([('is_company','=',True)])
    for company in companies:
        for contact in company.child_ids:
            if contact.country_id:
                print u"%s : %s" %
                    (contact.name, contact.country_id.name)

.. nextslide::

An ORM lacking prefetch can't provide an efficient SQL query plan:

.. code-block:: sql

    -- 1 query - N results
    SELECT ... FROM res_partner

    -- N queries - M results
    SELECT ... FROM res_partner WHERE parent_id = <id>

    -- N*M queries
    SELECT ... FROM res_country WHERE id = <id>

On 200 companies with ~2 linked partners each would cause those
nested loops to make 601 SQL queries.

In Odoo, the chains of browse record lists allows the ORM to efficiently
plan the same operations in 5 SQL queries

.. nextslide::

1.  ORM prefetch
2.  **Preforked workers (same as Gunicorn)**

    .. rst-class:: build

    - processes resources can be restricted using the Odoo server's `--limit-*` options
        - limit by maximum used memory
        - limit by maximum time (cpu or real)
        - limit by maximum requests

.. rst-class:: build
3.  One gevented process for the chat module and async notifications
4.  Stateless model (Odoo servers can be clustered)

.. note::

    Cache invalidation and registry reloading is managed through Postgresql

Results
-------

Want detailed results, benchmarks and comparison of performance?

Please attend to the "Open Source CMS: a performance comparison" talk
by Mantavya Gajjar in this room at 16:20.

Questions ?
===========

Thanks for listening !
======================

