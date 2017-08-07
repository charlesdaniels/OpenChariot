##################################
OpenChariot - Repository Mirroring
##################################


.. contents::

Disclaimer
==========

The OpenChariot project, as well as it's authors and contributors disclaim any
liability for misuse of the automatic mirroring features. It is up to you to
ensure that your use of these features is in compliance with the terms of
service for any service(s) you use these features with.

Overview
========

OpenChariot provides facilities for automatically mirroring repos from a remote
host to your OpenChariot server (*mirrorfrom*), and for mirroring repos from
your OpenChariot server to a remote host (*mirrorto*).

Mirroring from Remote Hosts to OpenChariot
==========================================

This feature is referred to as *mirrorfrom*, and causes ``ocutil-spooler`` to
clone a specified remote repo to your ``$OC_GIT_DIR``. This operation will
overwrite any repo which already exists with the same name on your OpenChariot
server - **silently**. The resulting repo will be marked as read-only via
``chmod``, and thus pushing to it will not work (by design). The
``description`` file in the root of the repo will be written to indicate that
this is a read only mirror, and will include the URL it was cloned from.

**ATTENTION**: do not use this feature to mirror untrusted repos, as
``.ocdoc.sh`` will be executed like any other repo. If a bad actor takes
control of the remote repo, they effectively have remote code execution on your
OpenChariot server.

To configure mirrorfrom, simply edit
``$OC_PREFIX/etc/openchariot/mirrorfrom.list`` with your text editor of choice.
Then, add a list of repos you would like to mirror, one per line. The repos
should be specified as URLs, for example
``https://github.com/someuser/someproject.git``. The next time
``ocutil-spooler`` is run, it will clone the repo, as well as build any
BugsEverywhere documentation, and run ``.ocdoc.sh`` to build project
documentation.  The only difference between a mirrored repo and a normal one is
that the ``$OC_GIT_DIR/reponame.git`` folder and it's children will be marked
as read-only.

Mirroring to Remote Hosts from OpenChariot
==========================================

This feature is called *mirrorto*, and causes ``ocutil-spooler`` to force-push
a local repo to a remote host (the ``--mirror`` option is used as well).

Before you can use this feature, you should configure your ``$OC_GIT_USER`` to
have password-less SSH access to the remote host. For services like GitLab,
BitBucket, and GitHub, this means adding the public SSH key of this user to
your account. For self-host git servers, you will need to add your
``$OC_GIT_USER``'s public SSH key to ``~/.ssh/authorized_keys`` as the git user
on the remote system.  Mirroring to Remote Hosts from OpenChariot

**ATTENTION**: use caution, as this means your ``$OC_GIT_USER`` will have
un-authenticated write-access to repos on the remote system. Take appropriate
precautions to ensure your ``$OC_GIT_USER`` is not compromised!

Now, you can specify the repos you would like mirrored, and where. You should
use your text editor of choice to edit the file
``$OC_PREFIX/etc/openchariot/mirrorto.list``. This is a newline-delimited of
tab-delimited pairs, such that the first element in each pair is the name of
the local repo (including the ``.git``), and the second element is the full URL
to the remote repo. For example::

    someproject.git        git@github.com/someuser/someproject.git

Note that the two parts **must** be separate by an actual tab character; any
quantity of spaces will **not** work.

The next time ``ocutil-spooler`` is run, the local repo will be force-pushed
over top of the remote one.

Note that nothing will be done to the remote end which would indicate to users
of the remote system that this repo is a mirror. You should indicate this
out-of-band, for example in your README or project description. To this end, it
is suggested that if the remote end has a mirroring service, you should use it
rather than *mirrorto*.

Use Cases
=========

The mirrorfrom and mirrorto features were added to assist in a variety of
common use cases:

* Development is done on an internal OpenChariot server, but is served to the
  public via another service (i.e. GitHub).

* You want automatic backups of your OpenChariot repos, or want to back up your
  repos on another service automatically.

* You have a public OpenChariot server for publicly-visible projects, and a
  private on on your LAN for private projects, but also want your public
  projects accessible via your LAN server.

* You want to do high-availability of your OpenChariot server by mirroring your
  master server to a hot spare.
