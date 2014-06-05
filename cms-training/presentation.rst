V8 Frontend
===========

Odoo Days 2014

Historical Background
=====================

.. note::

   Python side of clients

   * Clients over XML-RPC (~6.0)

     - everything generic calls to backend
     - extensibility in server addons
   * v6.1 Web Client

     - javascript (browser side)
     - python side mostly pass-through (to server API)
     - missing / not implemented browser API, incompatibilities

       - file upload & download
       - assets
       - http sessions
     - OK underlying structure, lacking API (no greatness required)

   * v8 website

     same underlying system, better API

``openerp.http``
================

.. note::

   from where most of the frontend things are available

Controllers
-----------

http://yourserver.com/hello/

.. code-block:: python

   from openerp import http

   class MyController(http.Controller):
       @http.route('/hello/')
       def hello(self, **kw):
           return "Hello, world"

.. nextslide::

.. code-block:: python

   @http.route('/hello')
   def hello(self, **kw):
       return '<h1><em>Hello</em>, world</h1>'

.. code-block:: python

   @http.route('/hello')
   def hello(self, **kw):
       return http.Response('<h1><em>Hello</em>, world</h1>',
                            mimetype='text/html')

.. note::

   * when returning a bare string, implicitly wrapped in a ``Response`` object
   * extends Werkzeug's response

     - status
     - content type
     - headers
     - caching directives

.. nextslide::

http://yourserver.com/hello/?name=Alice

.. code-block:: python

   @http.route('/hello/')
   def hello(self, name, **kw):
       return "Hello, {}".format(name)

http://yourserver.com/hello/ -> 500 Server Error

.. note::

   * no validation
   * no conversion
   * any issue -> Server Error (500)

.. nextslide::

.. code-block:: python

   @http.route('/hello/')
   def hello(self, name="World", **kw):
       return "Hello, {}".format(name)

URL Patterns
------------

http://yourserver.com/hello/Alice/

.. code-block:: python

   @http.route('/hello/<name>/')
   def hello_person(self, name, **kw):
       return "Hello, {}".format(name)

   @http.route('/hello/')
   def hello(self, **kw):
       return "Hello, world"

.. note::

   * validation
   * conversion
   * dispatching

.. nextslide::

http://yourserver.com/hello/39543897/

.. code-block:: python

   @http.route('/hello/<int:identifier>/')
   def hello_robot(self, identifier, **kw):
       return "Hello, {}".format(identifier)

.. nextslide::

http://yourserver.com/hello/cs_CZ/

.. code-block:: python

   @http.route('/hello/<string(length=5):lang>')
   def hello_lang(self, lang, **kw):
       return "Hello, {}".format(lang)

.. nextslide::

http://yourserver.com/hello/mammal/385/

.. code-block:: python

   @http.route(
       '/hello/<any(amphibian, bird, mammal, reptile):group>/<int:id>/')
   def hello_you(self, group, id, **kw):
       return "Greetings sample {} {}".format(group, id)

.. nextslide::

http://yourserver.com/hello/3/

.. code-block:: python

   @http.route('/hello/<model("res.partner"):partner>/')
   def hello_p(self, partner, **kw):
       return "Hello, {}".format(partner.display_name)

.. nextslide::

* ``string(minlength=1, maxlength=None, length=None)``
* ``path``
* ``any(*items)``
* ``int([fixed_digits][, min][, max])``
* ``float([min][, max])``
* ``uuid`` (Werkzeug 0.10)
* ``model(model_name)``

``ir.http``, ``_get_converters``

Multiple patterns
-----------------

* Optional data
* Mutiple routes to same-ish controller

v1: master controller

.. code-block:: python

   @http.route('/hello/')
   def hello_0(self, **kw):
       return hello(self, None)

   @http.route('/hello/1/')
   def hello_1(self, **kw):
       return hello(self, 1)

   def hello(self, value):
       # do things

.. nextslide::

v2: multiple patterns

.. code-block:: python

   @route(['/hello/', '/hello/<int:value>/'])
   def hello(self, value=None):
       # do things

Auth check
----------

* runs between URL dispatch and running method
* sets ``http.request.uid`` ("current user")
* errors converted to 403 (Forbidden)

.. nextslide::

.. code-block:: python

   @http.route('/hello/', auth="user")
   def hello(self, **kw):
       # code

* default
* requires logged user
* redirects to login page if not logged
* ``request.uid`` is ``id`` of logged ``res.users``

.. nextslide::

.. code-block:: python

   @http.route('/hello/', auth='public')
   def hello(self, **kw):
       # code

