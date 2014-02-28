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
