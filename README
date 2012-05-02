About
=====

The builder tool is designed to be generic build-engine for producing packages
for nearly any Linux based platform.  A good portion of the tool's design is
modeled after the Gentoo ebuild tool (as opposed portage), though lacking
actual package management.  The idea is to be able to produce packages using
builder, and install them via whichever package manager is available for a
given platform.  To that end the builder tool tries to make as few assumptions
as possible regarding final packages.

At the core of the builder design is the usage of a build repository which is
fundementally detached from the sources it is building.  Unlike Gentoo's
Portage, builder relies on being stored within an SCM to decide the versions of
packages it is building as opposed to keeping multiple build rules in the same
directory to handle different versions.

What the builder tool is not is a package management tool.  It can not install
packages into the hosted platform, it can not query installed packages, and it
can not remove installed packages.  This removes a huge portion of the
work-load from the build-engine and places it with the package management tool,
where it belongs.  This also gives the system the potential to produce multiple
packages for a variety of platforms from a single build.

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

Usage
=====

builder [options] <package|all> <command> [command-opts]

Options
-------

 -t, --target	Specify a build-target.  This is a generic concept which tells
		builder the name of the config rule to pick up from the
		.builder/ path at the top of the build-tree.  The global config
		.builder/config is always evaluated before evaluating any
		target-specific configs.  This allows for nightly and release
		targets, as well as architecture specific variations.

 -v, --version	Display the builder version.

 -d, --debug	Enable debug logging.

 -h, --help	Display the builder help and exit (may appear anywhere on the
		command line).

Commands
--------

Most of the commands are actually actions, with the exception of the 'query'
command.  Actions inner depend on one another and so requesting one action may
result in multiple actions being taken.  When no action is specified for a
package, then all actions are taken in the following order:
info --build-deps -> sync -> compile -> package -> install

  query		The info is used both internally by builder, as well as allows
		users to query build-tree packages.

		options
		-------

		  -b, --build-deps
		  -d, --depends
		  -n, --name
		  -d, --description
		  -v, --version
		  -u, --source-uri
		  -s, --summary

  sync		Fetch , unpack, and patch any sources from the source uri.  If
		a local source has been checked out into the package directory
		then the fetch/unpack portion simply copies the local checked
		out source to the workdir for compilation.

  compile	Compile the source code.  During this stage the CC, CHOST, LD,
		and a variety of other target-specific variables will be set
		and usable within the build rules script. The predefined
		behavior for this action is to cd into the workdir, produce a
		configure script from the configure.in if necessary, run the
		configure with predefined BUILDER_CONFIG_OPTS, and then perform
		a make with BUILDER_MAKE_OPTS.

  archive	Install the package into the package root and use that
		information to produce a package archive.  The package archive
		is a pax archive unless pax is unavailable on the platform, in
		which case the archive format will be ustar with a .metadata/
		at the top of the archive.  This archive contains all the
		information necessary to convert the archive into alternate
		package formats such as DEB and RPM.

  install	Perform an install into the sysroot, as opposed to the hosted
		platform root.  This allows builds to properly link against
		build dependant libraries/headers w/out working within a
		chroot/mock environment.  By default only build dependant
		packages are installed into the sysroot, though a developer may
		install any package manually using this command.

Tree Layout
===========

The core of the default tree layout is designed around organizing the data into
a single descreet location, while allowing a project to change the tree layout.

<topdir>/

	.builder/		topdir marker and target config container
	    config		Default config rule
	    <target>		Alternate config rules.  The default config is
				always read before processing alternate rules.

	sources/		Source code repository holding source archives
				for various packages.  Caches of SCM aquired
				sources are also stored within this path. The
				contents of this directory should not be
				checked into an the built-tree's SCM. The
				location of this path may be changed within a
				target rule allowing both an upstream sources
				location and a local sources location.  If both
				a local and remote sources location are defined
				then the local sources location will only
				contain the latests sources, either pulled from
				the upstream server as a caching mechanism, or
				produced as part of a local sync of a source
				URI.

	artifacts/		Final binary archives for a package.  Like the
				sources/ path, the contents of this directory
				should never be checked into the build-tree's
				SCM.  The location of this path may be changed
				within a target rule allowing both a an
				upstream artifact location and a local artifact
				location.  If both a remote and a local
				artifact location are defined then the local
				will only contain the newest artifacts, either
				pulled from the upstream server, or produced
				from a local build.

	packages/		Location to package definitions.
	  <category>/		Package category.  This allows one to organize
				packages into groups.  One of the nice things
				about package categories is that they can have
				an explicit Buildrule file which is
				automatically read before reading per-package
				Buildrules.
	    .buildrules		Per-Category build rules shared by all packages
				within this <category>.

	    <package>/		Container for a single package.

		Buildrules	Rules file defining package metadata and
				proceedures for processing a package.

		source/		Optional directory for storing source code.
				The contents of this directory will be copied
				into workdir/<package-name>-<package-version>/
				during the build process.  If the source/
				directory does not exist then the sources are
				fetched from a packages source uri into a
				temporary directory.  SCM URI's are archived up
				and then then final source archives are copied
				into <topdir>/sources for temporary caching.
				Due to the way this directory is used, a
				packaged which is produced from a tarball which
				does not use a source URI will need to be
				extracted into this directory.

		files/		Optional location for storing misc files
				related to the package such as patches, config
				files, etc.  Generally usage of this directory
				is considered a stop-gap until a package can be
				properly placed into a an SCM.


	tmp/			Top-level temporary container.  This can be
				mounted as a tmpfs under Linux to improve build
				performance.
	  <category>/
	    <package>/
		work/		The working directory used when processing a
				build. Primarily this directory will contain
				the package source(s).

		install/	The temporary installation root for the
				package and used to produce the final package
				archive.

		log/		A temporary location which stores the build-log
				information.  Journal files are also stored
				here which track the current stage of a build,
				thus allowing a build to be quickly restarted,
				useful when developing changes on a single
				package out of a local source directory.  This
				directory is created as necessary.

		env/		Environment data for each stage of the build
				process is stored here.  This is pimarily used
				as a debugging aid.

		tmp/		Per-package temporary data.  This exists simply
				to give a package a private temp location
				should they need it.  Nothing within the build
				engine itself relies on this path.
