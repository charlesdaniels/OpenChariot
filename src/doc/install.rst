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

git-arr
~~~~~~~

Install prerequisites::

        pkg install python py27-bottle py27-pygments 

Fetch git-arr::

        git clone git://blitiri.com.ar/git-arr

Install it somewhere convenient and add a wrapper into ``/usr/local/bin``::

        mkdir -p /opt/openchariot
        mv git-arr /opt/openchariot
        touch /usr/local/bin/git-arr
        echo '#!/bin/sh' >> /usr/local/bin/git-arr
        echo '/opt/openchariot/git-arr/git-arr $@' >> /usr/local/bin/git-arr
        chmod +x /usr/local/bin/git-arr

Installing OpenChariot
----------------------

Install the prerequisites::

        pkg install gmake

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


Optionally, you may enable a git protocol server, to allow the general public
to clone your repository. Add the following lines to ``/etc/rc.conf``. Note
that this assume your git repositories are stored in ``/git``::

        git_daemon_enable="YES"
        git_daemon_directory="/git"
        git_daemon_flags="--syslog --base-path=/git --export-all --detach"

Then you can start the git daemon via::

        service git_daemon start

You should now modify the file ``src/core/bin/ocutil-getconfig`` to set your
configuration appropriately. The installer will create all directories
mentioned therein, so it is important that you modify it before installation if
you would like to use something other than the defaults.

You should also create a group who can write to OpenChariot's gitspool::

        pw groupadd openchariot

Any users who should have write access to your OpenChariot managed repos should
be added to this group.

Install OpenChariot. Note that if you would like to modify your installation
prefix, you should edit the PREFIX variable in ``Makefile``::

        gmake install

If the installation completed correctly, you should see no errors printer to
the console; for example::

        % sudo gmake install
        cp "src/core/bin/ocutil-getconfig" "/usr/local/bin"
        cp "src/core/bin/ocutil-process-gitspool" "/usr/local/bin"
        cp "src/core/bin/ocutil-update-be" "/usr/local/bin"
        cp "src/core/bin/ocutil-update-docs" "/usr/local/bin"
        cp "src/core/bin/ocutil-update-gitstats" "/usr/local/bin"
        cp "src/core/bin/ocutil-update-www-perm" "/usr/local/bin"
        cp "src/core/bin/ocutil-validate-dep" "/usr/local/bin"
        cp "src/core/bin/ocutil-validate-dirs" "/usr/local/bin"
        ocutil-validate-dep
        ocutil-validate-dirs

After installation has completed, you may want to modify the file
``PREFIX/etc/openchariot/git-arr.conf`` to configure the behaviour of git-arr.
