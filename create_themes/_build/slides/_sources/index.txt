Create Themes for Websites
==========================

By Fabien Pinckaers - Founder & CEO, Odoo

Topics
------

1. Introduction
	* Classical workflow
	* Odoo's CMS workflow
2. Tutorial
	* Starting with a single page
	* Snippets
	* Options
	* Custom Css
3. Example

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

Simple HTML page
================

Starting with a HTML page
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


Snippets
========

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
   :language: sass
   :linenos:

*static/src/css/my_theme-snippet.sass*

.. literalinclude:: code/8.xml
   :language: sass
   :linenos:

Customize my Snippet
--------------------

To insert this new css we need to extend the theme template and replace the default bootstrap by our new css.

*data/my_theme.xml*

.. literalinclude:: code/9.xml
   :language: xml
   :linenos:


Snippet & Javascript
--------------------

It's possible to add **javascript logic** when a snippet has been dropped or appears in the page.

*static/src/js/snippet.js*

.. literalinclude:: code/10.xml
   :language: javascript
   :linenos:


Options
=======

Add Options
-----------

We can add options for every snippets or blocks.

In our case, we add 2 options ( patterns background) for the snippet created before.

*data/options.xml*

.. literalinclude:: code/11.xml
   :language: xml
   :linenos:

Add Options
-----------

In fact, it adds a class-name to the data-selector.

And now, simply create the css to have the desired result.

*static/src/css/my_theme-options.sass*

.. literalinclude:: code/12.xml
   :language: sass
   :linenos:


Custom CSS
-----------

We can override `Bootstrap variables <https://github.com/twbs/bootstrap-sass/blob/master/vendor/assets/stylesheets/bootstrap/_variables.scss>`_ to create your theme.
 
*static/src/css/my_theme.sass*

.. literalinclude:: code/13.xml
   :language: sass
   :linenos:


Summary
=======

Summary
-------

* Infinite customizations
* Easy to understand
* Template inherits
* Bootstrap based
* Only imagination is your limit
* Robust Odoo back-end behind


**... and so much things will come  :)**

Quote
-----

  Think in terms of f#@_°% Snippets!!

  -- nwi


Example
=======



.. slide:: 
   :class: fullscreen
   :inline-contents: True
   
   .. figure:: images/zen.png
      :class: fill



.. slide:: 
   :class: fullscreen
   :inline-contents: True
   
   .. figure:: images/gourmand.png
      :class: fill


.. slide:: 
   :class: fullscreen
   :inline-contents: True
   
   .. figure:: images/odoo.png
      :class: fill

Thank you
=========

And we are hiring a webdesigner. 
Contact cde@odoo.com for more informations.
