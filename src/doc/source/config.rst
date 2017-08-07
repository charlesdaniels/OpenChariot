###########################
OpenChariot - Configuration
###########################

.. contents::

openchariot.cfg
===============

``openchariot.cfg`` is the primary vehicle for configuring OpenChariot. This
file is located at ``$OC_PREFIX/etc/openchariot/openchariot.cfg``. This file is
a BASH-style configuration file, which is sourced by OpenChariot during startup
- you should quote appropriately.

The keys and their default values are documented below:

``KEY=DEFAULT`` - description.

``OC_MAGIC=OpenChariot`` - this is used by OpenChariot as a sanity check to
ensure it has sourced the correct file, and should never be changed.

``OC_GITSPOOL=/var/openchariot/gitspool`` - each time ``ocutil-spooler`` runs,
for each file in this directory named ``$name.newgit``, a new git repository
will be initialized named ``$name``. The idea is that you could expose this
directory over FTP, NFS, SMB, or similar, and provide your users with a shell
script that would cause a new repo to be initialized for them.

``OC_GITSPOOL_PERM=755`` - the permissions which should be enforced on the
gitspool directory. Permissions on this directory will be updated each time
``ocutil-spooler`` runs.

``OC_GIT_USER=git`` - the user account your git server runs under. This should
almost always be ``git`` if you are exposing git over SSH.

``OC_GIT_GROUP=git`` - the group which your git user belongs to. This should
almost always be ``git`` if you are exposing git over SSH.

``OC_GIT_DIR=/git`` - the directory where you store your git repositories.
Note that OpenCharit will ignore non-bare repositories, and repositories which
do not end with the extension ``.git``.

``OC_GITSPOOL_GROUP=openchariot`` - users in this gruop will have write access
to ``$OC_GITSPOOL_DIR``.

``OC_WWW_ROOT=/usr/local/www/data/`` - the root directory that you would like
OpenChariot to write web componants to. Your project index will be the
``index.html`` of this page.  If your OpenChariot server hosts OpenChariot
only, this should be your WWW root (the default). If OpenChariot shares your
webserver with other services, this can be an arbitrary subdirectory of your
WWW root. For Linux this is frequently ``/var/www``.

``OC_WWW_USER=www`` - the user account which should have ownership of
``$OC_WWW_ROOT`` and all subdirectories and files.

``OC_WWW_GROUP=www`` - the group which should have ownership of
``$OC_WWW_ROOT`` and all subdirectories and files.

``OC_WWW_PERM=755`` - the permission which should be recursively applied to
``$OC_WWW_ROOT``.

``OC_LOGFILE=/var/log/openchariot.log`` - the file you would like OpenChariot
to write log messages to.

``OC_GIT_DUMB_HTTP=YES`` - set to ``YES`` if you would like to server your
repos over the git "dumb HTTP" protocol.

``OC_GIT_DUMB_HTTP_DIR=/git`` - a path appended to ``$OC_WWW_ROOT`` into which
your dumb HTTP repos will be written, if ``OC_GIT_DUMB_HTTP`` is enabled.

``OC_GIT_SUPPRESS_DEBUG=YES`` - if ``YES`` debug messages are squelched,
otherwise they are sent to standard error (and ultimately wind up in the
OpenChariot logfile).

``OC_GIT_SUPPRESS_INFO=NO`` - if ``YES`` info level log messages are squelched,
otherwise they are sent to standard error (and ultimately wind up in the
OpenChariot logfile).
