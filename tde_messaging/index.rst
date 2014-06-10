OpenChatter Integration
=======================

Thibault Delavallée, R&D Engineer

Messaging, OpenChatter
----------------------

.. image:: images/app_mail.png
   :width: 40%
   :align: right

.. image:: images/app_crm.png
   :width: 40%
   :align: right

.. image:: images/app_project.png
   :width: 40%
   :align: right

.. image:: images/app_wms.png
   :width: 40%
   :align: right

.. image:: images/app_cms.png
   :width: 40%
   :align: right

Transversal app

* Discuss with customers on quotations
* Feedback on issues
* Mailing groups
* Discussions on tasks
* Subscribe to Newsletters

.. nextslide::

Transversal features

* OpenChatter
* Communication history
* Subscribe, Followers
* Action counters
* Mail gateway
* Aliases

.. note::

   purpose of talk: give the keys to integrate messaging/openchatter in module; key code, not too many details

Demo
====

OpenChatter / mail.thread
-------------------------

OpenChatter in your model::

    class MyClass(Model):
        _inherit = 'mail.thread'

OpenChatter in your view

.. code-block:: xml

   <div class="oe_chatter">
     <field name="message_follower_ids" widget="mail_followers"/>
     <field name="message_ids" widget="mail_thread"/>
   </div>

And you are done !

.. nextslide::

.. image:: images/chatter_2.png
   :width: 80%
   :align: center

.. nextslide::

What did it do ? new fields, linking messaging models

.. code-block:: python

  _columns = {
    'message_ids': ... # communication history
    'message_follower_ids': ... # followers
    'message_unread': ... # unread messages
  }

  MyClasss MailMessage(Model):
    ...

  class MailMail(Model):
    ...

  class MailFollowers(Model):
    ...

.. nextslide::

What did it do ? new features

.. code-block:: python

  def message_post(...):

  def message_track(...):

  def message_subscribe(...):

  def message_process(...):

Subtypes
--------

Subscription customization

.. image:: images/subtypes_1.png
   :width: 30%
   :align: center
   :class: mt8

Automatic logging

.. image:: images/subtypes_2.png
   :width: 60%
   :align: center
   :class: mt8

.. nextslide::

Define subtypes in XML

.. code-block:: xml

  <record id="mt_task_assigned" model="mail.message.subtype">
    <field name="name">Task Assigned</field>
    <field name="res_model">project.task</field>
    <field name="default" eval="False"/>
  </record>

.. image:: images/subtypes_1.png
   :width: 30%
   :align: center

.. nextslide::

Bind them to the model

.. code-block:: python

  _columns = {
    'user_id': fields.many2one('res.users',
                               track_visibility='onchange'),
  }

  _track = {
    'user_id': {
        'project.mt_task_assigned': lambda self, cr, uid, obj, c=None:
          obj.user_id and obj.user_id.id,
    }
  }

.. note::
  back on project, show subtypes, change user_id, show automatic logging

NeedAction
----------

NeedAction in your model::

    class MyClass(Model):
        _inherit = 'ir.needaction_mixin'


Define a standard `message_unread` search filter

.. code-block:: xml

   <filter string="Unread Messagingges"
           name="message_unread"
           domain="[('message_unread','=',True)]"
           help="Unread messages"/>

.. nextslide::

Action counters

.. image:: images/needaction_1.png
   :width: 35%
   :align: center

Kanban

.. image:: images/needaction_2.png
   :width: 35%
   :align: center

.. note::
  back on project, set messages as unread, show counter, filter on kanban

Email aliases
-------------

Add alias management in your model::

  class MyClass(Model):
    _inherits = {'mail.alias': 'alias_id'}

    _columns = {
      'alias_id': fields.many2one('mail.alias', 'Alias'),
    }

New record -> new alias

.. image:: images/sales_team_1.png
   :width: 45%
   :align: left
   :class: mt16

.. image:: images/project_1.png
   :width: 40%
   :align: right
   :class: mt16

Aliases and Mail Gateway
------------------------

* `alias_contact` -> privacy settings
* `alias_force_thread_id` -> redirect emails to a document's thread or create a new document

.. image:: images/project_2.png
   :width: 70%
   :align: center

.. image:: images/group_1.png
   :width: 40%
   :align: center
   :class: mt16

.. note::
  back on project, show alias privacy, alias name, ... + say more complex configuration can be achieved in settings / using code, easy to customize because app is modular

Summary
-------

* Modular approach: inheritance -> features
* OpenChatter and Followers -> mail.thread
* Needaction -> ir.needaction_mixin
* Mail gateway and mail aliases -> mail.alias
* Customization through subtypes, tracking
* -> inheritance (python)
* -> light model decoration
* -> a bit of subtypes / aliases (XML)
* *Play with it !*

Thanks for your attention
=========================

Questions ? tde@openerp.com