* ``user.id`` if logged
* otherwise ``base.public_user``

.. nextslide::

.. code-block:: python

   @http.route('/hello/', auth='none')
   def hello(self, **kw):
       # code

* ``request.uid`` is ``None``

.. nextslide::

Custom auth checks, override existing checks

* sharing tokens
* LDAP
* SSO

``ir.http``, ``_auth_method_user``, ``_auth_method_yourauth``

.. nextslide::

.. code-block:: python

   @http.route('/hello/', methods=['GET'])
   def get_hello(self, **kwargs):
       return ('<form action="/hello" method="POST">'
                   '<input type="submit" value="post"/>'
               '</form>')
   @http.route('/hello/', method=['POST'])
   def post_hello(self, **kwargs):
       return '<a href="/hello">get</a>'

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

.. nextslide::

.. code-block:: python

   http.request.render(template[, values])

.. code-block:: python

   @http.route('/hello/')
   def hello(self, **kw):
       return http.request.render('module.hello')

.. note::

   * render external id
   * fully qualified, prefixed with module name

.. nextslide::

QWeb (Python-flavored)

.. code-block:: xml

   <template id="hello">
       <p>Hello, <t t-esc="name"/>!</p>
   </template>

``http.request.render('module.hello', {'name': "World"})``

.. code-block:: xml

    <p>Hello, World!</p>

.. nextslide::

.. code-block:: xml

   <template id="hello">
       <t t-set="greet" t-value="name + '!!!'"/>
       <p>Hello, <t t-esc="greet"/></p>
   </template>

   <template id="hello">
       <t t-set="greet" t-valuef="{{ name }}!!!"/>
       <p>Hello, <t t-esc="greet"/></p>
   </template>

   <template id="hello">
       <t t-set="greet">
           <em>Hello</em>, <t t-esc="name"/>
       </t>
       <p><t t-raw="greet"/>!</p>
    </template>

.. nextslide::

.. code-block:: xml

   <template id="hello">
       <p>
           <span t-if="name == 'World'"/>
               Hello, world!
           </span>
       </p>
   </template>

``http.request.render('module.hello', {'name': "World"})``

.. code-block:: xml

   <p><span>Hello, world!</span></p>

``http.request.render('module.hello', {'name': "Mal"})``

.. code-block:: xml

   <p></p>

.. nextslide::

.. code-block:: xml

   <template id="hello">
       <t t-set="condition" t-value="name == 'World'"/>
       <p t-if="condition">
           Hello, world!
       </p>
       <p t-if="not condition">
           Hello, not world
       </p>
   </template>

``http.request.render('module.hello', {'name': "World"})``

.. code-block:: xml

   <p>Hello, world!</p>

``http.request.render('module.hello', {'name': "Mal"})``

.. code-block:: xml

   <p>Hello, not world</p>

.. note::

   no ``else`` block at this point, has to be emulated by hand

.. nextslide::

.. code-block:: xml

   <template id="hello">
       <ul>
           <li t-foreach="name" t-as="letter">
               <t t-esc="letter_index"/>: <t t-esc="letter"/>
           </li>
       </ul>
   </template>

``http.request.render('module.hello', {'name': list("World")})``

.. code-block:: xml

   <ul>
       <li>0: W</li>
       <li>1: o</li>
       <li>2: r</li>
       <li>3: l</li>
       <li>4: d</li>
   </ul>

.. nextslide::

.. code-block:: xml

   <t t-foreach="seq" t-as="value">

* ``value``
* ``value_size``
* ``value_all``
* ``value_index``
* ``value_first``: ``bool``
* ``value_last``: ``bool``
* ``value_parity``: ``'even' | 'odd'``

.. nextslide::

.. code-block:: xml

   <template id="sub">
       <t t-esc="identifier"/>
   </template>
   <template id="hello">
       <p>
           Hello,
           <t t-call="module.sub">
               <t t-set="identifier" t-value="name"/>
           </t>
       </p>
   </template>

``http.request.render('module.hello',{'name':"World"})``

.. code-block:: xml

   <p>Hello, World</p>

.. nextslide::

.. code-block:: xml

   <template id="sub">
       <section><t t-raw="0"/></section>
   </template>
   <template id="hello">
       <t t-call="module.sub">
           <p>Hello, world!</p>
       </t>
   </template>

``http.request.render('module.hello',{'name':"World"})``

.. code-block:: xml

   <section>
       <p>Hello, world!</p>
   </section>

.. nextslide::

``t-att-{attname}="{expression}"``
``t-attf-{attname}="{expression}"``

