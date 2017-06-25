########################
OpenChariot Installation
########################

.. contents::

FreeBSD 11
==========

Prerequisites
-------------

BugsEverywhere
~~~~~~~~~~~~~~

Install BE dependencies::

        pkg install python git py27-jinja2 py27-yaml py27-sphinx py27-numpydoc

Clone the BE repo::

        git clone https://gitorious.org/be/be.git

Install BE::

        cd be
        make
        make INSTALL_OPTIONS=" --prefix=/usr/local " install

GitStats
~~~~~~~~

Install dependencies::

        pkg install python git gnuplot

Install GitStats::

        git clone git://github.com/hoxu/gitstats.git
        cd gitstats
        make install

