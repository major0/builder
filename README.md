Builder
=======

[Builder][builder] supplies a psuedo package-management environment usable for
everything from maintaining cross-development toolchains, to producing binary
blocks for individual packages and disk images. The original design was
inspired by [Gentoo's][gentoo] [Ebuild][ebuild] build rules used by
[Portage][portage], with the primary goal being to manage the cross-development
tools along side the software being developed in a single [Portage-like][portage]
directory structure.  [Builder][builder] deviates from the [Portage][portage]
use-case in that it does not manage packages within the OS, but simply produces
packages as defined by rule files and manages the installation of packages (and
their dependancies) into a sysroot target.  These rule files may dictate how to
build a specific piece of software, or may dictate how to build disk images.

 * [Installation](docs/installation.md)
 * [Usage](docs/usage.md)
 * [Design](docs/design.md)
 * [Layout](docs/layout.md)
 * [Copyright](docs/copyright.md)
 * [Credit](docs/credit.md)

[builder]: https://github.com/major0/builder "Builder"
[gentoo]: http://en.wikipedia.org/wiki/Gentoo_Linux "Gentoo Linux"
[ebuild]: http://en.wikipedia.org/wiki/Ebuild "Ebuild"
[portage]: http://en.wikipedia.org/wiki/Portage "Portage"
