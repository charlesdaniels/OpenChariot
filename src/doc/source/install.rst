##########################
OpenChariot - Installation
##########################

.. contents::

Prerequisites
=============

This section documents the installation of OpenChariot's dependencies. If your
distro or operating system provides any/all of these via your native package
manager.

The following dependencies need to be present and available via ``$PATH`` for
OpenChariot to work:

* ``be`` - BugsEverywhere - used to generate bug-tracker page.
* ``gitstats`` - GitStats - used to generate statistics page.
* ``git-arr`` - git-arr - used to generate repo browser.

BugsEverywhere
--------------

Dependencies
~~~~~~~~~~~~

* Python 2.7
* git
* (python) jinja2
* (python) yaml
* (python) sphinx
* (python) numpydoc

Package list for FreeBSD 11::

    python git py27-jinja2 py27-yaml py27-sphinx py27-numpydoc

Package list for macOS (Homebrew)::

    # via brew
    python git

    # via pip
    jinja2 yaml sphinx numpydoc

Installation
~~~~~~~~~~~~

Clone the BE repo::

    git clone https://gitorious.org/be/be.git

Install BE::

    cd be
    make
    make INSTALL_OPTIONS=" --prefix=/usr/local " install

GitStats
--------

Dependencies
~~~~~~~~~~~~

* Python 2.7
* git
* gnuplot

Package list for FreeBSD 11::

    python git gnuplot

Package list for macOS (Homebrew)::

    python git gnuplot

Installation
~~~~~~~~~~~~

Install GitStats::

    git clone git://github.com/hoxu/gitstats.git
    cd gitstats
    make install

git-arr
-------

Dependencies
~~~~~~~~~~~~

* Python 2.7
* (python) bottle
* (python) pygments

Package list for FreeBSD 11::

    python py27-bottle py27-pygments

Package list for macOS (Homebrew)::

    # via brew
    python

    # via pip
    bottle pygments

Installation
~~~~~~~~~~~~

Fetch git-arr::

    git clone git://blitiri.com.ar/git-arr

Install it somewhere convenient ::

    mkdir -p /opt/openchariot
    mv git-arr /opt/openchariot

Add a wrapper to somewhere in ``$PATH``, for example ``/usr/local/bin``::

    #!/bin/sh

    # wrapper for git-arr

    GIT_ARR_PREFIX=/opt/openchariot/git-arr

    $GIT_ARR_PREFIX/git-arr $@


Don't forget to set ``GIT_ARR_PREFIX`` to the actual directory you installed
git-arr to.

We have to use this wrapper, rather than a symlink because ``git-arr`` requires
the libraries it ships with to be in the same directory as it's executable, and
running it via a symlink confuses it on some systems.

Installing OpenChariot
======================

First, make sure you have GNU make installed. This is the default on most Linux
distros. For FreeBSD, it can be found in the ``gmake`` package, and for macOS
it can be installed via homebrew from the ``make`` package.

You should also create a group who can write to OpenChariot's gitspool. Users
in this group who have shell access to your system will be able to cause
OpenChariot to create new git repositories.::

        pw groupadd openchariot

**NOTE**: For Linux, user ``groupadd`` without the ``pw``.

Any users who should have write access to your OpenChariot managed repos should
be added to this group.

Now, you will need to build OpenChariot (if building from source). If you are
installing from a release tarball, you can skip this step::

    make redist
    cd build

By default, OpenChariot installs into ``/usr/local/``. If you would like to
install it to a different prefix, you may do so by passing the prefix
on ``$1``. The following prefixes are valid:

* ``/``
* ``/usr/local/``
* ``$HOME/.local/share/openchariot/``

Relative to the prefix, the following directories must already exist:

* ``etc/``
* ``lib/``
* ``bin/``

Naturally, the prefix must exist.

As an example, to install to the ``/`` prefix, you wold run::

    ./install.pl /

**NOTE**: It is not necessary for the ``bin/`` directory to actually be in your
``$PATH``.

You should now edit the following files according to your preference:

* ``$PREFIX/etc/openchariot/openchariot.cfg`` - configure OpenChariot itself.
* ``$PREFIX/etc/openchariot/git-arr.conf`` - configure git-arr

Assume ``$PREFIX`` is the prefex you selected during installation. 

**NOTE**: ``git-arr.conf`` will be going away in a future release once 
issue ``a58/0bb`` is resolved.

See the configuration document for more information on configuring OpenChariot.

OpenChariot is intended to be run by ``cron``. To this end, you will need to
have ``cron`` run the script ``ocutil-spooler`` on a regular basis. An interval
of 15 minutes is suggested. Note that OpenChariot will refuse to run via the
spooler if ``ocutil-spooler`` is already running, so it *should* be safe to run
as frequently as desired, although this safegard has not been validated
extensively. An example entry in ``/etc/crontab``::

    # OpenChariot update
    */10    *       *       *       *       root    nice ocutil-spooler > /var/log/openchariot.run.log 2>&1

You should also configure your system such that the directory specified by the
configuration value ``OC_WWW_ROOT`` is served over http(s). Configuring your
webserver appropriately is beyond the scope of the OpenChariot documentation.
``lighttpd`` is the suggested webserver for OpenChariot, and is used by the
OpenChariot project itself. However, any webserver should suffice.

Appendix
========

Configuring ``git``
-------------------

If you have not configured git on your server already, you should so so now.
Create a ``git`` group and user. Be sure to set the shell for the git user
to ``git-shell``::

    pw groupadd git
    pw useradd git
    chsh -s `which git-shell` git
    mkdir -p ~git
    mkdir -p ~git/.ssh
    touch ~git/.ssh/authorized_keys
    chmod 700 ~git/.ssh
    chmod 600 ~git/.ssh/authorized_keys
    chown -R git:git ~git

**NOTE**: FreeBSD-style user and group creation semantics are used, you should
use ``groupadd`` and ``useradd`` without the ``pw`` on Linux systems.

Optionally, you may enable a git protocol server, to allow the general public
to clone your repository. Add the following lines to ``/etc/rc.conf``. Note
that this assume your git repositories are stored in ``/git``::

    git_daemon_enable="YES"
    git_daemon_directory="/git"
    git_daemon_flags="--syslog --base-path=/git --export-all --detach"

Then you can start the git daemon via::

    service git_daemon start

Optionally, you may want to enable anonymous http clones of your repos. You
should create a directory on your webserver. For this example, we will assume
your git repositories will be hosted at
``http://example.com/git/reponame.git``.  You should be sure to enable
anonymous directory browsing of ``/git/*`` on your webserver. Make sure that
``ocutil-getconfig`` specified ``OC_GIT_DUMB_HTTP='YES'`` and
``OC_GIT_DUMB_HTTP_DIR=/git`` (or wherever on your webserver you want your
repos to appear); note that as of 0.0.2, these values are the defaults. . Once
this is done, ``ocutil-spooler`` will automatically update all of your repos so
they can be cloned over http. The primary use case for this feature is for
those behind cooperate firewalls who cannot use ``git://`` for clones.
