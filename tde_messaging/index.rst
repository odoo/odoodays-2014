OpenChatter Integration
=======================

Thibault Delavallée

OpenChatter
-----------

Add OpenChatter in your model::

    class MyClass(Model):
        _inherit = 'mail.thread'


OpenChatter Form View

.. code-block:: xml

   <div class="oe_chatter">
     <field name="message_follower_ids" widget="mail_followers"
       groups="base.group_user"/>
     <field name="message_ids" widget="mail_thread"
       placeholder="Share your thoughts about the idea"/>
   </div>

NeedAction
----------

Add NeedAction in your model::

    class MyClass(Model):
        _inherit = 'ir.needaction_mixin'


Action counter based on a standard `message_unread` search filter

.. code-block:: xml

   <filter string="Unread Messages"
           name="message_unread"
           domain="[('message_unread','=',True)]"
           help="Unread messages"/>

Email aliases
-------------

Add alias management in your model::

    class MyClass(Model):
        _inherits = {'mail.alias': 'alias_id'}

        _columns = {
            'alias_id': fields.many2one('mail.alias', 'Alias'),
        }

Will create an alias for each new record.