.. code-block:: xml

    <template id="hello">
        <p t-att-class="name.lower()">Hello, world</p>
        <p t-attf-class="cl-{{ name.lower() }}">Hello, world</p>
    </template>

``http.request.render('module.hello',{'name':"World"})``

.. code-block:: xml

   <p class="world">Hello, world</p>
   <p class="cl-world">Hello, world</p>

.. nextslide::

Record field rendering

.. code-block:: python

   @http.route('/hello/<model("res.users"):user>/')
   def hello(self, user, **kw):
       return http.request.render('module.hello', {'user': user})

.. nextslide::

.. code-block:: xml

   <template id="hello">
       <p t-field="user.display_name"/>
   </template>

http://yourserver/hello/1/

.. code-block:: xml

   <p>Administrator</p>

http://yourserver/hello/4/

.. code-block:: xml

   <p>Demo User</p>

.. nextslide::

.. code-block:: xml

   <template id="hello">
       <p t-field="user.create_date"/>
       <p t-field="user.create_date" t-field-options='{"format": "long"}'/>
       <p t-field="user.create_date" t-field-options='{"format": "EEE"}'/>
   </template>

http://yourserver/hello/4/

06/02/2014 18:17:00

June 2, 2014 at 6:17:00 PM +0200

Mon

.. nextslide::

.. code-block:: xml

   <template id="hello">
       <p t-field="user.wealth"/>
       <p t-field="user.wealth"
          t-field-options='{
              "widget": "monetary",
              "display_currency": "user.company_id.currency_id"
          }'/>
   </template>

http://yourserver/hello/4/

1860

1860.00 €

Change company's currency to USD:

29347

$ 29347.00

.. note::

   I added a "wealth" integer field to users for this demo

.. nextslide::

.. code-block:: xml

   <template id="hello">
       <p t-field="user.create_date" t-field-options='{"widget": "relative"}'/>
   </template>

"2 days ago"

.. nextslide::

Fields:

* default (str)
* ``float``
* ``date``
* ``datetime``
* ``text``
* ``selection``

.. nextslide::

Widgets:

* ``image`` (binary)
* ``monetary`` (float)
* ``duration`` (float)
* ``relative`` (datetime)
* ``contact`` (``res.partner`` many2one)

Website Support
===============

Website in controllers
----------------------

.. code-block:: python

    @http.route('/hello/', website=True)
    def hello(self, **kw):
        return http.request.render('module.hello')

* ``http.request.website``
* ``http.request.lang``
* multilang & translations
* ``http.request.redirect(url)``

.. nextslide::

``website.layout`` template

* header & footer
* menu
* edition tools

View inheritance
----------------

.. code-block:: xml

   <template id="hello">
       <p>Base template</p>
   </template>
   <template id="hello2" inherit_id="hello" name="Extender">
       <xpath expr="//p" position="before">
           <h1>Extended!</h1>
       </xpath>
   </template>

.. code-block:: xml

   <h1>Extended!</h1>
   <p>Base template</p>

.. nextslide::

.. code-block:: xml

   <template id="hello">
       <p class="a">A</p>
       <p class="b">B</p>
       <p class="c">C</p>
   </template>
   <template id="hello2" inherit_id="hello"
             name="Extender">
       <xpath expr="//p[hasclass('b')]" position="before">
           <h1>Extended!</h1>
       </xpath>
   </template>

.. code-block:: xml

   <p class="a">A</p>
   <h1>Extended!</h1>
   <p class="b">B</p>
   <p class="c">C</p>

Optional inheritance
--------------------

.. code-block:: xml

   <template id="hello">
       <t t-call="website.layout">
           <p class="a">A</p>
           <p class="b">B</p>
           <p class="c">C</p>
       </t>
   </template>
   <template id="hello2" inherit_id="hello"
             name="Extender" optional="enabled">
       <xpath expr="//p[hasclass('b')]" position="before">
           <h1>Extended!</h1>
       </xpath>
   </template>

.. note:: show toggling on and off

Controller extension
--------------------

* can extend templates
* add new static data/blocks
* new dynamic data?

.. nextslide::

.. code-block:: python

    import uuid
    from openerp.addons import website_event
    class Event(website_event.controllers.main.website_event):
        @http.route()
        def event_register(self, event, **post):
            response = super(Event, self).event_register(event, **post)
            response.qcontext['new_data'] = uuid.uuid4().hex
            return response

    # add to templates
    <template id="change_stuff"
              inherit_id="website_event.event_description_full">
        <xpath expr="//div[@itemprop='description']" position="before">
            <p t-esc="new_data"/>
        </xpath>
    </template>
