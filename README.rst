###########
OpenChariot
###########

.. contents::

Overview
========

OpenChariot is a software distribution intended to provide useful services to
aid in developing software. At present, this includes git repository browsing,
statistics generation, bug tracking, and documentation building.

OpenChariot is implemented as a set of modular scripts (currently all sh) which
generate a static website which renders the above services to users, which may
then be served via any webserver (lighttpd is recommended).

Use Cases
---------

OpenChariot is geared for individuals and small groups of 1-25 developers,
either with individual or multiple repositories. OpenChariot is ideal in
situations where a dedicated systems administrator is unavailable, and/or a
more complex and featureful solution such as Gitlab or Gogs would not be
suitable, for example due to running on a server with limited resources
(for example, the $5/mo DigitalOcean droplet does not meet the requirements to
run GitLab).

OpenChariot is not intended to compete with similar solutions like Gitlab or
Gogs, but rather to provide an alternative to the niche segment of the market
for which these solutions are too complex or too heavy.

Project Goals
-------------

* UNIX design philosophy - OpenChariot is comprised of small, interchangeable
  modules which can be used independantly.
* OpenChariot avoids re-inventing the wheel by leveraging existing open-source
  solutions such as GitStats, git-arr, and BugsEverywhere.
* OpenChariot is highly secure - no additional attack surface is exposed, as
  the output of OpenChariot is a simple static site with no database or
  authentication.

Project Non-Goals
-----------------

* Interactive web interface of any kind - users modify the state of OpenChariot
  via ssh and git, the web interface is for viewing only.
* Dynamic web content - all content should be kept static for performance and
  security.
* User "friendliness" OpenChariot is not a solution for beginners, it is
  intended for developers comfortable working with git and UNIX software.
  Beginners should consider some of the other fine solutions on the market such
  as Gitlab or Gogs, and/or non-self-hosted solutions like Github or Bitbucket.

How Do I Install It?
====================

OpenChariot is still early in development, and thus has no prebuilt packages,
and is lacking in detailed installation instructions for most operating
systems. At this time, only the installation procedure for the FreeBSD 11
operating system is documented. It should be fairly straightforward to 
install on other BSD and Linux distributions however.

As the project matures, more detailed information will be added to the
installation procedure, and the installation procedure for a wider varity of
operating systems will be documented.

For installation instructions, please see the doc/ folder.

How Do I Use It?
================

A user's guide is WiP. The jist of it is that after installation, you 
add a cronjob to call ``ocutil-spooler`` every time interval (it can be
frequent, it won't launch if an instance is already running for safty). Users
can simply point their browsers to the appropriate page on your webserver.

How Can I Contribute?
=====================

Patches are gratefully accepted at cdanils [at] fastmail [dot] com.


