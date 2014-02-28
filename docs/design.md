Design
======

The builder tool attempts to aid in the development workflow model attached to
SCM's as opposed to being a central package management tool.  To this end
builder does not utilize a global repository, but instead expects to find its
config rules and build rules within the current working tree, much like an SCM.
When invoking builder it will locate the top of the build tree by looking for a
.builder the current-working directory and all parent directories.  The default
configuration used by the builder tool is .builder/config, though alternate
names may be supplied with the --type argument to the builder command.  This is
useful for changing things like global CFLAGS to enable debugging, profiling,
or tune optimizations.

The builder tool uses make as the job-engine allowing packages to be compiled
in parallel.  The Makefile used by make is dynamically constructed by builder
and the final output tries to conform to the very sparse POSIX Makefile
standard.  To that end there are no GNU Make assumptions.

In being able to work with a distributed development model, the builder system
allows a developer to easily produce package builds from local copies of the a
package source.  This is done in such a way that the developer's local sources
are never touched by the builder tool to aid in the production of patches and
changes which may be pushed back up to the upstream source uri.

Like Gentoo ebuilds, the builder system uses simple shell-based scripts to
define various rules for a package, with many of the rules having generic
predifined versions which will work with the vast-majority of Open Source
software.  This means that in a best-case scenario a package simply need to
define the version, source uri, and description.


