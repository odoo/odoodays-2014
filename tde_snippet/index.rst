CMS Dynamic Widgets
===================

Thibault Delavallée, R&D Engineer

Dynamic Widgets
---------------

.. image:: images/demo1.png   
   :align: right
   :width: 30%

* Efficient and simple way to customize your website
* Use the full power of Odoo
* Integrates with Odoo apps: subscribe to a discussion group, create leads, fill issues, ...

.. image:: images/demo2.png   
   :align: right
   :width: 90%

Outline
-------

* Introduction
* Body
* Options
* Dynamic
* Routes

Body: snippet content
---------------------

Body = `HTML`

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

Editor
------

Snippet declaration: add the snippet in the editor through inheritance

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

A thumbnail, a body

.. code-block:: xml

  <div>
    <div class="oe_snippet_thumbnail">
      <img class="oe_snippet_thumbnail_img" src="/images/icon.png"/>
      <span class="oe_snippet_thumbnail_title">Contact Snippet</span>
    </div>
    <section class="oe_snippet_body js_contact">
      ...
    </section>
  </div>

.. nextslide::

Snippet options: 

.. code-block:: xml

  <template id="contact_snippet" name="Contact Snippet" inherit_id="website.snippets">
    <div data-snippet-option-id='contact_snippet'
          data-selector=".js_contact"
          data-selector-siblings="p, h1, h2, h3, blockquote, div, .well, .panel">
      <li><a href="#" class="button js_contact_sales_team">Change Sales Team</a></li>
    </div>
  </template>

Dynamic configuration: Option
-----------------------------

Add an `Option` to add dynamic configuration

Example: `Discussion Group` choice, `Sales Team` choice, ...

.. code-block:: javascript

  snippet.options.contact_snippet = snippet.Option.extend({
    on_prompt: function () {
      ...
      return website.prompt({
        window_title: _t("Add a Contact Snippet"),
        init: function (field) {
          return website.session.model('crm.case.section')
                  .call('name_search', ['', []])},
      }).then(function (sales_team_id) { ... });
    }
  });

Dynamic behavior: Animation
---------------------------

.. code-block:: javascript

  snippet.animationRegistry.contact_snippet = snippet.Animation.extend({
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

Dynamic behavior: routing
-------------------------

Define a new route in the controller

.. code-block:: python

  @http.route(['/crm/contact_short'], type='json')
  def contactus(self, question=None, email=None, section_id=None, **kwargs):
    lead_values = { ... }
    return request.registry['crm.lead'].create(cr, uid, lead_values, context)

Summary
-------

* Definition: an HTML body in a template
* Placement: XML declaration
* Configuration: JS Option
* Behavior: JS Animation
* Link: controllers


Widgets Rulez
=============

Any questions ? Feel free to contact chm@openerp.com
