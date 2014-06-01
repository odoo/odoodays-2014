Technical Upgrade V8
====================

Raphael Collet (rco@odoo.com)


Purpose
-------

* Learn the new Python API and its concepts
* Learn the compatibility hooks
* Apply them to migrate existing modules


The Python API of Odoo V8
=========================


The Python API
--------------

* Programming with recordsets
* Environment object
* Methods and method decorators
* Fields as Python descriptors
* Computed fields
* Onchange methods
* Python constraints


Recordsets
----------

A **recordset** is:
    * an ordered collection of records
    * one concept to replace
        * browse records,
        * browse lists,
        * browse nulls.
    * an instance of the model's class

.. note::
    Explain the similarity with strings in Python.


The recordset as a collection
-----------------------------

It implements sequence operations::

    partners = env['res.partner'].search([])

    for partner in partners:
        assert partner in partners
        print partner.name

    if len(partners) >= 5:
        fifth = partner[4]

    extremes = partners[:10] + partners[-10:]

    union = partners1 | partners2
    intersection = partners1 & partners2
    difference = partners1 - partners2

.. note::
    The collection is immutable.


The recordset as a record
-------------------------

It behaves just like former browse records::

    print partner.name
    print partner['name']
    print partner.parent_id.company_id.name

Except that updates are written to database::

    partner.name = 'Agrolait'
    partner.email = 'info@agrolait.com'
    partner.parent_id = ...                 # another record

.. note::
    The cache optimizes database accesses.

    Contrary to V7, the cache is consistent.

.. nextslide::

If ``len(partners) > 1``, do it on the **first** record::

    print partners.name                     # name of first partner
    print partners[0].name

    partners.name = 'Agrolait'              # assign first partner
    partners[0].name = 'Agrolait'

If ``len(partners) == 0``, return the null value of the field::

    print partners.name                     # False
    print partners.parent_id                # empty recordset

    partners.name = 'Foo'                   # ERROR


The recordset as an instance
----------------------------

Methods of the model's class can be invoked on recordsets::

    # calling convention: leave out cr, uid, ids, context

    # search returns a recordset instead of a list of ids
    roots = partners.search([('parent_id', '=', False)])

    # write on the ids corresponding to the records
    roots.write({...})

    # the list of record ids is accessible
    print roots.ids

The missing parameters are hidden inside the recordset.


The environment object
----------------------

Encapsulates cr, uid, context::

    # recs.env encapsulates cr, uid, context
    recs.env.cr                         # shortcut: recs._cr
    recs.env.uid                        # shortcut: recs._uid
    recs.env.context                    # shortcut: recs._context

    # recs.env also provides helpers
    recs.env.user                       # uid as a record

    recs.env.ref('base.group_user')     # resolve xml id

    recs.env['res.partner']             # access to model

.. nextslide::

Switching environments::

    # rebrowse recs with different parameters
    env2 = recs.env(cr2, uid2, context2)
    recs.with_env(env2)

    # special case: change/extend the context
    recs.with_context(context2)
    recs.with_context(lang='fr')        # kwargs extend current context

    # special case: change the uid
    recs.sudo(user)
    recs.sudo()                         # uid = SUPERUSER_ID


Method decorators
-----------------

In Odoo V8, methods are defined on recordsets.

Decorators enable support of **both** old and new API::

    from openerp import Model, api

    class stuff(Model):

        @api.model
        def search(self, domain, offset=0, limit=None, order=None):
            # self is a recordset, but its content is unused
            ...

        @api.multi
        def write(self, values):
            # self is a recordset, values are written on self.ids
            ...

.. nextslide::

One-by-one or "autoloop" decorator::

    from openerp import Model, api

    class stuff(Model):

        @api.one
        def cancel(self):
            self.state = 'cancel'

    # the method is applied on every record
    recs.cancel()                   # [rec.cancel() for rec in recs]

.. nextslide::

Methods that return recordsets::

    from openerp import Model, api

    class stuff(Model):

        @api.returns('res.partner')
        def root_partner(self):
            p = self.partner_id
            while p.parent_id:
                p = p.parent_id
            return p

When called with the old API, it returns a list of record ids.


Fields as descriptors
---------------------

Python descriptors provide getter/setter (like ``property``)::

    from openerp import Model, fields

    class res_partner(Model):
        _name = 'res.partner'

        name = fields.Char(required=True)
        parent_id = fields.Many2one('res.partner', string='Parent')


Computed fields
---------------

Regular fields with the name of the compute method::

    class res_partner(Model):
        ...

        display_name = fields.Char(
            string='Name', store=False, readonly=True,
            compute='_display_name',
        )

        @api.one
        @api.depends('name', 'parent_id.name')
        def _display_name(self):
            names = [self.parent_id.name, self.name]
            self.display_name = ' / '.join(filter(None, names))

.. nextslide::

The compute method must assign field(s) on records::

    @api.multi
    @api.depends('lines.amount', 'lines.taxes')
    def _amounts(self):
        for order in self:
            order.untaxed = sum(line.amount for line in order.lines)
            order.taxes = sum(line.taxes for line in order.lines)
            order.total = order.untaxed + order.taxes

Field dependencies (``@depends``) are used for
    * cache invalidation and
    * recomputation.


Fields with inverse
-------------------

On may also provide **inverse** and **search** methods::

    class stuff(Model):
        name = fields.Char()
        loud = fields.Char(
            store=False, compute='_compute_loud',
            inverse='_inverse_loud', search='_search_loud',
        )

        @api.one
        @api.depends('name')
        def _compute_loud(self):
            self.loud = (self.name or '').upper()

        ...

.. nextslide::

.. code::

    class stuff(Model):
        name = fields.Char()
        loud = fields.Char(
            store=False, compute='_compute_loud',
            inverse='_inverse_loud', search='_search_loud',
        )

        ...

        @api.one
        def _inverse_loud(self):
            self.name = (self.loud or '').lower()

        def _search_loud(self, operator, value):
            if value is not False:
                value = value.lower()
            return [('name', operator, value)]


Onchange methods
----------------

The new API is similar to compute methods::

    @api.onchange('partner_id')
    def _onchange_partner(self):
        if self.partner_id:
            self.delivery_id = self.partner_id

The record ``self`` is a virtual record:
    * all form values are set on ``self``
    * assigned values are not written to database but returned to
      the client

.. nextslide::

A field element on a form is **automatically** decorated with ``on_change="1"``:
    * if it has an onchange method
    * if it is a dependency of a computed field

This mechanism may be prevented by explicitly decorating a field element with
``on_change="0"``.


Python constraints
------------------

Similar API, with a specific decorator::

    @api.one
    @api.constrains('lines', 'max_lines')
    def _check_size(self):
        if len(self.lines) > self.max_lines:
            raise Warning(_("Too many lines"))

The error message is provided by the exception.
