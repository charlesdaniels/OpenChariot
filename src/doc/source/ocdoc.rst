#####################################################
OpenChariot - Documenting Projects with ``.ocdoc.sh``
#####################################################

OpenChariot includes a helpful facility for building your project's
documentation, referred to as *ocdoc*. This feature is enabled by placing a
shell script named ``.ocdoc.sh`` in your project's root directory. If this
script is present while ``ocutil-spooler`` is running, then it will be
executed, and the ``html/`` directory relative to your project root will be
taken to contain your project's documentation.

The intended use case is for integration with Sphinx or Doxygen. Your
``.ocdoc.sh`` script should run the appropriate commands to build your
documentation, then move it's output folder to ``./html`` for consumption by
OpenChariot. After the ``.ocdoc.sh`` script is executed successfully, a link to
your documentation will be added to your OpenChariot index page.
