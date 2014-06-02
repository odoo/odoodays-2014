Create Themes for Websites
==========================

By Fabien Pinckaers - Founder & CEO, Odoo

Topics
------
#. Introduction
	*  Classical workflow
	*  Odoo's CMS workflow  
#. Tutorial
	* Starting with a single page
	* Build with snippets
	* Add Options
	* Custom CSS
#. Scaffolding
	* Start a project
	* Deploy a theme



Introduction
============

Classical workflow
------------------

.. image:: images/illus1.png   
   :width: 70%
   

Working with Odoo CMS
---------------------

.. image:: images/illus2.png   
   :width: 70%

Tutorial
========

A Theme?
--------

| 
| 
| 
| 
| 
.. centered:: A Theme is an Odoo's MODULE
(Without Python Logic)


Structure of a Theme
--------------------

* My Theme
	* static
  		* src
			* js, css, font, xml, img
	* data
		* my_theme.xml 
		* snippets.xml
		* options.xml
		* [ ... ]
	* views
		* pages.xml (static pages)



Starting with a html page
-------------------------

Let's start with the homepage.

*data/pages.xml*
	
.. literalinclude:: code/1.xml
   :language: xml
   :linenos:

Starting with a html page
-------------------------

Add the Odoo context :
( with Bootstrap front-end framework, Edition bar, Snippets, etc. )

*data/pages.xml*
	
.. literalinclude:: code/2.xml
   :language: xml
   :linenos:

Starting with a html page
-------------------------

It's possible to create all the page like this way.

*data/pages.xml*

.. literalinclude:: code/3.xml
   :language: xml
   :linenos:

Build with snippets
-------------------

But instead of creating all the pages this way, 
we think about using "Building Blocks".

We call them "**Snippets**".

- Block of html code usable everywhere.
- Draggable in your page.
- Can countains Javascript or/and Css logics.

| 
.. image:: images/illus3.png   
   :width: 100%

A very Simple Snippet
----------------------

Extend the snippet template and add a section.

*data/snippet.xml*

.. literalinclude:: code/4.xml
   :language: xml
   :linenos:


A very Simple Snippet
----------------------

Create a thumbnail for the snippet.

*data/snippet.xml*

.. literalinclude:: code/5.xml
   :language: xml
   :linenos:


A very Simple Snippet
----------------------

The content.

*data/snippet.xml*

.. literalinclude:: code/6.xml
   :language: xml
   :linenos:

Customize my Snippet
--------------------

We can customize this simple snippet with SASS/CSS.

*static/src/css/my_theme.sass*

.. literalinclude:: code/7.xml
   :language: css
   :linenos:

*static/src/css/my_theme-snippet.sass*

.. literalinclude:: code/8.xml
   :language: css
   :linenos:

Customize my Snippet
--------------------

To insert this new css we need to extend the theme template and replace the default bootstrap by our new css.

*data/my_theme.xml*

.. literalinclude:: code/9.xml
   :language: css
   :linenos:


Snippet & Javascript
--------------------

It's possible to add **javascript logic** when a snippet has been dropped or appears in the page.

We have several methods in Odoo website module ( eg. website.snippets.animation.js )






Add Options
-----------

Custom CSS
-----------

Scaffolding
===========

Start a project
---------------

Deploy a theme
--------------

Thanks You
==========

