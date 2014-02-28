Layout
======

The core of the default tree layout is designed around organizing the data into
a single descreet location, while allowing a project to change the tree layout.

<topdir>/

	.builder/		topdir marker and target config container
	    config		Default config rule
	    <target>		Alternate config rules.  The default config is
				always read before processing alternate rules.

	scripts/		The location of the build command and the
				builder subdirectory.

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
