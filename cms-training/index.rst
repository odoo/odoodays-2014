Website Training
================

Odoo Days 2014

WiFi
----

public wifi

name
  opendays
pass
  odoo2014

Virtual Machine
---------------

* Install VirtualBox
* Get :file:`Odoo.vdi` and :file:`Odoo.vbox` from the key
* Launch VirtualBox
* :menuselection:`Machine --> Add`
* Select :file:`Odoo.vbox`
* :guilabel:`Start`

.. nextslide::

* :menuselection:`Applications --> System Tools --> UXTerm`
* :command:`cd odoo`
* :command:`git remote add -t master-apiculture dev http://github.com/odoo-dev/odoo.git`
* :command:`git fetch dev`
* :command:`git checkout -b training 3fa6c29`
* :command:`sudo apt-get install python-decorator python-ldap` 

.. note:: password is ``odoo``

.. nextslide::

2 keys with white paste are being passed around, if your fetch is too slow get
one and copy the ``odoo`` repository on the key, it should be checked out at
the correct revision

Sections
--------

.. toctree::
   :maxdepth: 1

   training
   templating
   routing
   overriding
