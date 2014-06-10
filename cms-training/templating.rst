Website Templates
=================

Odoo Days 2014

.. note::

   No tasks for that one, have students play around and test things without
   formal instructions: there's nothing *hard* to imagine/use.

Odoo Object
-----------

* ``ir.qweb``

  - ``render_att_*``
  - ``render_tag_*``

.. note::

   * ``att_*`` checked first
   * ``render_att_$name``

     - ``t-*[:2].startswith($name)``
     - tuple ``(name, value)``

Expressions & formats
---------------------

* python expression
* string format

  - ``thing {{ expression }} other``
  - ``thing #{ expression } other``

.. note::

   * formats useful when building mostly-literal content
   * ``False`` or ``None`` -> ``''``

Blocks
------

.. code-block:: xml

   <div>
       <span t-if="condition">
           content
       </span>
   </div>

.. code-block:: xml

   <div>
       <span>
           content
       </span>
   </div>

.. code-block:: xml

   <div>

   </div>

.. note::

   no ``else`` clause

.. nextslide::

.. code-block:: xml

   <li t-foreach="expr" t-as="value">line</li>

* ``{as}``: ``a``
* ``{as}_size``: ``int``
* ``{as}_all``: ``type(expr)``
* ``{as}_value``: ``a``
* ``{as}_index``: ``int``
* ``{as}_first``: ``bool``
* ``{as}_even``: ``bool``
* ``{as}_odd``: ``bool``
* ``{as}_last``: ``bool``
* ``{as}_parity``: ``odd`` | ``even``

.. note::

   * if ``expr`` -> ``None``, skip iteration
   * if no ``as`` is specified, uses the ``foreach`` expression with all ``.``
     replaced by ``_``
   * no handling for dicts
   * no handling for integers
   * if value is dict, merged into evaluation context for body

.. nextslide::

.. code-block:: xml

   <t t-call="some.template">
       body
   </t>

.. note::

   * evaluates body before calling template
   * t-set in body
   * ``0``

Statements
----------

.. code-block:: xml

   <t t-esc="expression"/>

   <t t-escf="format"/>

.. note::

   * escaped
   * ``t-esc-options``, ``widget`` -> ``.format(t-esc, options, context)``
   * rendered within node name (! JS)

.. nextslide::

.. code-block::  xml

   <t t-raw="expression"/>

   <t t-rawf="format"/>

.. note::

   * not escaped
   * rendered within node name (! JS)

.. nextslide::

.. code-block:: xml

   <t t-set="name" t-value="expression"/>

   <t t-set="name" t-valuef="format"/>

   <t t-set="name">
       body
   </t>

.. note::

   defines ``{name}`` in surrounding context

Attributes
----------

.. code-block:: xml

   <span t-att-class="expr">

   <span t-attf-class="format">

   <span t-att="expr">

.. note::

   third form must return a tuple (or a 2-values iterable)

Fields formatting
-----------------

.. code-block:: xml

   <span t-field="attr.access"/>

   <span t-field="attr.access" t-field-options='{"key": "value"}'/>

.. note::

   * ``t`` node name not accepted
   * some restrictions on possible nodes (e.g. no table or list elements)
   * ``ir.qweb``.get_converter_for(widget | column._type)

.. nextslide::

``*``
  * ``html-escape``, ``True``

.. nextslide::

``float``

.. note::

   * formats according to field's ``digits``
   * ``res.lang``.format()

.. nextslide::

``date``
  * ``format``, ``lang.date_format``

.. note::

   * LDML format patterns

     ``babel.dates.format_date(value, format=pattern, locale=context_lang)``

.. nextslide::

``datetime``
  * ``format``, ``{{ lang.date_format }} {{ lang.time_format }}``

.. note::

   ``babel.dates.format_datetime``

.. nextslide::

``text``

.. note::

   converts newlines to ``<br>``

.. nextslide::

``selection``

.. note::

   displays label

.. nextslide::

``many2one``

.. note::

   displays name_get()

.. nextslide::

``image`` (``binary``)
  * ``class``
  * ``max_width``
  * ``max_height``

.. note::

   * no website -> base64 inline rendering
   * website -> link (``/website/image``)

     ``class="img img-responsive"``

.. nextslide::

``monetary`` (``float``)
  * ``display_currency="expression"``

.. note::

   * formats according to lang (``grouping=True, monetary=True``)
   * rounds according to currency
   * inserts currency symbol (position according to currency config)

.. nextslide::

``duration`` (``float``)
  * ``unit``

.. note::

   * unit in second, minute, hour, day, week, month, year
   * full formatting e.g. ``1.5 unit=hour`` -> ``1 hour 30 minutes``
   * ``babel.dates.format_timedelta``

.. nextslide::

``relative`` (``datetime``)

.. note::

   * relative time to/from now
   * direction ("in 5 minutes" vs "5 minutes ago")
   * highest unit only
   * rounds to higher unit at threshold (85%)

.. nextslide::

``contact``
  * ``fields``

.. note::

   * fields: name, address, city, phone, mobile, fax, website, email
   * options

     ``country_image``
       display ``country_id.image``
     ``no_marker``
       hide FontAwesome icons next to fields
   * ``base.contact`` template
