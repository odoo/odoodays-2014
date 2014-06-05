CMS Dynamic Widgets
===================

Thibault Delavallée, R&D Engineer

Dynamic widgets
---------------

.. image:: images/editor_gen1.png
   :width: 95%
   :align: center
   :class: mt16

.. nextslide::

Widgets, Snippets -> CMS building blocks

.. image:: images/editor_1.png
   :width: 70%
   :align: center
   :class: mt16

Dynamic widgets: Discussion Groups, Mailing Lists

.. image:: images/discussion_group_1.png
   :width: 50%
   :align: center
   :class: mt16

.. nextslide::

* Efficient and simple way to customize your website
* Integrates with Odoo apps: subscribe to a discussion group, create leads, fill issues, ...
* Use the full power of odoo

.. image:: images/mailing_list_1.png
   :width: 50%
   :align: center
   :class: mt16

.. image:: images/mailing_list_2.png
   :width: 60%
   :align: center
   :class: mt8

Show me the stuff !
-------------------

.. image:: images/demo1.png
   :align: right
   :width: 30%

Running example: **Contact Widget**

* small contact form
* create leads from questions
* drag 'n drop it anywhere usefull

.. image:: images/demo2.png
   :align: center
   :width: 90%
   :class: mt32

Demo
====

Talk structure
--------------

.. image:: images/demo1.png
   :align: right
   :width: 35%
   :class: mt32

Running example: Contact Widget

* body, content
* addition in CMS editor
* dynamic configuration: choosing the sales team
* link with backend: linking the button to the lead creation

Body: widget content
---------------------

.. image:: images/contact_body.png
   :align: right
   :width: 40%

Body = **HTML** + **CSS** (bootstrap)

* a (hidden) sales team
* a question
* an email
* a submit button

.. code-block:: xml

  <input type="hidden" name="section_id" value="0"/>
  <textarea name="description"></textarea>
  <div class="input-group">
    <input type="email" name="email_from"/>
    <button type="submit">Contact Us</button>
  </div>

Addition in Editor
------------------

Snippets ? QWeb template !

.. image:: images/editor_1.png
   :width: 70%
   :align: center
   :class: mt16

.. code-block:: xml

  <?xml version="1.0" encoding="utf-8"?>
  <openerp>
  <data>
    <template id="snippets">
    <!-- here be snippets by categories -->
    ...
    </template>
  </data>
  </openerp>

.. nextslide::

Snippet addition: extend the editor QWeb template

.. code-block:: xml

  <template id="contact_snippet"
            name="Contact Snippet"
            inherit_id="website.snippets">
    <xpath expr="//div[@id='snippet_feature']" position="inside">
      <!-- begin snippet declaration -->
      <div>
        ...
      </div>
      <!-- end of snippet declaration -->
    </xpath>
  </template>

.. nextslide::

* thumbnail: icon in editor

.. code-block:: xml

  <xpath expr="//div[@id='snippet_feature']" position="inside">
    <div class="oe_snippet_thumbnail">
      <img class="oe_snippet_thumbnail_img" src="/images/icon.png"/>
      <span class="oe_snippet_thumbnail_title">Contact Snippet</span>
    </div>
  </xpath>

* body of the snippet

.. code-block:: xml

  <xpath expr="//div[@id='snippet_feature']" position="inside">
    <section class="oe_snippet_body js_contact">
      <!-- snippet HTML content -->
    </section>
  </xpath>

Snippet options
---------------

* placement: `data-selector-...`
* menu option: `li`, option menu entry

.. code-block:: xml

  <div data-snippet-option-id='contact_snippet'
        data-selector=".js_contact"
        data-selector-siblings="p, h1, h2, h3, blockquote,
                                div, .well, .panel">
    <li>
      <a href="#" class="button js_contact_sales_team">
        Change Sales Team
      </a>
    </li>
  </div>

Widget -> Dynamic Widget
========================

Dynamic customize
-----------------

Customize menu

.. image:: images/contact_custo_1.png
   :align: center
   :width: 40%

To link with

.. image:: images/contact_custo_2.png
   :align: center
   :width: 70%
   :class: mt8

.. nextslide::

Add a `snippet.Option` to add dynamic configuration

Example: `Discussion Group` choice, `Sales Team` choice, ...

.. code-block:: javascript

  snippet.options.contact_snippet = snippet.Option.extend({

    on_prompt: function () {
      return website.prompt({
        window_title: _t("Add a Contact Snippet"),
        init: function (field) {
          return website.session.model('crm.case.section')
                  .call('name_search', ['', []])},
      }).then(function (sales_team_id) {
        self.$('.js_section_id').attr("value", sales_team_id);
      });
    }
  });

Link with back-end
------------------

To contact the back-end: define a new **route**

* Route: URL -> action performed by server
* Defined in Python, in a controller

.. code-block:: python

  class ContactUsShort(http.Controller):
    # define my custom controller
    @http.route('/my/route', ...)
    def my_route(...):

`{http://myodoo.com/}crm/contact_short` will be a route creating a lead from data coming from the form

.. nextslide::

`crm/contact_short` definition

.. code-block:: python

  @http.route(['/crm/contact_short'], type='json')
  def contactus(self, question=None, email=None,
                section_id=None, **kwargs):
    lead_values = {
      'name': 'Lead from %s (Contact Snippet)' % email,
      'description': question,
      'email_from': email,
      'section_id': section_id,
      'user_id': False,
    }
    return request.registry['crm.lead'].create(cr, uid, lead_values,
                                               context)

Dynamic behavior
----------------

Bind `Contact Us` to the back-end

.. code-block:: javascript

  snippet.animationRegistry.contact = snippet.Animation.extend({
    start: function (editable_mode) {
      this.$('.js_contact_btn').on('click', function (event) {
        // perform verification
        ...
        // json call to a route
        return openerp.jsonRpc('/crm/contact_short', 'call', {
            'section_id': +section_id,
            'email': email,
            'question': question,
        }).then(function (result) { ... });
      });
    },
  });

And we are done !
-----------------

.. image:: images/contact_body.png
   :align: right
   :width: 45%

* Definition: an HTML body in a template
* Placement: XML declaration
* Configuration: JS Option
* Behavior: JS Animation
* Link: Python controller and routes


Thanks for your attention
=========================

Any questions ? tde@odoo.com / chm@odoo.com
